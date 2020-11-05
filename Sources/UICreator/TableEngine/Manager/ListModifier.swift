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

@usableFromInline
protocol ListModifier {
    var state: List { get }

    func update(_ list: List) -> Self

    var numberOfSections: Int { get }
    func numberOfRows(in index: Int) -> Int
    func row(at indexPath: IndexPath) -> List.Identifier<String, Row>
}

extension ListModifier {
    @usableFromInline
    var headers: [List.Identifier<String, Row>] {
        self.state.sections.compactMap {
            guard let header = $0.content.header else {
                return nil
            }

            return List.Identifier("\($0.index).header", header)
        }
    }

    @usableFromInline
    var footers: [List.Identifier<String, Row>] {
        self.state.sections.compactMap {
            guard let footer = $0.content.footer else {
                return nil
            }

            return List.Identifier("\($0.index).footer", footer)
        }
    }

    @usableFromInline
    var rows: [List.Identifier<String, Row>] {
        self.state.sections.reduce([]) {
            let section = $1

            return $0 + section.content.rows.map {
                .init("\(section.index).\($0.index).row", $0.content)
            }
        }
    }
}

extension ListModifier {
    @inline(__always) @usableFromInline
    var numberOfSections: Int {
        self.state.sections.count
    }

    @inline(__always) @usableFromInline
    func numberOfRows(in index: Int) -> Int {
        self.state.sections[index].content.rows.count
    }
}

extension ListModifier {
    @usableFromInline
    func header(at index: Int) -> List.Identifier<String, Row>? {
        let section = self.state.sections[index]
        guard let header = section.content.header else {
            return nil
        }

        return List.Identifier("\(section.index).header", header)
    }

    @usableFromInline
    func footer(at index: Int) -> List.Identifier<String, Row>? {
        let section = self.state.sections[index]
        guard let footer = section.content.footer else {
            return nil
        }

        return List.Identifier("\(section.index).footer", footer)
    }

    @usableFromInline
    func row(at indexPath: IndexPath) -> List.Identifier<String, Row> {
        let section = self.state.sections[indexPath.section]
        let row = section.content.rows[indexPath.row]

        return List.Identifier("\(section.index).\(row.index).row", row.content)
    }
}
