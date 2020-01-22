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

protocol ListSupport: class {
    func reloadData()
    var group: UICList.Group? { get }
}

protocol ListContentDelegate: class {
    func content(_ content: ListManager.Content, updatedWith sequence: [UICList.Element])
}

public class UICSection: ViewCreator {
    public let content: [ViewCreator]

    public convenience init(_ content: ViewCreator...) {
        self.init(content: content)
    }

    internal init(content: [ViewCreator]) {
        self.content = content
    }
}

public class UICHeader: ViewCreator {
    let content: () -> ViewCreator

    public init(content: @escaping () -> ViewCreator) {
        self.content = content
    }
}

public class UICFooter: ViewCreator {
    let content: () -> ViewCreator

    public init(content: @escaping () -> ViewCreator) {
        self.content = content
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

    var elements: [UICList.Element] {
        return self.contents.map {
            $0.section
        }
    }

    private func mountSection(for elements: [ViewCreator]) -> [Content] {
        elements.map { [unowned self] view in
            if let header = view as? UICHeader {
                return .init(.header(content: header.content))
            }

            if let footer = view as? UICFooter {
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

    init(content: [ViewCreator]) {
        if content.allSatisfy({ $0 is UICSection }) {
            self.contents = content.compactMap { [unowned self] in
                guard let section = $0 as? UICSection else {
                    return nil
                }

                return .init(contents: self.mountSection(for: section.content))
            }

            return
        }

        if content.first(where: { $0 is UICSection }) != nil {
            fatalError("Verify your content")
        }

        self.contents = [.init(contents: self.mountSection(for: content))]
    }
}

extension ListManager {
    class ContentSection {
        let section: UICList.Element
        let contents: [Content]

        init(contents: [Content]) {
            self.contents = contents
            self.section = .section(contents.map {
                $0.element
            })
        }
    }
}

extension ListManager {
    class Content: SupportForEach {
        let element: UICList.Element
        let identifier: Int
        let isDynamic: Bool
        weak var delegate: ListContentDelegate!

        init(identifier: Int,_ element: UICList.Element) {
            self.element = element
            self.identifier = identifier
            self.isDynamic = true
        }

        init(_ element: UICList.Element) {
            self.identifier = 0
            self.isDynamic = false
            self.element = element
        }

        func viewsDidChange(placeholderView: UIView!, _ sequence: Relay<[() -> ViewCreator]>) {
            let cellIdentifier = "\(ObjectIdentifier(self.delegate)).row.\(identifier)"
            weak var delegate = self.delegate

            sequence.next { [weak self] in
                guard let self = self else {
                    return
                }

                delegate?.content(self, updatedWith: $0.map { constructor in
                    .row(identifier: cellIdentifier, content: constructor)
                })
            }
        }

        private var contentManager: Content? = nil
        static func eachRow(identifier: Int, _ forEach: ForEachCreator, delegate: ListContentDelegate) -> Content {
            let content = Content(identifier: identifier, .row(identifier: "\(ObjectIdentifier(delegate)).row.\(identifier)", content: {
                forEach
            }))
            content.delegate = delegate
            forEach.manager = content
            return content
        }

        static func makeRow(_ original: Content, element: UICList.Element) -> Content {
            let content = Content(identifier: original.identifier, element)
            content.contentManager = original
            return content
        }
    }
}

extension ListManager: ListContentDelegate {
    private static func update(section: ContentSection, first: (Int, Content), last: (Int, Content)?, with contents: [Content]) -> ContentSection {
        return .init(contents: Array(section.contents[0..<first.0]) +
            contents + {
                if section.contents.count == ((last ?? first).0 + 1) {
                    return []
                }

                return Array(section.contents[((last ?? first).0+1)..<section.contents.count])
            }()
        )
    }

    func content(_ content: ListManager.Content, updatedWith sequence: [UICList.Element]) {
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

public class Link: UICHost {
    public init(content: @escaping () -> ViewCreator) {
        super.init(content: content)
    }
}

public extension Link {
    func destination(content: @escaping () -> ViewCreator) -> Self {
        self.onInTheScene {
            _ = $0.viewCreator?.onTap {
                if $0.navigationController != nil {
                    $0.navigation?.push(animated: true, content: content)
                    return
                }
            }
        }
    }
}
