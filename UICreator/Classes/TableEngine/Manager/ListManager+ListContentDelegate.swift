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

//extension ListManager: ListContentDelegate {
//    private static func update(section: ContentSection, first: (Int, Content), last: (Int, Content)?, with contents: [Content]) -> ContentSection {
//        return .init(
//            contents: Array(section.contents[0..<first.0]) +
//                contents + {
//                    if section.contents.count == ((last ?? first).0 + 1) {
//                        return []
//                    }
//
//                    return Array(section.contents[((last ?? first).0+1)..<section.contents.count])
//                }(),
//            section: section.sectionIndex
//        )
//    }
//
//    func content(_ content: ListManager.Content, updatedWith sequence: [UICList.Element]) {
//        self.contents = self.contents.enumerated().map { [unowned content] in
//            guard $0.offset == content.section else {
//                return $0.element
//            }
//
//            let section = $0.element
//            guard let first = section.rows.first(where: { $0.1.identifier == content.identifier }) else {
//                return section
//            }
//
//            guard let end = section.rows.reversed().first(where: { $0.1.identifier == content.identifier }) else {
//                return ListManager.update(section: section, first: first, last: nil, with: sequence.map {
//                    .makeRow(content, element: $0)
//                })
//            }
//
//            return ListManager.update(section: section, first: first, last: end, with: sequence.map {
//                .makeRow(content, element: $0)
//            })
//        }
//
//        self.list.setNeedsReloadData()
//    }
//}
