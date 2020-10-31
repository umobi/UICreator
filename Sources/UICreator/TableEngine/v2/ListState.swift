//
//  File.swift
//  
//
//  Created by brennobemoura on 31/10/20.
//

import Foundation
import ConstraintBuilder

struct Frozen<Content, Index> {
    let content: Content
    let index: Index

    init(_ content: Content,_ index: Index) {
        self.content = content
        self.index = index
    }
}

class ListForEachListener<Content>: SupportForEach {
    @Relay var contents: [Content]

    init(_ forEachEnviroment: ForEachEnviromentType) {
        _contents = .constant([])
        forEachEnviroment.setManager(self)
        forEachEnviroment.syncManager()
    }
}

extension ListForEachListener {
    func viewsDidChange(_ placeholderView: CBView!, _ dynamicContent: Relay<[() -> ViewCreator]>) {
        _contents = dynamicContent.map {
            $0.reduce([]) { $0 + [$1() as! Content] }
        }
    }
}

enum ListContent<Element> {
    case `static`(Element)
    case dynamic(ForEachEnviromentType)
}

extension ListSupport {
    func invalidateState(_ newState: List) {

    }
}

extension List {
    static func rebuild(_ listView: ListSupport!, _ contents: [UICRow], at indexPath: IndexPath) {
        print("RowsDidChange")
    }

    static func rebuild(_ listView: ListSupport!, _ sections: [UICSection], at index: Int) {
        print("SectionsDidChange")
    }

    static func section(_ listView: ListSupport, _ rows: [ListContent<ViewCreator>], at index: Int = .zero) -> Section {
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

    private init(_ listView: ListSupport, rows: [ListContent<ViewCreator>]) {
        self.sections = [.init(Self.section(listView, rows, at: .zero), Int.zero)]
    }

    private init(_ listView: ListSupport, sections: [ListContent<ViewCreator>]) {
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

    static func rows(
        header: ViewCreator? = nil,
        footer: ViewCreator? = nil,
        contents: [ViewCreator]) -> [ListContent<ViewCreator>] {

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

    static func castAndReturnRows(_ contents: [ViewCreator]) -> [ListContent<ViewCreator>]? {
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

        if contents.allSatisfy({ $0 is UICRow }) {
            return rows(contents: contents)
        }

        return nil
    }

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

@usableFromInline
struct List {
    let sections: [Frozen<Section, Int>]
}

@usableFromInline
struct Section {
    let header: Row?
    let rows: [Frozen<Row, IndexPath>]
    let footer: Row?

    init(header: Row?, footer: Row?, rows: [Frozen<Row, IndexPath>]) {
        self.header = header
        self.footer = footer
        self.rows = rows
    }
}

extension Section {
    @usableFromInline
    enum Content {
        case `static`(Row)
        case dynamic([Row])
    }
}

import UIKit

extension Row {
    @usableFromInline
    enum ContentType {
        case header(Int)
        case footer(Int)

        case row(
                trailingActions: [RowAction],
                leadingActions: [RowAction],
                accessoryType: UITableViewCell.AccessoryType,
                indexPath: IndexPath
             )
    }
}

@usableFromInline
struct Row {
    let content: ViewCreator
    let type: ContentType

    init(_ header: UICHeader, _ index: Int) {
        self.content = header.content()
        self.type = .header(index)
    }

    init(_ footer: UICFooter, _ index: Int) {
        self.content = footer.content()
        self.type = .footer(index)
    }

    init(_ row: UICRow, _ indexPath: IndexPath) {
        self.content = row.content()
        self.type = .row(
            trailingActions: row.trailingActions?().zip ?? [],
            leadingActions: row.leadingActions?().zip ?? [],
            accessoryType: row.accessoryType,
            indexPath: indexPath
        )
    }
}

@usableFromInline
struct Identifier<ID, Content> {
    let id: ID
    let content: Content

    init(_ id: ID, _ content: Content) {
        self.id = id
        self.content = content
    }
}

@usableFromInline
protocol ListModifier {
    var state: List { get }

    var numberOfSections: Int { get }
    func numberOfRows(in index: Int) -> Int
    func row(at indexPath: IndexPath) -> Identifier<String, Row>
}

@usableFromInline
struct ListState: ListModifier {
    @usableFromInline
    let state: List

    init(_ listView: ListSupport,_ contents: [ViewCreator]) {
        self.state = .init(listView, contents)
    }
}

extension ListModifier {
    @usableFromInline
    var headers: [Identifier<String, Row>] {
        self.state.sections.compactMap {
            guard let header = $0.content.header else {
                return nil
            }

            return Identifier("\($0.index).header", header)
        }
    }

    @usableFromInline
    var footers: [Identifier<String, Row>] {
        self.state.sections.compactMap {
            guard let footer = $0.content.footer else {
                return nil
            }

            return Identifier("\($0.index).footer", footer)
        }
    }

    @usableFromInline
    var rows: [Identifier<String, Row>] {
        self.state.sections.reduce([]) {
            let section = $1

            return $0 + section.content.rows.map {
                .init("\(section.index).\($0.index)", $0.content)
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
    func header(at index: Int) -> Identifier<String, Row>? {
        let section = self.state.sections[index]
        guard let header = section.content.header else {
            return nil
        }

        return Identifier("\(section.index).header", header)
    }

    @usableFromInline
    func footer(at index: Int) -> Identifier<String, Row>? {
        let section = self.state.sections[index]
        guard let footer = section.content.footer else {
            return nil
        }

        return Identifier("\(section.index).footer", footer)
    }

    @usableFromInline
    func row(at indexPath: IndexPath) -> Identifier<String, Row> {
        let section = self.state.sections[indexPath.section]
        let row = section.content.rows[indexPath.row]

        return Identifier("\(section.index).\(row.index).row", row.content)
    }
}
