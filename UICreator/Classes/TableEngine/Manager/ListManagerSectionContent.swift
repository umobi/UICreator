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

protocol ListSectionDelegate: ListContentDelegate {
    func content(_ section: ListManager.ContentSection, updateSections: [ListManager.ContentSection])
}

extension ListManager {
    class ContentSection {
        let section: UICList.Element
        let contents: [Content]
        weak var delegate: ListSectionDelegate!
        weak var forEach: ForEachCreator!
        let identifier: Int
        let isDynamic: Bool

        var rows: [(Int, Content)] {
            return self.contents.enumerated().filter {
                $0.element.element.isRow
            }
        }

        init(contents: [Content]) {
            self.contents = contents
            self.section = .section(contents.map {
                $0.element
            })
            self.isDynamic = false
            self.identifier = 0
        }

        init(identifier: Int,_ contents: [Content]) {
            self.contents = contents
            self.identifier = identifier
            self.isDynamic = true
            self.section = .section(contents.map {
                $0.element
            })
        }

        static func eachSection(identifier: Int, _ forEach: ForEachCreator, delegate: ListSectionDelegate) -> ContentSection {
            let section = ContentSection(identifier: identifier, [
                .init(.header(identifier: "\(ObjectIdentifier(delegate)).header.\(identifier)") {
                    UICSpacer()
                        .height(equalTo: 0)
                }),
                .init(.row(identifier: "\(ObjectIdentifier(delegate)).row.\(identifier)", UICRow {
                    forEach
                })),
                .init(.footer(identifier: "\(ObjectIdentifier(delegate)).footer.\(identifier)") {
                    UICSpacer()
                        .height(equalTo: 0)
                })
            ])
            section.delegate = delegate
            forEach.manager = section
            section.forEach = forEach
            return section
        }

        @discardableResult
        func copy(from other: ListManager.ContentSection, relay: Relay<[() -> ViewCreator]>) -> Self {
            self.delegate = other.delegate
            self.forEach = other.forEach
            self.forEach.manager = self
            self.viewsDidChange(placeholderView: nil, relay)
            return self
        }
    }
}

extension ListManager.ContentSection: SupportForEach {
    func viewsDidChange(placeholderView: UIView!, _ sequence: Relay<[() -> ViewCreator]>) {
        let delegateIdentifier = "\(ObjectIdentifier(self.delegate))"
        let identifier = self.identifier
        weak var delegate = self.delegate

        var activeRowIdentifiers: [Int] = []
        var lastRowIdentifierIndex = 0

        var onErase: (() -> Void)? = nil

        var handler: (([() -> ViewCreator]) -> Void)? = { [weak self, onErase] in
            guard let self = self else {
                return
            }

            let sections = $0.compactMap {
                ($0() as? UICSection)?.content
            }

            if sections.isEmpty {
                let emptySection = ListManager.ContentSection(identifier: identifier, [])
                delegate?.content(self, updateSections: [emptySection.copy(from: self, relay: sequence)])
                onErase?()
                return
            }

            let updateSections: [ListManager.ContentSection] = sections.map { section in
                lastRowIdentifierIndex = 0
                return .init(identifier: identifier, section.map { view in
                    if let header = view as? UICHeader {
                        return .init(.header(identifier: "\(delegateIdentifier).header.\(identifier)", content: header.content))
                    }

                    if let footer = view as? UICFooter {
                        return .init(.footer(identifier: "\(delegateIdentifier).footer.\(identifier)", content: footer.content))
                    }

                    if let forEach = view as? ForEachCreator {
                        return ListManager.Content.eachRow(identifier: identifier, forEach, delegate: delegate!)
                    }

                    if let row = view as? UICRow {
                        return .init(.row(identifier: {
                            if let identifier = activeRowIdentifiers.enumerated().first(where: { $0.element == lastRowIdentifierIndex })?.1 {
                                lastRowIdentifierIndex += 1
                                return "\(delegateIdentifier).row.\(identifier)"
                            }

                            let identifier = lastRowIdentifierIndex
                            activeRowIdentifiers.append(lastRowIdentifierIndex)
                            lastRowIdentifierIndex += 1
                            return "\(delegateIdentifier).row.\(identifier)"
                        }(), row))
                    }

                    fatalError("Try using UICRow as wrapper for ViewCreators in list. It can be use UICForEach either")
                })
            }

            updateSections.first?.copy(from: self, relay: sequence)
            delegate?.content(self, updateSections: updateSections)
            onErase?()
        }

        sequence.next { [handler] in
            handler?($0)
        }

        onErase = {
            handler = nil
        }
    }
}
