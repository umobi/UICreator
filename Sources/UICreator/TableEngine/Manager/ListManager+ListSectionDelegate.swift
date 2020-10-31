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

extension ListManager: ListSectionDelegate {
    private func update(sections: [ListManager.SectionManager]) {
        guard let list = self.list else {
            self.sections = sections
            return
        }

        self.list = nil

        let oldRowIdentifier = self.rowsIdentifier
        let oldHeadersIdentifier = self.headersIdentifier
        let oldFootersIdentifier = self.footersIdentifier

        self.sections = sections
        sections.forEach {
            $0.loadForEachIfNeeded()
        }

        self.list = list

        let newRows: [String] = self.rowsIdentifier.compactMap {
            oldRowIdentifier.contains($0) ? nil : $0
        }

        let newHeaders: [String] = self.headersIdentifier.compactMap {
            oldHeadersIdentifier.contains($0) ? nil: $0
        }

        let newFooters: [String] = self.footersIdentifier.compactMap {
            oldFootersIdentifier.contains($0) ? nil: $0
        }

        switch list {
        case let table as UITableView:
            newRows.forEach {
                table.register(Views.TableViewCell.self, forCellReuseIdentifier: $0)
            }

            (newHeaders + newFooters).forEach {
                table.register(Views.TableViewHeaderFooterCell.self, forHeaderFooterViewReuseIdentifier: $0)
            }

        case let collection as UICollectionView:
            newRows.forEach {
                collection.register(Views.CollectionViewCell.self, forCellWithReuseIdentifier: $0)
            }
        default:
            break
        }
        
        list.setNeedsReloadData()
    }

    @usableFromInline
    func content(updateSection: ListManager.SectionManager) {
        self.update(sections: self.sections.map {
            $0.index == updateSection.index ? updateSection : $0
        })
    }

    func updatedSections(
        _ compactCopy: ListManager.SectionManager.Copy,
        updatedWith sequence: [ListManager.SectionManager]) -> [ListManager.SectionManager] {
        guard
            let first = self.sections
                .enumerated()
                .reversed()
                .last(where: {
                    $0.element.identifier >= compactCopy.identifier
                })
            else { return self.sections + sequence }

        if self.sections[first.offset].identifier == compactCopy.identifier {
            return Array(self.sections[0..<first.offset]) +
                sequence +
                Array(self.sections[first.offset+1..<self.sections.count])
                    .filter {
                        $0.identifier != compactCopy.identifier
                    }
        }

        return Array(self.sections[0..<first.offset]) +
            sequence +
            Array(self.sections[first.offset..<self.sections.count])
    }

    @usableFromInline
    func content(_ section: ListManager.SectionManager.Copy, updateSections: [ListManager.SectionManager]) {
        self.update(
            sections: self.updatedSections(
                section,
                updatedWith: updateSections
            )
            .enumerated()
            .map {
                $0.element.index($0.offset)
            }
        )
    }
}
