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

class ListManager {
    var contents: [ContentSection] = []
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

            if let row = view as? UICRow {
                return .init(.row(content: row.content))
            }

            fatalError("Try using UICRow as wrapper for ViewCreators in list. It can be use UICForEach either")
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

        self.contents = content.compactMap {
            if let forEach = $0 as? ForEachCreator, forEach.viewType is UICSection.Type {
                return .eachSection(identifier: self.nextIdentifier(), forEach, delegate: self)
            }

            if let section = $0 as? UICSection {
                return .init(contents: self.mountSection(for: section.content))
            }

            return nil
        }

        if self.contents.isEmpty {
            self.contents = [.init(contents: self.mountSection(for: content))]
            return
        }

        if self.contents.count != content.count {
            fatalError("Verify your content")
        }
    }
}
