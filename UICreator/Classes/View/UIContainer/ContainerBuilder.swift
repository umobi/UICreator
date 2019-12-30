//
//  ContainerBuilder.swift
//  UICreator
//
//  Created by brennobemoura on 27/12/19.
//

import Foundation
import UIContainer

internal class TableViewCell: UITableViewCell {
    private(set) var builder: ViewCreator! = nil

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.commitNotRendered()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }

    func prepareCell(content: @escaping () -> ViewCreator) {
        guard self.builder == nil else {
            return
        }

        let builder = content()
        self.builder = builder
        _ = self.contentView.add(builder.uiView)
    }

    public override var watchingViews: [UIView] {
        return self.contentView.subviews
    }
}

extension Table {
    public struct Group {
        let elements: [Element]
        public init(_ elements: [Element]) {
            self.elements = elements
        }

        public init(_ elements: Element...) {
            self.elements = elements
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
                return [Element.section(self).asSection]
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
                $0 + $1.1.quantity
            }
        }

        var numberOfSections: Int {
            let sections = self.sections
            if !sections.isEmpty {
                return sections.count
            }

            return self.numberOfRows(in: Element.section(self).asSection)
        }

        func section(at index: Int) -> Element.Section {
            let sections = self.sections
            if !sections.isEmpty {
                return Element.section(self).asSection
            }

            return sections[index]
        }

        var rowsIdentifier: [String] {
            return self.sections.enumerated().map { section in
                section.element.group.rows.map { row -> String in
                    return "\(section.offset)-\(row.0)"
                }
            }.reduce([]) { $0 + $1 }
        }

        func row(at indexPath: IndexPath) -> (String, () -> ViewCreator)? {
            let section = self.section(at: indexPath.section)
            guard let row: (Int, Element.Row) = ({
                if self.numberOfRows(in: section) <= indexPath.row {
                    if let last = rows.last, last.1.quantity == 1, last.0 <= indexPath.row {
                        return last
                    }

                    return nil
                }

                return section.group.rows.first(where: { row in
                    if row.1.quantity > 1 {
                        return (row.0..<row.0+row.1.quantity).contains(indexPath.row)
                    }
                    return row.0 == indexPath.row
                })
            }()) else {
                return nil
            }

            return ("\(indexPath.section)-\(row.0)", row.1.content)
        }
    }
    
    public enum ContentType {
        case header//(_ content: (() -> ViewCreator)? = nil)
        case row//(_ content: () -> ViewCreator)
//        case rowSequence//(_ index: [Int], _ content: () -> ViewCreator)
        case footer//(_ content: () -> ViewCreator)
        case section//(Group)
    }

    public enum Content {
        case group(Group)
        case content(_ content: () -> ViewCreator)
        case empty
    }

    public class Element {
        let type: ContentType
        let content: Content
        let max: Int

        private init(_ type: ContentType, content: Content, max: Int = 1) {
            self.type = type
            self.content = content
            self.max = max
            if !self.isValid {
                fatalError("Table.Element is not valid")
            }
        }

        public static func header(content: @escaping () -> ViewCreator) -> Element {
            return .init(.header, content: .content(content))
        }

        public static func footer(content: @escaping () -> ViewCreator) -> Element {
            return .init(.header, content: .content(content))
        }

        public static func row(content: @escaping () -> ViewCreator) -> Element {
            return .init(.row, content: .content(content))
        }

        public static func rows(max: Int, content: @escaping () -> ViewCreator) -> Element {
            return .init(.row, content: .content(content))
        }

        public static func section(_ group: Group) -> Element {
            return .init(.section, content: .group(group))
        }

        var isSection: Bool {
            return self.type == .section
        }

        var isFooter: Bool {
            return self.type == .footer
        }

        var isRow: Bool {
            return self.type == .row
        }

        var isHeader: Bool {
            return self.type == .header
        }

        class Section {
            let group: Group

            fileprivate init?(_ element: Element) {
                guard case .section = element.type, case .group(let group) = element.content else {
                    return nil
                }

                self.group = group
            }

            fileprivate init(_ group: Group) {
                self.group = group
            }
        }

        var asSection: Element.Section {
            return Section(self) ?? Section(.init([self]))
        }

        class Header {
            let content: () -> ViewCreator

            fileprivate init?(_ element: Element) {
                guard case .header = element.type, case .content(let content) = element.content else {
                    return nil
                }

                self.content = content
            }
        }

        var asHeader: Element.Header? {
            return Header(self)
        }

        class Footer {
            let content: () -> ViewCreator

            fileprivate init?(_ element: Element) {
                guard case .footer = element.type, case .content(let content) = element.content else {
                    return nil
                }

                self.content = content
            }
        }

        var asFooter: Element.Footer? {
            return Footer(self)
        }

        class Row {
            let content: () -> ViewCreator
            let quantity: Int

            fileprivate init?(_ element: Element) {
                guard case .row = element.type, case .content(let content) = element.content else {
                    return nil
                }

                self.content = content
                self.quantity = element.max
            }
        }

        var asRow: Element.Row? {
            return Row(self)
        }

        var isValid: Bool {
            switch self.type {
            case .footer:
                guard case .content = self.content else {
                    return false
                }

                return self.max == 1
            case .header:
                guard case .content = self.content else {
                    return false
                }

                return self.max == 1
            case .row:
                guard case .content = self.content else {
                    return false
                }

                return self.max >= 1
            case .section:
                guard case .group = self.content else {
                    return false
                }

                return self.max == 1
            }
        }
    }
}

