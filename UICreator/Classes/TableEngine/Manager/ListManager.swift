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
    var group: UICListCollectionElements? { get }
}

extension ListSupport {
    func setNeedsReloadData() {
        guard group == nil || !(group is UICList.GroupAddingAction) else {
            return
        }

        self.reloadData()
    }
}

class ListManager: UICListCollectionElements {
    var sections: [SectionManager] = []
    weak var list: ListSupport!

    private var identifierCount: Int = 0
    private func nextIdentifier() -> Int {
        let next = identifierCount
        identifierCount += 1
        return next
    }

    init(contents: [ViewCreator]) {
        if contents.allSatisfy({ $0 is UICSection }) {
            self.sections = contents.enumerated().compactMap {
                guard let section = $0.element as? UICSection else {
                    return nil
                }

                return SectionManager
                    .mount(with: section.content)
                    .index($0.offset)
                    .identifier($0.offset)
                    .isDynamic(false)
                    .listManager(self)
            }

            return
        }

        self.sections = contents.enumerated().compactMap {
            if let forEach = $0.element as? ForEachCreator, forEach.viewType is UICSection.Type {
                return SectionManager.forEach(forEach)
                    .isDynamic(true)
                    .index($0.offset)
                    .identifier($0.offset)
                    .listManager(self)
            }

            if let section = $0.element as? UICSection {
                return SectionManager.mount(with: section.content)
                    .isDynamic(false)
                    .index($0.offset)
                    .identifier($0.offset)
                    .listManager(self)
            }

            return nil
        }

        if self.sections.isEmpty {
            self.sections = [
                SectionManager.mount(with: contents)
                    .isDynamic(false)
                    .listManager(self)
            ]
            return
        }

        if self.sections.count != contents.count {
            fatalError("Verify your content")
        }
    }
}
