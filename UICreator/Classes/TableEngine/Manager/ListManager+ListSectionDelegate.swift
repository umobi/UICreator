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

extension ListManager: ListSectionDelegate {
    func content(_ section: ListManager.ContentSection, updateSections: [ListManager.ContentSection]) {
        var updateSections = updateSections
        let oldRowIdentifier = self.list.group?.rowsIdentifier ?? []
        self.contents = self.contents.reduce([]) {
            if $1.identifier == section.identifier {
                let toAppend = updateSections
                updateSections = []
                return $0 + toAppend
            }

            return $0
        }

        let newRows: [String] = (self.list.group?.rowsIdentifier ?? []).compactMap {
            if oldRowIdentifier.contains($0) {
                return nil
            }

            return $0
        }

        if !newRows.isEmpty {
            switch self.list {
            case let table as UITableView:
                newRows.forEach {
                    table.register(TableViewCell.self, forCellReuseIdentifier: $0)
                }

            case let collection as UICollectionView:
                newRows.forEach {
                    collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: $0)
                }
            default:
                break
            }
        }

        self.list.reloadData()
    }
}
