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

public class Section: ViewCreator {
    public let content: [ViewCreator]

    public convenience init(_ content: ViewCreator...) {
        self.init(content: content)
    }

    internal init(content: [ViewCreator]) {
        self.content = content
    }
}

public class Header: ViewCreator {
    let content: () -> ViewCreator

    public init(content: @escaping () -> ViewCreator) {
        self.content = content
    }
}

public class Footer: ViewCreator {
    let content: () -> ViewCreator

    public init(content: @escaping () -> ViewCreator) {
        self.content = content
    }
}

protocol ListSupport: class {
    func reloadData()
    var group: Table.Group? { get }
}

protocol ListContentDelegate: class {
    func content(_ content: ListManager.Content, updatedWith sequence: [Table.Element])
}

extension ListManager {
    class Content: SupportForEach {
        let element: Table.Element
        let identifier: Int
        let isDynamic: Bool
        weak var delegate: ListContentDelegate!

        init(identifier: Int,_ element: Table.Element) {
            self.element = element
            self.identifier = identifier
            self.isDynamic = true
        }

        init(_ element: Table.Element) {
            self.identifier = 0
            self.isDynamic = false
            self.element = element
        }

        func viewsDidChange(placeholderView: UIView!, _ sequence: Relay<[ViewCreator]>) {
            let cellIdentifier = "\(ObjectIdentifier(self.delegate).hashValue).row.\(identifier)"
            weak var delegate = self.delegate

            sequence.next { [weak self] in
                guard let self = self else {
                    return
                }

                delegate?.content(self, updatedWith: $0.map { view in
                    .row(identifier: cellIdentifier, content: {
                        view
                    })
                })
            }
        }

        private var contentManager: Content? = nil
        static func eachRow(identifier: Int, _ forEach: ForEachCreator, delegate: ListContentDelegate) -> Content {
            let content = Content(identifier: identifier, .row(identifier: "\(ObjectIdentifier(delegate).hashValue).row.\(identifier)", content: {
                forEach
            }))
            content.delegate = delegate
//            content.support = .init(content: content)
            forEach.manager = content
//            content.support = .init(content: content)
            return content
        }

        static func makeRow(_ original: Content, element: Table.Element) -> Content {
            let content = Content(identifier: original.identifier, element)
            content.contentManager = original
            return content
        }
    }
}

class ListManager {
    fileprivate(set) var contents: [ContentSection] = []
    weak var list: ListSupport!

    private var identifierCount: Int = 0
    private func nextIdentifier() -> Int {
        let next = identifierCount
        identifierCount += 1
        return next
    }

    var elements: [Table.Element] {
        return self.contents.map {
            $0.section
        }
    }

    private func mountSection(for elements: [ViewCreator]) -> [Content] {
        elements.map { [unowned self] view in
            if let header = view as? Header {
                return .init(.header(content: header.content))
            }

            if let footer = view as? Footer {
                return .init(.footer(content: footer.content))
            }

            if let forEach = view as? ForEachCreator {
                return Content.eachRow(identifier: self.nextIdentifier(), forEach, delegate: self)
            }

            return .init(.row(content: {
                view
            }))
        }
    }

    class ContentSection {
        let section: Table.Element
        let contents: [Content]

        init(contents: [Content]) {
            self.contents = contents
            self.section = .section(contents.map {
                $0.element
            })
        }
    }

    init(content: [ViewCreator]) {
        if content.allSatisfy({ $0 is Section }) {
            self.contents = content.compactMap { [unowned self] in
                guard let section = $0 as? Section else {
                    return nil
                }

                return .init(contents: self.mountSection(for: section.content))
            }

            return
        }

        if content.first(where: { $0 is Section }) != nil {
            fatalError("Verify your content")
        }

        self.contents = [.init(contents: self.mountSection(for: content))]
    }
}

extension TableView: ListSupport {

}

extension ListManager: ListContentDelegate {
    private static func update(section: ContentSection, first: (Int, Content), last: (Int, Content)?, with contents: [Content]) -> ContentSection {
        return .init(contents: Array(section.contents[0...first.0]) +
            contents + {
                if section.contents.count == ((last ?? first).0 + 1) {
                    return []
                }

                return Array(section.contents[((last ?? first).0+1)..<section.contents.count])
            }()
        )
    }

    func content(_ content: ListManager.Content, updatedWith sequence: [Table.Element]) {
        self.contents = self.contents.map { [unowned content] section in
            guard let first = section.contents.enumerated().first(where: { $0.element.identifier == content.identifier }) else {
                return section
            }

            guard let end = section.contents.enumerated().reversed().first(where: { $0.element.identifier == content.identifier }) else {
                return ListManager.update(section: section, first: first, last: nil, with: sequence.map {
                    .makeRow(content, element: $0)
                })
            }

            return ListManager.update(section: section, first: first, last: end, with: sequence.map {
                .makeRow(content, element: $0)
            })
        }

        self.list.reloadData()
    }
}

public extension Table {
    convenience init(style: UITableView.Style,_ subviews: Subview) {
        self.init(style: style, ListManager(content: subviews.views))
    }
    
    private convenience init(style: UITableView.Style,_ manager: ListManager) {
        self.init(style: style)
        #if os(iOS)
        (self.uiView as? View)?.separatorStyle = .none
        #endif
        let group = Group(manager)

        if !group.isValid {
            fatalError("Verify your content")
        }

        guard let tableView = self.uiView as? View else {
            return
        }

        group.rowsIdentifier.forEach { [unowned tableView] in
            tableView.register(TableViewCell.self, forCellReuseIdentifier: $0)
        }

        group.headersIdentifier.forEach { [unowned tableView] in
            tableView.register(TableViewHeaderFooterCell.self, forHeaderFooterViewReuseIdentifier: $0)
        }

        group.footersIdentifier.forEach { [unowned tableView] in
            tableView.register(TableViewHeaderFooterCell.self, forHeaderFooterViewReuseIdentifier: $0)
        }

        tableView.group = group
        tableView.dataSource = tableView
        tableView.delegate = tableView
        manager.list = tableView
    }
}