private var kTableGroup: UInt = 0
private var kTableDataSource: UInt = 0

extension TableView {
    var group: Table.Group? {
        get { objc_getAssociatedObject(self, &kTableGroup) as? Table.Group }
        set { objc_setAssociatedObject(self, &kTableGroup, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var creatorDataSource: TableDataSource? {
        get { objc_getAssociatedObject(self, &kTableDataSource) as? TableDataSource }
        set { objc_setAssociatedObject(self, &kTableDataSource, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

public extension UIViewCreator where View: TableView {
    func dynamicDataSource(_ dataSource: TableDataSource) -> Self {
        (self.uiView as? View)?.creatorDataSource = dataSource
        return self
    }
}

public protocol TableDataSource {
    func numberOfRows(in section: Int, estimatedRows: Int) -> Int

    func cell(at indexPath: IndexPath,_ cellView: UITableViewCell, content: ViewCreator)
}

public extension TableDataSource {
    func numberOfRows(in section: Int, estimatedRows: Int) -> Int {
        return estimatedRows
    }

    func cell(at indexPath: IndexPath,_ cellView: UITableViewCell, content: ViewCreator) {}
}

extension TableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.group?.numberOfSections ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let group = self.group else {
            return 0
        }

        let numberOfRows = group.numberOfRows(in: group.section(at: section))
        if let creatorDataSource = self.creatorDataSource {
            return creatorDataSource.numberOfRows(in: section, estimatedRows: numberOfRows)
        }

        return numberOfRows
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = self.group?.row(at: indexPath) else {
            fatalError()
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: row.0, for: indexPath) as? TableViewCell else {
            fatalError()
        }

        cell.prepareCell(content: row.1)
        self.creatorDataSource?.cell(at: indexPath, cell, content: cell.builder)
        return cell
    }
}

extension Table {
    public convenience init(style: UITableView.Style,_ contentGroup: Element) {
        self.init(style: .grouped)
        let group = contentGroup.asSection.group

        if !self.isValid(content: group) {
            fatalError("Verify your content")
        }

        guard let tableView = self.uiView as? View else {
            return
        }

        group.rowsIdentifier.forEach {
            tableView.register(TableViewCell.self, forCellReuseIdentifier: $0)
        }

        tableView.group = group
        tableView.dataSource = tableView
    }

    func isValid(content group: Group, isInsideSection: Bool = false) -> Bool {
        let isRoot = group.containsSection

        if isRoot {
            guard !isInsideSection else {
                return false
            }

            if !group.containsOnlySection {
                return false
            }

            return group.sections.allSatisfy {
                self.isValid(content: $0.group, isInsideSection: true)
            }
        }

        let headers = group.headers
        if !headers.isEmpty && (headers.count > 1 || headers.first?.0 != 0) {
            return false
        }

        let footers = group.footers
        if !footers.isEmpty && (footers.count > 1 || footers.first?.0 != group.elements.count - 1) {
            return false
        }

        return !group.rows.isEmpty
    }
}
