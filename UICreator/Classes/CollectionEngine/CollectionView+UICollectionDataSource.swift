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

extension _CollectionView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.manager?.numberOfSections ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let manager = self.manager else {
            return 0
        }

        return manager.numberOfRows(in: manager.section(at: section))
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let row = self.manager?.row(at: indexPath) else {
            fatalError()
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.identifier, for: indexPath) as? CollectionViewCell else {
            fatalError()
        }

        cell.prepareCell(row)

        if let item = self.layoutManager?.item(at: indexPath), item.isDynamic, let loaded = cell.cellLoaded {
            _ = cell.contentView.subviews.first?.appendLayout { [weak self, loaded] view in
                guard item.modified(item.modify(at: loaded.cell.rowManager.indexPath)
                    .horizontal(.equalTo(view.frame.width))
                    .vertical(.equalTo(view.frame.height))) else { return }

                self?.collectionViewLayout.invalidateLayout()
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = self.manager?.header(at: indexPath.section) else {
                assert(false)
            }

            guard let cell = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: header.identifier, for: indexPath) as? CollectionReusableView else {
                fatalError()
            }

            cell.prepareCell(header)

            if let item = self.layoutManager?.header(at: indexPath.section), item.isDynamic, let loaded = cell.cellLoaded {
                _ = cell.contentView.subviews.first?.appendLayout { [weak self, loaded] view in
                    guard item.modified(item.modify(at: loaded.cell.rowManager.indexPath.section)
                        .horizontal(.equalTo(view.frame.width))
                        .vertical(.equalTo(view.frame.height))) else { return }

                    self?.collectionViewLayout.invalidateLayout()
                }
            }
            return cell

        case UICollectionView.elementKindSectionFooter:
            guard let footer = self.manager?.footer(at: indexPath.section) else {
                assert(false)
            }

            guard let cell = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footer.identifier, for: indexPath) as? CollectionReusableView else {
                fatalError()
            }

            cell.prepareCell(footer)

            if let item = self.layoutManager?.footer(at: indexPath.section), item.isDynamic, let loaded = cell.cellLoaded {
                _ = cell.contentView.subviews.first?.appendLayout { [weak self, loaded] view in
                    guard item.modified(item.modify(at: loaded.cell.rowManager.indexPath.section)
                        .horizontal(.equalTo(view.frame.width))
                        .vertical(.equalTo(view.frame.height))) else { return }

                    self?.collectionViewLayout.invalidateLayout()
                }
            }
            return cell

        default:
            assert(false)
        }
    }
}
