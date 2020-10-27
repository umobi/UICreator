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

@usableFromInline
protocol ListCollectionManager: class {
    var sections: [ListManager.SectionManager] { get }

    var numberOfSections: Int { get }
    func numberOfRows(in section: ListManager.SectionManager) -> Int
    func row(at indexPath: IndexPath) -> UICCell
}

extension ListCollectionManager {
    @usableFromInline
    var headers: [(Int, ListManager.RowManager)] {
        return self.sections.enumerated().compactMap {
            guard let header = $0.element.header else {
                return nil
            }

            return ($0.offset, header)
        }
    }

    @usableFromInline
    var footers: [(Int, ListManager.RowManager)] {
        return self.sections.enumerated().compactMap {
            guard let footer = $0.element.footer else {
                return nil
            }

            return ($0.offset, footer)
        }
    }

    @usableFromInline
    func numberOfRows(in section: ListManager.SectionManager) -> Int {
        return section.rows.count
    }

    @usableFromInline
    var numberOfSections: Int {
        return self.sections.count
    }

    @usableFromInline
    func section(at index: Int) -> ListManager.SectionManager {
        return self.sections[index]
    }

    @usableFromInline
    var rowsIdentifier: [String] {
        return Array(Set(self.sections.map { section in
            section.rows.map {
                "\(section.identifier).\($0.identifier).row"
            }
        }.reduce([]) { $0 + $1 }))
    }

    @usableFromInline
    var headersIdentifier: [String] {
        return Array(Set(self.sections.compactMap { section in
            guard section.header != nil else {
                return nil
            }

            return "\(section.identifier).header"
        }))
    }

    @usableFromInline
    var footersIdentifier: [String] {
        return Array(Set(self.sections.compactMap { section in
            guard section.footer != nil else {
                return nil
            }

            return "\(section.identifier).footer"
        }))
    }

    @usableFromInline
    func row(at indexPath: IndexPath) -> UICCell {
        let section = self.section(at: indexPath.section)
        let row = section.rows[indexPath.row]

        return .init("\(section.identifier).\(row.identifier).row", row)
    }

    @usableFromInline
    func header(at section: Int) -> UICCell? {
        let section = self.section(at: section)

        guard let header = section.header else {
            return nil
        }

        return .init("\(section.identifier).header", header)
    }

    @usableFromInline
    func footer(at section: Int) -> UICCell? {
        let section = self.section(at: section)

        guard let footer = section.footer else {
            return nil
        }

        return .init("\(section.identifier).footer", footer)
    }
}
