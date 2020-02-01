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

struct UICCell {
    let rowManager: ListManager.RowManager
    let identifier: String

    init(_ identifier: String,_ manager: ListManager.RowManager) {
        self.rowManager = manager
        self.identifier = identifier
    }

    struct Loaded {
        let cell: UICCell
        let trailingActions: [RowAction]
        let leadingActions: [RowAction]

        init(_ cell: UICCell) {
            self.cell = cell
            self.trailingActions = cell.rowManager.payload.trailingActions?() ?? []
            self.leadingActions = cell.rowManager.payload.leadingActions?() ?? []
        }
    }

    var load: Loaded {
        return .init(self)
    }
}

protocol UICListCollectionElements: class {
    var sections: [ListManager.SectionManager] { get }

    var numberOfSections: Int { get }
    func numberOfRows(in section: ListManager.SectionManager) -> Int
    func row(at indexPath: IndexPath) -> UICCell
}

extension UICListCollectionElements {
    var headers: [(Int, ListManager.RowManager)] {
        return self.sections.enumerated().compactMap {
            guard let header = $0.element.header else {
                return nil
            }

            return ($0.offset, header)
        }
    }

    var footers: [(Int, ListManager.RowManager)] {
        return self.sections.enumerated().compactMap {
            guard let footer = $0.element.footer else {
                return nil
            }

            return ($0.offset, footer)
        }
    }
    
    func numberOfRows(in section: ListManager.SectionManager) -> Int {
        return section.rows.count
    }

    var numberOfSections: Int {
        return self.sections.count
    }

    func section(at index: Int) -> ListManager.SectionManager {
        return self.sections[index]
    }

    var rowsIdentifier: [String] {
        return Array(Set(self.sections.map { section in
            section.rows.map {
                "\(section.identifier).\($0.identifier).row"
            }
        }.reduce([]) { $0 + $1 }))
    }

    var headersIdentifier: [String] {
        return Array(Set(self.sections.compactMap { section in
            guard section.header != nil else {
                return nil
            }

            return "\(section.identifier).header"
        }))
    }

    var footersIdentifier: [String] {
        return Array(Set(self.sections.compactMap { section in
            guard section.footer != nil else {
                return nil
            }

            return "\(section.identifier).footer"
        }))
    }

    func row(at indexPath: IndexPath) -> UICCell {
        let section = self.section(at: indexPath.section)
        let row = section.rows[indexPath.row]

        return .init("\(section.identifier).\(row.identifier).row", row)
    }

    func header(at section: Int) -> UICCell? {
        let section = self.section(at: section)

        guard let header = section.header else {
            return nil
        }

        return .init("\(section.identifier).header", header)
    }

    func footer(at section: Int) -> UICCell? {
        let section = self.section(at: section)

        guard let footer = section.footer else {
            return nil
        }

        return .init("\(section.identifier).footer", footer)
    }
}

extension ListManager {
    class Append: UICListCollectionElements {
        let manager: ListManager

        var sections: [ListManager.SectionManager] {
            return self.manager.sections
        }

        init(_ manager: ListManager) {
            self.manager = manager
        }
    }

    class Delete: UICListCollectionElements {
        let manager: ListManager

        var sections: [ListManager.SectionManager] {
            return self.manager.sections
        }

        private var disableIndexPath: [IndexPath] = []
        private var disableSections: [Int] = []

        init(_ manager: ListManager) {
            self.manager = manager
        }

        func disableIndexPath(_ indexPath: IndexPath) -> Self {
            self.disableIndexPath.append(indexPath)
            return self
        }

        func disableIndexPaths(_ indexPaths: [IndexPath]) -> Self {
            self.disableIndexPath = indexPaths
            return self
        }

        func disableSections(_ sections: [Int]) -> Self {
            self.disableSections = sections
            return self
        }

        func numberOfRows(in section: ListManager.SectionManager) -> Int {
            let numberOfRows = self.manager.numberOfRows(in: section)

            guard self.disableIndexPath.contains(where: {
                $0.section == section.index
            }) else { return numberOfRows }

            return numberOfRows - self.disableIndexPath.reduce(0) { $0 + ($1.section == section.index ? 1 : 0 )}
        }

        var numberOfSections: Int {
            return self.manager.numberOfSections - IndexSet(self.disableSections).count
        }
    }
}
