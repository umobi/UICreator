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

protocol ListContentDelegate: class {
    func content(_ content: ListManager.Content, updatedWith sequence: [UICList.Element])
}

extension ListManager {
    class Content {
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

extension ListManager.Content: SupportForEach {
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
}
