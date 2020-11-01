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

extension ListState {
    @usableFromInline
    struct Delete: ListModifier {
        private let listState: ListState

        enum Disabled {
            case indexPaths([IndexPath])
            case sections([Int])
        }

        private let disabled: Disabled
        private var disableSections: [Int] {
            if case .sections(let sections) = self.disabled {
                return sections
            }

            return []
        }

        private var disableIndexPaths: [IndexPath] {
            if case .indexPaths(let indexPaths) = self.disabled {
                return indexPaths
            }

            return []
        }

        @usableFromInline
        init(_ listState: ListState, disable indexPaths: [IndexPath]) {
            self.listState = listState
            self.disabled = .indexPaths(indexPaths)
        }

        @usableFromInline
        init(_ listState: ListState, disable sections: [Int]) {
            self.listState = listState
            self.disabled = .sections(sections)
        }

        private init(_ listState: ListState, disabled: Disabled) {
            self.listState = listState
            self.disabled = disabled
        }

        @usableFromInline
        func update(_ list: List) -> ListState.Delete {
            .init(.init(list), disabled: self.disabled)
        }

        @inline(__always) @usableFromInline
        var state: List {
            self.listState.state
        }

        @usableFromInline
        func numberOfRows(in index: Int) -> Int {
            let numberOfRows = self.listState.numberOfRows(in: index)

            guard self.disableIndexPaths.contains(where: {
                $0.section == index
            }) else { return numberOfRows }

            return numberOfRows - self.disableIndexPaths.reduce(0) { $0 + ($1.section == index ? 1 : 0 )}
        }

        @inline(__always) @usableFromInline
        var numberOfSections: Int {
            self.listState.numberOfSections - self.disableSections.count
        }
    }
}
