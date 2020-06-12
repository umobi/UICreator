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

private extension UIView {
    var reusableAxis: ReusableViewAxis? {
        get { objc_getAssociatedObject(self, &kReusableAxis) as? ReusableViewAxis }
        set { objc_setAssociatedObject(self, &kReusableAxis, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    var reusableUpdateBatch: ((UIView) -> Void)? {
        get { objc_getAssociatedObject(self, &kReusableUpdateBatch) as? (UIView) -> Void }
        set { objc_setAssociatedObject(self, &kReusableUpdateBatch, newValue, .OBJC_ASSOCIATION_COPY) }
    }
}

protocol ReusableView: class {
    var hostedView: ViewCreator! { get }
    var contentView: UIView { get }

    func prepareCell(_ cell: UICCell, axis: ReusableViewAxis)

    var cellLoaded: UICCell.Loaded! { get set }
}

struct ReusableObject {
    weak var viewCreator: ViewCreator!
    init(_ viewCreator: ViewCreator) {
        self.viewCreator = viewCreator
    }
}

private var kHostedView: UInt = 0
extension ReusableView {
    private var mutableReusableObject: Mutable<ReusableObject?> {
        OBJCSet(self, &kHostedView) {
            .init(value: nil)
        }
    }

    private var reusableObject: ReusableObject! {
        get { self.mutableReusableObject.value }
        set { self.mutableReusableObject.value = newValue }
    }

    fileprivate(set) var hostedView: ViewCreator! {
        get { self.reusableObject.viewCreator }
        set { self.reusableObject = .init(newValue) }
    }
}

extension ReusableView {
//    func newAddView(_ hosted: ViewCreator) {
//        self.contentView.subviews.forEach {
//            $0.removeFromSuperview()
//        }
//
//        self.hostedView = hosted
//        self.contentView.add(priority: .init(500), hosted.releaseUIView())
//    }

    func addView(_ axis: ReusableViewAxis) {
        guard let cellLoaded = self.cellLoaded else {
            return
        }

        self.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }

        let host = cellLoaded.cell.rowManager.payload.content()
        self.hostedView = host

        let hostedView: UIView! = host.releaseUIView()

        if hostedView.reusableAxis != axis {
            hostedView.reusableAxis = axis
            hostedView.reusableUpdateBatch = {
                guard
                    let reusableView = sequence(first: $0, next: { $0.superview })
                        .first(where: { $0 is ReusableView })
                        as? ReusableView & UIView,
                    let collectionView = sequence(first: reusableView.contentView, next: { $0.superview })
                        .first(where: { $0 is TableCellType || $0 is CollectionCellType })
                else {
                    return
                }

                switch collectionView {
                case is TableCellType:
                    guard
                        let tableView = sequence(first: collectionView, next: { $0.superview })
                            .first(where: { $0 is UITableView }) as? UITableView
                    else { return }

                    tableView.itemHeightUpdate(
                        $0,
                        rowManager: reusableView.cellLoaded.cell.rowManager
                    )

                    if #available(iOS 11, tvOS 11, *) {
                        tableView.addUniqueCallback {
                            UIView.performWithoutAnimation {
                                tableView.performBatchUpdates(nil, completion: nil)
                            }
                        }
                        return
                    }

                    tableView.addUniqueCallback {
                        UIView.performWithoutAnimation {
                            tableView.beginUpdates()
                            tableView.endUpdates()
                        }
                    }
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

        UIView.CBSubview(self.contentView).addSubview(hostedView)
        switch axis {
        case .center:
            Constraintable.activate(
                hostedView.cbuild
                    .center
                    .equalTo(self.contentView)
                    .priority(.init(500))
            )

        case .horizontal:
            Constraintable.activate(
                hostedView.cbuild
                    .centerY
                    .equalTo(self.contentView.cbuild.centerY)
                    .priority(.init(500)),

                hostedView.cbuild
                    .leading
                    .trailing
                    .equalTo(self.contentView)
                    .priority(.init(500))
            )
        case .vertical:
            Constraintable.activate(
                hostedView.cbuild
                    .centerX
                    .equalTo(self.contentView.cbuild.centerX)
                    .priority(.init(500)),

                hostedView.cbuild
                    .top
                    .bottom
                    .equalTo(self.contentView)
                    .priority(.init(500))
            )
        }
    }

//    func newReusableCell(_ cell: UICCell) {
//        if self.cellLoaded == nil {
//            let cellLoaded = cell.load
//            let new = cellLoaded.cell.rowManager.payload.content()
//            self.cellLoaded = cellLoaded
//            self.newAddView(new)
//            return
//        }
//
//        guard self.cellLoaded?.cell.rowManager !== cell.rowManager else {
//            return
//        }
//
//        let cellLoaded = cell.load
//        let new = cellLoaded.cell.rowManager.payload.content()
//        let old = self.hostedView
//        self.cellLoaded = cellLoaded
//
//        if let old = old {
//            if !ReplacementTree(old).replace(with: new) {
//                self.newAddView(new)
//            }
//        } else {
//            self.newAddView(new)
//        }
//    }

    func reuseCell(_ cell: UICCell, axis: ReusableViewAxis) {
        if self.cellLoaded == nil {
            self.cellLoaded = cell.load
            self.addView(axis)
            return
        }

        guard self.cellLoaded?.cell.rowManager !== cell.rowManager else {
            return
        }

        self.cellLoaded = cell.load
        self.addView(axis)
    }

    func prepareCell(_ cell: UICCell, axis: ReusableViewAxis) {
        self.reuseCell(cell, axis: axis)
    }
}

protocol TableCellType {

}

protocol CollectionCellType {

}

var kTableViewCallbackIsPending = 0
extension UITableView {
    func itemHeightUpdate(_ view: UIView, rowManager: ListManager.RowManager) {
        let cellType = rowManager.payload.contentType
        let indexPath = rowManager.indexPath
        switch cellType {
        case .footer:
            let sizeCache = self.sizeManager.footer(at: indexPath.section) ?? .headerFooter(indexPath.section)
            self.sizeManager.updateFooter(sizeCache.height(view.frame.height))
        case .header:
            let sizeCache = self.sizeManager.header(at: indexPath.section) ?? .headerFooter(indexPath.section)
            self.sizeManager.updateHeader(sizeCache.height(view.frame.height))
        case .row:
            print("Reloading", indexPath)
            let sizeCache = self.sizeManager.row(at: indexPath) ?? .cell(indexPath)
            self.sizeManager.updateRow(sizeCache.height(view.frame.height))
        }
    }

    var callbackIsPending: Mutable<Bool> {
        OBJCSet(
            self,
            &kTableViewCallbackIsPending,
            orLoad: { .init(value: false) }
        )
    }

    func addUniqueCallback(_ callback: @escaping () -> Void) {
        if self.callbackIsPending.value {
            return
        }

        self.callbackIsPending.value = true
        OperationQueue.main.addOperation {
            self.callbackIsPending.value = false
            callback()
        }
    }
}
