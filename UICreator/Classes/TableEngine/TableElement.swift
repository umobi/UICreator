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

extension Table {
    public struct Element {
        let type: ContentType
        let content: Content
        let max: Int
        let identifier: String?

        private init(_ type: ContentType, content: Content, identifier: String? = nil, max: Int = 0) {
            self.type = type
            self.content = content
            self.max = max
            self.identifier = identifier
            if !self.isValid {
                fatalError("Table.Element is not valid")
            }
        }

        public static func header(content: @escaping () -> ViewCreator) -> Element {
            return .init(.header, content: .content(content))
        }

        public static func footer(content: @escaping () -> ViewCreator) -> Element {
            return .init(.footer, content: .content(content))
        }

        public static func row(content: @escaping () -> ViewCreator) -> Element {
            return .init(.row, content: .content(content))
        }

        internal static func row(identifier: String, content: @escaping () -> ViewCreator) -> Element {
            return .init(.row, content: .content(content), identifier: identifier)
        }

        public static func rows(max: Int, content: @escaping () -> ViewCreator) -> Element {
            return .init(.row, content: .content(content), max: max)
        }

        public static func section(_ elements: Element...) -> Element {
            return .init(.section, content: .group(.init(elements)))
        }

        public static func section(_ elements: [Element]) -> Element {
            return .init(.section, content: .group(.init(elements)))
        }

        fileprivate static func group(_ sections: [Section]) -> Element {
            return .init(.group, content: .sections(sections))
        }
    }
}

extension Table.Element {
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

    internal func isIdentifierEquals(_ identifier: String) -> Bool {
        self.identifier == identifier
    }
}

extension Table.Element {
    var asSection: Section? {
        return Section(self)
    }

    var asHeader: Header? {
        return Header(self)
    }

    var asFooter: Footer? {
        return Footer(self)
    }

    var asRow: Row? {
        return Row(self)
    }
}

extension Table.Element {
    var isValid: Bool {
        switch self.type {
        case .footer:
            guard case .content = self.content else {
                return false
            }

            return self.max == 0
        case .header:
            guard case .content = self.content else {
                return false
            }

            return self.max == 0
        case .row:
            guard case .content = self.content else {
                return false
            }

            return self.max >= 0
        case .section:
            guard case .group = self.content else {
                return false
            }

            return self.max == 0
        case .group:
            guard case .sections = self.content else {
                return false
            }

            return self.max == 0
        }
    }
}

public extension Table.Element {
    class Section {
        let group: Table.Group

        fileprivate init?(_ element: Table.Element) {
            guard case .section = element.type, case .group(let group) = element.content else {
                return nil
            }

            self.group = group
        }
    }
}

public extension Table.Element {
    struct Header {
        let content: Builder

        fileprivate init?(_ element: Table.Element) {
            guard case .header = element.type, case .content(let content) = element.content else {
                return nil
            }

            self.content = content
        }
    }
}

public extension Table.Element {
    struct Footer {
        let content: Builder

        fileprivate init?(_ element: Table.Element) {
            guard case .footer = element.type, case .content(let content) = element.content else {
                return nil
            }

            self.content = content
        }
    }
}

public extension Table.Element {
    struct Row {
        let content: Builder
        let quantity: Int
        let identifier: String?

        fileprivate init?(_ element: Table.Element) {
            guard case .row = element.type, case .content(let content) = element.content else {
                return nil
            }

            self.content = content
            self.quantity = element.max
            self.identifier = element.identifier
        }
    }
}
