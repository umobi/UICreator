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

private var kCollectionViewCellLayoutHandler = 0
private extension UIView {
    private var collectionLayoutHandler: ((UIView) -> Void)? {
        get { objc_getAssociatedObject(self, &kCollectionViewCellLayoutHandler) as? ((UIView) -> Void) }
        set { objc_setAssociatedObject(self, &kCollectionViewCellLayoutHandler, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    @discardableResult
    func onCellLayout(_ handler: @escaping (UIView) -> Void) -> Self {
        guard self.collectionLayoutHandler == nil else {
            self.collectionLayoutHandler = handler
            return self
        }

        self.collectionLayoutHandler = handler

        return self.onLayout { [weak self] in
            self?.collectionLayoutHandler?($0)
        }
    }
}

class UICCollectionViewDataSource: NSObject, UICollectionViewDataSource {}

extension UICCollectionViewDataSource {
    internal typealias DataSourceFatal = UICollectionView.DataSourceFatal

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionView.manager?.numberOfSections ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let manager = collectionView.manager else {
            return 0
        }

        return manager.numberOfRows(in: manager.section(at: section))
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let row = collectionView.manager?.row(at: indexPath) else {
            DataSourceFatal.unexpectedRow(indexPath).die()
        }

        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: row.identifier,
                for: indexPath
            ) as? CollectionViewCell
        else {
            DataSourceFatal.unexpectedRow(indexPath).die()
        }

        cell.prepareCell(row, axis: .horizontal)

        guard
            let item = collectionView.layoutManager?
                .item(at: indexPath),
            item.isDynamic,
            let loaded = cell.cellLoaded
        else {
            return cell
        }

        cell.hostedView.onCellLayout { [weak collectionView, loaded] view in
            guard view.frame.size != .zero else {
                return
            }

            guard let item = collectionView?.layoutManager?.item(at: indexPath) else {
                return
            }

            guard item.modified(item.modify(at: loaded.cell.rowManager.indexPath)
                .horizontal(.equalTo(view.frame.width))
                .vertical(.equalTo(view.frame.height))) else {
                    return
            }

            collectionView?.collectionViewLayout.invalidateLayout()
        }

        return cell
    }

    // swiftlint:disable function_body_length cyclomatic_complexity
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        // MARK: - Section Header
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.manager?.header(at: indexPath.section) else {
                DataSourceFatal.unexpectedHeader(indexPath).die()
            }

            guard
                let cell = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: header.identifier,
                    for: indexPath) as? CollectionReusableView
            else {
                DataSourceFatal.unexpectedHeader(indexPath).die()
            }

            cell.prepareCell(header, axis: .center)

            guard
                let item = collectionView.layoutManager?
                    .header(at: indexPath.section),
                item.isDynamic,
                let loaded = cell.cellLoaded
            else {
                return cell
            }

            cell.hostedView.onCellLayout { [weak collectionView, loaded] view in
                guard view.frame.size != .zero else {
                    return
                }

                guard let item = collectionView?.layoutManager?.header(at: indexPath.section) else {
                    return
                }

                guard item.modified(item.modify(at: loaded.cell.rowManager.indexPath.section)
                    .horizontal(.equalTo(view.frame.width))
                    .vertical(.equalTo(view.frame.height))) else { return }

                collectionView?.collectionViewLayout.invalidateLayout()
            }

            return cell

        // MARK: - Section Footer
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.manager?.footer(at: indexPath.section) else {
                DataSourceFatal.unexpectedFooter(indexPath).die()
            }

            guard
                let cell = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: footer.identifier,
                    for: indexPath) as? CollectionReusableView
            else {
                DataSourceFatal.unexpectedFooter(indexPath).die()
            }

            cell.prepareCell(footer, axis: .horizontal)

            guard
                let item = collectionView.layoutManager?.footer(at: indexPath.section),
                item.isDynamic,
                let loaded = cell.cellLoaded
            else {
                return cell
            }

            cell.hostedView.onCellLayout { [weak collectionView, loaded] view in
                guard view.frame.size != .zero else {
                    return
                }

                guard let item = collectionView?.layoutManager?.footer(at: indexPath.section) else {
                    return
                }

                guard item.modified(item.modify(at: loaded.cell.rowManager.indexPath.section)
                    .horizontal(.equalTo(view.frame.width))
                    .vertical(.equalTo(view.frame.height))) else { return }

                collectionView?.collectionViewLayout.invalidateLayout()
            }

            return cell

        default:
            DataSourceFatal.unrecognizedSupplementaryElement(kind, indexPath).die()
        }
    }
}

extension UICollectionView {
    enum DataSourceFatal: FatalType {
        case unexpectedRow(IndexPath)
        case unexpectedHeader(IndexPath)
        case unexpectedFooter(IndexPath)

        case unrecognizedSupplementaryElement(String, IndexPath)

        // swiftlint:disable line_length
        var error: String {
            switch self {
            case .unexpectedRow(let indexPath):
                return """
                UICollectionDataSource can't dequeue cell as expected at \(indexPath)
                """
            case .unexpectedHeader(let indexPath):
                return """
                UICollectionDataSource can't dequeue header as expected at \(indexPath)
                """
            case .unexpectedFooter(let indexPath):
                return """
                UICollectionDataSource can't dequeue footer as expected at \(indexPath)
                """
            case .unrecognizedSupplementaryElement(let identifier, let indexPath):
                return """
                UICollectionDataSource can't resolve supplementary element with identifier equals to \(identifier) at \(indexPath)
                """
            }
        }
    }
}
