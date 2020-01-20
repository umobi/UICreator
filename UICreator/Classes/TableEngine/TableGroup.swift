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

extension UICList {
    public struct Group {
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

        var sections: [Element.Section] {
            let sections: [Element.Section] = self.elements.compactMap {
                $0.asSection
            }

            if sections.isEmpty {
                return [Element.section(self.elements).asSection!]
            }

            return sections
        }

        var headers: [(Int, Element.Header)] {
            return self.elements.compactMap {
                $0.asHeader
            }.enumerated().map { ($0.0, $0.1) }
        }

        var footers: [(Int, Element.Footer)] {
            return self.elements.compactMap {
                $0.asFooter
            }.enumerated().map { ($0.0, $0.1) }
        }

        var rows: [(Int, Element.Row)] {
            return self.elements.compactMap {
                $0.asRow
            }.enumerated().map { ($0.0, $0.1) }
        }

        func numberOfRows(in section: Element.Section) -> Int {
            return section.group.rows.reduce(0) {
                $0 + (($1.1.quantity == 0) ? 1 : $1.1.quantity)
            }
        }

        var numberOfSections: Int {
            let sections = self.sections
            if !sections.isEmpty {
                return sections.count
            }

            return self.numberOfRows(in: Element.section(self.elements).asSection!)
        }

        func section(at index: Int) -> Element.Section {
            let sections = self.sections
            if sections.isEmpty {
                return Element.section(self.elements).asSection!
            }

            if sections.count <= index, let last = sections.last {
                return last
            }

            return sections[index]
        }

        var rowsIdentifier: [String] {
            return self.sections.enumerated().map { section in
                section.element.group.rows.map { row -> String in
                    return "\(section.offset)-\(row.1.identifier ?? "\(row.0)")"
                }
            }.reduce([]) { $0 + $1 }
        }

        var headersIdentifier: [String] {
            return self.sections.enumerated().map { section in
                section.element.group.headers.map { header -> String in
                    return "\(header.0).header"
                }
            }.reduce([]) { $0 + $1 }
        }

        var footersIdentifier: [String] {
            return self.sections.enumerated().map { section in
                section.element.group.footers.map { footer -> String in
                    return "\(footer.0).footer"
                }
            }.reduce([]) { $0 + $1 }
        }

        func row(at indexPath: IndexPath) -> (String, Element.Builder)? {
            let section = self.section(at: indexPath.section)
            guard let row: (Int, Element.Row) = ({
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

            return ("\(indexPath.section)-\(row.1.identifier ?? "\(row.0)")", row.1.content)
        }

        func header(at section: Int) -> (String, Element.Builder)? {
            let section = self.section(at: section)

            guard let header = section.group.headers.first else {
                return nil
            }
            
            return ("\(header.0).header", header.1.content)
        }

        func footer(at section: Int) -> (String, Element.Builder)? {
            let section = self.section(at: section)

            guard let footer = section.group.footers.first else {
                return nil
            }

            return ("\(footer.0).footer", footer.1.content)
        }
    }
}

extension UICList.Element {
    typealias Builder = () -> ViewCreator
}

extension UICList.Group {
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
