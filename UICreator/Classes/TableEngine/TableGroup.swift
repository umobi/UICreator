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

protocol UICListCollectionElements: class {
    var elements: [UICList.Element] { get }

    var numberOfSections: Int { get }
    func numberOfRows(in section: UICList.Element.Section) -> Int
    func row(at indexPath: IndexPath) -> (String, UICList.Element.Payload)?
}

extension UICListCollectionElements {
    var containsSection: Bool {
        return self.elements.first(where: {
            return $0.isSection
        }) != nil
    }

    var containsOnlySection: Bool {
        return self.elements.allSatisfy {
            return $0.isSection
        }
    }

    var sections: [UICList.Element.Section] {
        let sections: [UICList.Element.Section] = self.elements.compactMap {
            $0.asSection
        }

        return (sections.isEmpty ?
            [UICList.Element.section(self.elements).asSection!] :
            sections
        ).enumerated().map {
            $0.element.index = $0.offset
            return $0.element
        }
    }

    var headers: [(Int, UICList.Element.Header)] {
        return self.elements.compactMap {
            $0.asHeader
        }.enumerated().map { ($0.0, $0.1) }
    }

    var footers: [(Int, UICList.Element.Footer)] {
        return self.elements.compactMap {
            $0.asFooter
        }.enumerated().map { ($0.0, $0.1) }
    }

    var rows: [(Int, UICList.Element.Row)] {
        return self.elements.compactMap {
            $0.asRow
        }.enumerated().map { ($0.0, $0.1) }
    }

    func numberOfRows(in section: UICList.Element.Section) -> Int {
        return section.group.rows.reduce(0) {
            $0 + (($1.1.quantity == 0) ? 1 : $1.1.quantity)
        }
    }

    var numberOfSections: Int {
        let sections = self.sections
        if !sections.isEmpty {
            return sections.count
        }

        return self.numberOfRows(in: UICList.Element.section(self.elements).asSection!)
    }

    func section(at index: Int) -> UICList.Element.Section {
        let sections = self.sections
        if sections.isEmpty {
            return UICList.Element.section(self.elements).asSection!
        }

        if sections.count <= index, let last = sections.last {
            return last
        }

        return sections[index]
    }

    var rowsIdentifier: [String] {
        return self.sections.enumerated().map { section in
            section.element.group.rows.map { row -> String in
                return row.1.identifier ?? "\(section.offset)-\(row.0)"
            }
        }.reduce([]) { $0 + $1 }
    }

    var headersIdentifier: [String] {
        return self.sections.enumerated().map { section in
            section.element.group.headers.map { header -> String in
                return header.1.identifier ?? "\(header.0).header"
            }
        }.reduce([]) { $0 + $1 }
    }

    var footersIdentifier: [String] {
        return self.sections.enumerated().map { section in
            section.element.group.footers.map { footer -> String in
                return footer.1.identifier ?? "\(footer.0).footer"
            }
        }.reduce([]) { $0 + $1 }
    }

    func row(at indexPath: IndexPath) -> (String, UICList.Element.Payload)? {
        let section = self.section(at: indexPath.section)
        guard let row: (Int, UICList.Element.Row) = ({
            if self.numberOfRows(in: section) <= indexPath.row {
                if let last = section.group.rows.last, last.1.quantity == 0, last.0 <= indexPath.row {
                    return last
                }

                return nil
            }

            return section.group.rows.first(where: { row in
                if row.1.quantity >= 1 {
                    return (row.0..<row.0+row.1.quantity).contains(indexPath.row)
                }
                return row.0 == indexPath.row
            })
        }()) else {
            return nil
        }

        return (row.1.identifier ?? "\(indexPath.section)-\(row.0)", row.1.payload)
    }

    func header(at section: Int) -> (String, UICList.Element.Payload)? {
        let section = self.section(at: section)

        guard let header = section.group.headers.first else {
            return nil
        }

        return (header.1.identifier ?? "\(header.0).header", header.1.payload)
    }

