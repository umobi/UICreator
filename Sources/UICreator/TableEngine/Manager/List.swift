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
struct List {
    let sections: [List.Frozen<Section, Int>]

    @inline(__always)
    fileprivate init(_ frozenSections: [List.Frozen<Section, Int>]) {
        self.sections = frozenSections
    }

    @inline(__always)
    private init(_ listView: ListSupport, rows: [List.Content<ViewCreator>]) {
        self.sections = [.init(Self.section(listView, rows, at: .zero), Int.zero)]
    }

    private init(_ listView: ListSupport, sections: [List.Content<ViewCreator>]) {
        self.sections = sections.enumerated().reduce([]) { sum, slice in
            switch slice.element {
            case .static(let viewCreator):
                guard let section = viewCreator as? UICSection else {
                    fatalError()
                }

                return sum + [.init(Self.section(
                    listView,
                    Self.castAndReturnRows(section.contents().zip)!,
                    at: slice.offset
                ), slice.offset)]

            case .dynamic(let enviroment):
                let listener = ListForEachListener<UICSection>(enviroment)

                listener.$contents.next { [weak listView] in
                    Self.rebuild(listView, $0, at: slice.offset)
                }

                return sum + listener.contents.map {
                    .init(
                        Self.section(listView, Self.castAndReturnRows($0.contents().zip)!, at: slice.offset),
                        slice.offset
                    )
                }
            }
        }
    }
}

extension List {
    init(_ listView: ListSupport, _ contents: [ViewCreator]) {
        if let rows = Self.castAndReturnRows(contents) {
            self.init(listView, rows: rows)
            return
        }

        self.init(listView, sections: contents.map {
            if let forEachShared = $0 as? ForEachEnviromentShared {
                return .dynamic(forEachShared.enviroment)
            }

            if $0 is UICSection {
                return .static($0)
            }

            fatalError()
        })
    }
}

extension List {
    static func section(_ listView: ListSupport, _ rows: [List.Content<ViewCreator>], at index: Int = .zero) -> Section {
        .init(
            header: {
                guard
                    case .static(let viewCreator) = rows.first,
                    let header = viewCreator as? UICHeader
                else { return nil }

                return Row(header, index)
            }(),

            footer: {
                guard
                    case .static(let viewCreator) = rows.last,
                    let footer = viewCreator as? UICFooter
                else { return nil }

                return Row(footer, index)
            }(),

            rows: {
                rows.enumerated().reduce([]) { sum, slice in
                    switch slice.element {
                    case .static(let viewCreator):
                        guard let row = viewCreator as? UICRow else {
                            return sum
                        }

                        let indexPath = IndexPath(row: slice.offset, section: index)
                        return sum + [.init(Row(row, indexPath), indexPath)]

                    case .dynamic(let enviroment):
                        let listener = ListForEachListener<UICRow>(enviroment)

                        let indexPath = IndexPath(row: slice.offset, section: index)

                        listener.$contents.next { [weak listView] in
                            Self.rebuild(listView, $0, at: indexPath)
                        }

                        return sum + listener.contents.enumerated().map {
                            .init(Row($1, .init(row: indexPath.row + $0, section: index)), indexPath)
                        }
                    }
                }
            }()
        )
    }
}

extension List {
    static func rows(
        header: ViewCreator? = nil,
        footer: ViewCreator? = nil,
        contents: [ViewCreator]) -> [List.Content<ViewCreator>] {

        return (header.map { [ .static($0) ]} ?? []) + contents.map {
            if $0 is UICRow {
                return .static($0)
            }

            if let forEachShared = $0 as? ForEachEnviromentShared, forEachShared.enviroment.contentType == UICRow.self {
                return .dynamic(forEachShared.enviroment)
            }

            fatalError()
        } + (footer.map { [ .static($0) ]} ?? [])
    }
}

extension List {
    static func castAndReturnRows(_ contents: [ViewCreator]) -> [List.Content<ViewCreator>]? {
        if contents.first is UICHeader || contents.last is UICFooter {
            if !(contents.first is UICHeader) {
                return rows(
                    footer: contents.last,
                    contents: contents.dropLast()
                )
            }

            if !(contents.last is UICFooter) {
                return rows(
                    header: contents.first,
                    contents: Array(contents.dropFirst())
                )
            }

            return rows(
                header: contents.first,
                footer: contents.last,
                contents: contents.dropFirst().dropLast()
            )
        }

        if contents.allSatisfy({ $0 is UICRow || ($0 as? ForEachEnviromentShared)?.enviroment.contentType == UICRow.self }) {
            return rows(contents: contents)
        }

        return nil
    }
}

extension List {
    static func rebuild(_ listView: ListSupport!, _ contents: [UICRow], at indexPath: IndexPath) {
        guard let oldList = listView.modifier?.state else {
            fatalError()
        }

        let sectionThatNeedsToBeUpdated = oldList.sections[indexPath.section]
        let leftRows = sectionThatNeedsToBeUpdated.content.rows[0..<indexPath.row]
        let rightRows = sectionThatNeedsToBeUpdated.content.rows[indexPath.row..<sectionThatNeedsToBeUpdated.content.rows.count].filter { $0.index != indexPath }

        let rowsToUpdate = List(listView, contents).sections.first?.content.rows.map {
            Frozen($0.content, indexPath)
        } ?? []

        let updatedSection = Frozen(
            Section(
                header: sectionThatNeedsToBeUpdated.content.header,
                footer: sectionThatNeedsToBeUpdated.content.footer,
                rows: leftRows + rowsToUpdate + rightRows
            ),
            sectionThatNeedsToBeUpdated.index
        )

        let updatedSections = oldList.sections[0..<indexPath.section]
            + [updatedSection]
            + oldList.sections[indexPath.section+1..<oldList.sections.count]

        listView.invalidateState(.init(Array(updatedSections)))
    }

    static func rebuild(_ listView: ListSupport!, _ sections: [UICSection], at index: Int) {
        print("SectionsDidChange")
    }
}
