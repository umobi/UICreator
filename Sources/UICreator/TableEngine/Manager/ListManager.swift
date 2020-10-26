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
import UIKit

class ListToken: NSObject {
    weak var listView: ListSupport!

    init(_ listView: ListSupport) {
        self.listView = listView
    }
}

struct ListManager: ListCollectionManager, ListContentSectionRestore {
    @MutableBox var sections: [SectionManager] = []
    @WeakBox var listToken: ListToken!

    init(contents: [ViewCreator]) {
        self.init(contents)

        self.sections.forEach {
            $0.loadForEachIfNeeded()
        }

        self.sections.forEach {
            $0.loadForEachIfNeeded()
        }
    }

    private init(_ contents: [ViewCreator]) {
        if contents.allSatisfy({ $0 is UICSection }) {
            self.sections = contents.enumerated().compactMap {
                guard let section = $0.element as? UICSection else {
                    return nil
                }

                return SectionManager
                    .mount(self, with: section.contents().zip)
                    .index($0.offset)
                    .identifier($0.offset)
                    .isDynamic(false)
            }

            return
        }

        self.sections = contents.enumerated().compactMap {
            if let forEach = $0.element as? ForEachCreator, forEach.viewType is UICSection.Type {
                return SectionManager(self)
                    .forEach(forEach)
                    .isDynamic(true)
                    .index($0.offset)
                    .identifier($0.offset)
            }

            if let section = $0.element as? UICSection {
                return SectionManager.mount(self, with: section.contents().zip)
                    .isDynamic(false)
                    .index($0.offset)
                    .identifier($0.offset)
            }

            return nil
        }

        if self.sections.isEmpty {
            self.sections = [
                SectionManager.mount(self, with: contents)
                    .isDynamic(false)
            ]
            return
        }

        if self.sections.count != contents.count {
            Fatal.Builder("ListManager can't figure out what is in content").die()
        }
    }
}