    func footer(at section: Int) -> (String, UICList.Element.Payload)? {
        let section = self.section(at: section)

        guard let footer = section.group.footers.first else {
            return nil
        }

        return (footer.1.identifier ?? "\(footer.0).footer", footer.1.payload)
    }
}

public extension UICList {
    class GroupAddingAction: UICListCollectionElements {
        let group: Group
        var elements: [UICList.Element] {
            return self.group.elements
        }

        init(_ group: Group) {
            self.group = group
        }

        private var includeIndexPath: [IndexPath] = []
        private var includeSections: [Int] = []

        func includeIndexPath(_ indexPath: IndexPath) -> Self {
            self.includeIndexPath.append(indexPath)
            return self
        }

        func includeIndexPaths(_ indexPaths: [IndexPath]) -> Self {
            self.includeIndexPath = indexPaths
            return self
        }

        func includeSections(_ sections: [Int]) -> Self {
            self.includeSections = sections
            return self
        }

        func numberOfRows(in section: UICList.Element.Section) -> Int {
            let numberOfRows = self.group.numberOfRows(in: section)

            guard self.includeIndexPath.contains(where: {
                $0.section == section.index
            }) else { return numberOfRows }

            return numberOfRows + self.includeIndexPath.reduce(0) { $0 + ($1.section == section.index ? 1 : 0 )}
        }

        var numberOfSections: Int {
            return self.group.numberOfSections + IndexSet(self.includeSections).count
        }
    }

    class GroupRemovingAction: UICListCollectionElements {
        let group: Group
        var elements: [UICList.Element] {
            return self.group.elements
        }

        private var disableIndexPath: [IndexPath] = []
        private var disableSections: [Int] = []

        init(_ group: Group) {
            self.group = group
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

        func numberOfRows(in section: UICList.Element.Section) -> Int {
            let numberOfRows = self.group.numberOfRows(in: section)

            guard self.disableIndexPath.contains(where: {
                $0.section == section.index
            }) else { return numberOfRows }

            return numberOfRows - self.disableIndexPath.reduce(0) { $0 + ($1.section == section.index ? 1 : 0 )}
        }

        var numberOfSections: Int {
            return self.group.numberOfSections - IndexSet(self.disableSections).count
        }
    }
}

extension UICList {
    public class Group: UICListCollectionElements {
        private let _elements: [UICList.Element]?
        let manager: ListManager?

        internal init(_ manager: ListManager) {
            self._elements = nil
            self.manager = manager
        }

        internal init(_ elements: [UICList.Element]) {
            self._elements = elements
            self.manager = nil
        }

        var elements: [UICList.Element] {
            return self._elements ?? manager?.elements ?? []
        }
    }
}

public extension UICList.Element {
    struct Payload {
        let content: () -> ViewCreator
        let trailingActions: (() -> [RowAction])?
        let leadingActions: (() -> [RowAction])?

        init(_ content: @escaping () -> ViewCreator) {
            self.content = content
            self.trailingActions = nil
            self.leadingActions = nil
        }

        init(row: UICRow) {
            self.content = row.content
            self.trailingActions = row.trailingActions
            self.leadingActions = row.leadingActions
        }
    }
//    typealias Builder = () -> ViewCreator
}

extension UICListCollectionElements {
    public var isValid: Bool {
        return self.isValid()
    }

    private func isValid(isInsideSection: Bool = false) -> Bool {
        let isRoot = self.containsSection

        if isRoot {
            guard !isInsideSection else {
                return false
            }

            if !self.containsOnlySection {
                return false
            }

            return self.sections.allSatisfy {
                $0.group.isValid(isInsideSection: true)
            }
        }

        let headers = self.headers
        if !headers.isEmpty && (headers.count > 1 || headers.first?.0 != 0) {
            return false
        }

        let footers = self.elements.enumerated().filter {
            $0.element.isFooter
        }

        if !footers.isEmpty && (footers.count > 1 || footers.first?.0 != self.elements.count - 1) {
            return false
        }

        return true
    }
}
