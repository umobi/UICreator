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

//extension UICList {
//    public struct Element {
//        let type: ContentType
//        let content: Content
//        let max: Int
//        let identifier: String?
//
//        private init(_ type: ContentType, content: Content, identifier: String? = nil, max: Int = 0) {
//            self.type = type
//            self.content = content
//            self.max = max
//            self.identifier = identifier
//            if !self.isValid {
//                fatalError("UICList.Element is not valid")
//            }
//        }
//
//        public static func header(_ header: UICHeader) -> Element {
//            return .init(.header, content: .payload(.init(header: header)))
//        }
//
//        internal static func header(identifier: String,_ header: UICHeader) -> Element {
//            return .init(.header, content: .payload(.init(header: header)), identifier: identifier)
//        }
//
//        public static func footer(_ footer: UICFooter) -> Element {
//            return .init(.footer, content: .payload(.init(footer: footer)))
//        }
//
//        internal static func footer(identifier: String,_ footer: UICFooter) -> Element {
//            return .init(.footer, content: .payload(.init(footer: footer)), identifier: identifier)
//        }
//
//        public static func row(_ row: UICRow) -> Element {
//            return .init(.row, content: .payload(.init(row: row)))
//        }
//
//        internal static func row(identifier: String,_ row: UICRow) -> Element {
//            return .init(.row, content: .payload(.init(row: row)), identifier: identifier)
//        }
//
//        public static func rows(max: Int,_ row: UICRow) -> Element {
//            return .init(.row, content: .payload(.init(row: row)), max: max)
//        }
//
//        public static func section(_ elements: Element...) -> Element {
//            return .init(.section, content: .group(.init(elements)))
//        }
//
//        public static func section(_ elements: [Element]) -> Element {
//            return .init(.section, content: .group(.init(elements)))
//        }
//
//        fileprivate static func group(_ sections: [Section]) -> Element {
//            return .init(.group, content: .sections(sections))
//        }
//    }
//}
//
//extension UICList.Element {
//    var isSection: Bool {
//        return self.type == .section
//    }
//
//    var isFooter: Bool {
//        return self.type == .footer
//    }
//
//    var isRow: Bool {
//        return self.type == .row
//    }
//
//    var isHeader: Bool {
//        return self.type == .header
//    }
//
//    internal func isIdentifierEquals(_ identifier: String) -> Bool {
//        self.identifier == identifier
//    }
//}
//
//extension UICList.Element {
//    var asSection: Section? {
//        return Section(self)
//    }
//
//    var asHeader: Header? {
//        return Header(self)
//    }
//
//    var asFooter: Footer? {
//        return Footer(self)
//    }
//
//    var asRow: Row? {
//        return Row(self)
//    }
//}
//
//extension UICList.Element {
//    var isValid: Bool {
//        switch self.type {
//        case .footer:
//            guard case .payload = self.content else {
//                return false
//            }
//
//            return self.max == 0
//        case .header:
//            guard case .payload = self.content else {
//                return false
//            }
//
//            return self.max == 0
//        case .row:
//            guard case .payload = self.content else {
//                return false
//            }
//
//            return self.max >= 0
//        case .section:
//            guard case .group = self.content else {
//                return false
//            }
//
//            return self.max == 0
//        case .group:
//            guard case .sections = self.content else {
//                return false
//            }
//
//            return self.max == 0
//        }
//    }
//}
//
//public extension UICList.Element {
//    class Section {
//        let group: [ViewCreator]
//        var index: Int = 0
//
//        fileprivate init?(_ element: UICList.Element) {
//            guard case .section = element.type, case .group(let group) = element.content else {
//                return nil
//            }
//
//            self.group = group
//        }
//    }
//}
//
//public extension UICList.Element {
//    struct Header {
//        let payload: Payload
//        let identifier: String?
//
//        fileprivate init?(_ element: UICList.Element) {
//            guard case .header = element.type, case .payload(let payload) = element.content else {
//                return nil
//            }
//
//            self.payload = payload
//            self.identifier = element.identifier
//        }
//    }
//}
//
//public extension UICList.Element {
//    struct Footer {
//        let payload: Payload
//        let identifier: String?
//
//        fileprivate init?(_ element: UICList.Element) {
//            guard case .footer = element.type, case .payload(let payload) = element.content else {
//                return nil
//            }
//
//            self.payload = payload
//            self.identifier = element.identifier
//        }
//    }
//}
//
//public extension UICList.Element {
//    struct Row {
//        let payload: Payload
//        let quantity: Int
//        let identifier: String?
//
//        fileprivate init?(_ element: UICList.Element) {
//            guard case .row = element.type, case .payload(let payload) = element.content else {
//                return nil
//            }
//
//            self.payload = payload
//            self.quantity = element.max
//            self.identifier = element.identifier
//        }
//    }
//}
