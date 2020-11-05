//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import UIKit
import ConstraintBuilder

enum ReusableViewAxis {
    case vertical
    case horizontal
    case center
}

private var kReusableAxis = 0
private var kReusableUpdateBatch = 0

private extension CBView {
    var reusableAxis: ReusableViewAxis? {
        get { objc_getAssociatedObject(self, &kReusableAxis) as? ReusableViewAxis }
        set { objc_setAssociatedObject(self, &kReusableAxis, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    var reusableUpdateBatch: ((CBView) -> Void)? {
        get { objc_getAssociatedObject(self, &kReusableUpdateBatch) as? (CBView) -> Void }
        set { objc_setAssociatedObject(self, &kReusableUpdateBatch, newValue, .OBJC_ASSOCIATION_COPY) }
    }
}

protocol ListReusableView: class {
    var hostedView: CBView! { get set }
    var contentView: CBView { get }

    func prepare(_ row: Row, axis: ReusableViewAxis)

    var row: Row! { get set }
}

extension ListReusableView {
    private func addConstraints(_ hostedView: CBView, _ axis: ReusableViewAxis) {
        CBView.CBSubview(self.contentView).addSubview(hostedView)

        switch axis {
        case .center:
            Constraintable.activate {
                hostedView.cbuild
                    .center
                    .equalTo(self.contentView)
                    .priority(.init(500))
            }

        case .horizontal:
            Constraintable.activate {
                hostedView.cbuild
                    .centerY
                    .equalTo(self.contentView.cbuild.centerY)
                    .priority(.init(500))

                hostedView.cbuild
                    .leading
                    .trailing
                    .equalTo(self.contentView)
                    .priority(.init(500))
            }
        case .vertical:
            Constraintable.activate {
                hostedView.cbuild
                    .centerX
                    .equalTo(self.contentView.cbuild.centerX)
                    .priority(.init(500))

                hostedView.cbuild
                    .top
                    .bottom
                    .equalTo(self.contentView)
                    .priority(.init(500))
            }
        }
    }
}

extension ListReusableView {
    func addView(_ axis: ReusableViewAxis) {
        guard let row = self.row else {
            return
        }

        self.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }

        let host = row.content

        let hostedView: CBView! = host.releaseUIView()
        self.hostedView = hostedView

        if hostedView.reusableAxis != axis {
            hostedView.reusableAxis = axis
            hostedView.reusableUpdateBatch = {
                guard
                    let reusableView = sequence(first: $0, next: { $0.superview })
                        .first(where: { $0 is ListReusableView })
                        as? ListReusableView & CBView,
                    let collectionView = sequence(first: reusableView.contentView, next: { $0.superview })
                        .first(where: { $0 is TableCellType || $0 is CollectionCellType })
                else {
                    return
                }

                switch collectionView {
                //swiftlint:disable colon
                case is TableCellType:
                    Self.updateTableViewBatching(
                        listView: collectionView,
                        reusableView: reusableView,
                        view: $0
                    )

                case is CollectionCellType:
                    guard
                        let collectionView = sequence(first: collectionView, next: { $0.superview })
                            .first(where: { $0 is UICollectionView }) as? UICollectionView
                    else { return }

                    // TO-DO: CollectionView layout
                default:
                    return
                }
            }

            hostedView.onLayout {
                $0.reusableUpdateBatch?($0)
            }
        }

        self.addConstraints(hostedView, axis)
    }
}

extension ListReusableView {
    func prepare(_ row: Row, axis: ReusableViewAxis) {
        if self.row == nil {
            self.row = row
            self.addView(axis)
            return
        }

//        guard self.row.content != cell.rowManager else {
//            return
//        }

        self.row = row
        self.addView(axis)
    }
}

extension ListReusableView {
    static func updateTableViewBatching(
        listView: CBView,
        reusableView: CBView & ListReusableView,
        view: CBView) {

        guard
            let tableView = sequence(first: listView, next: { $0.superview })
                .first(where: { $0 is UITableView }) as? UITableView
        else { return }

        guard
            tableView.needsToUpdateHeightOf(
                view, reusableView.row
            )
            else { return }

        tableView.itemHeightUpdate(
            view,
            reusableView.row
        )

        if #available(iOS 11, tvOS 11, *) {
            tableView.addUniqueCallback {
                CBView.performWithoutAnimation {
                    tableView.performBatchUpdates(nil, completion: nil)
                }
            }
            return
        }

        tableView.addUniqueCallback {
            CBView.performWithoutAnimation {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }
}

protocol TableCellType {

}

protocol CollectionCellType {

}

extension UITableView {
    func needsToUpdateHeightOf(_ view: CBView, _ row: Row) -> Bool {
        switch row.type {
        case .footer(let index):
            guard
                let sizeCache = self.sizeManager.footer(at: index),
                sizeCache.size.height == view.frame.height
                else { return true }

            return false
        case .header(let index):
            guard
                let sizeCache = self.sizeManager.header(at: index),
                sizeCache.size.height == view.frame.height
                else { return true }

            return false
        case .row(_, _, _, let indexPath):
            guard
                let sizeCache = self.sizeManager.row(at: indexPath),
                sizeCache.size.height == view.frame.height
                else { return true }

            return false
        }
    }

    func itemHeightUpdate(_ view: CBView, _ row: Row) {
        switch row.type {
        case .footer(let index):
            let sizeCache = self.sizeManager.footer(at: index) ?? .headerFooter(index)
            self.sizeManager.updateFooter(sizeCache.height(view.frame.height))
        case .header(let index):
            let sizeCache = self.sizeManager.header(at: index) ?? .headerFooter(index)
            self.sizeManager.updateHeader(sizeCache.height(view.frame.height))
        case .row(_, _, _, let indexPath):
            let sizeCache = self.sizeManager.row(at: indexPath) ?? .cell(indexPath)
            self.sizeManager.updateRow(sizeCache.height(view.frame.height))
        }
    }
}

var kTableViewCallbackIsPending = 0
extension UITableView {
    private var callbackIsPending: Bool {
        get { objc_getAssociatedObject(self, &kTableViewCallbackIsPending) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &kTableViewCallbackIsPending, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    func addUniqueCallback(_ callback: @escaping () -> Void) {
        if self.callbackIsPending {
            return
        }

        self.callbackIsPending = true
        OperationQueue.main.addOperation {
            self.callbackIsPending = false
            callback()
        }
    }
}