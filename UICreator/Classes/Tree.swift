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

class Tree {
    private(set) weak var root: ViewCreator!
    private(set) var leafs: [Leaf]
    private(set) weak var supertree: Tree?

    init(_ root: ViewCreator) {
        self.root = root
        self.leafs = []
        supertree = nil
    }

    func appendAssert(_ leaf: ViewCreator) {
        guard self.root !== leaf else {
            fatalError()
        }

        if self.leafs.contains(where: {
            $0.leaf === leaf
        }) {
            self.remove(leaf)
        }

        leaf.tree.supertree = self
    }

    func append(_ leaf: ViewCreator) {
        self.appendAssert(leaf)
        self.leafs.append(.init(leaf))
    }

    func insert(_ leaf: ViewCreator, at index: Int) {
        self.appendAssert(leaf)

        self.leafs = (Array(self.leafs[0..<index]) + [.init(leaf)] + {
            guard index+1 < self.leafs.count else {
                return []
            }

            return Array(self.leafs[index+1..<self.leafs.count])
        }())
    }

    func remove(_ leaf: ViewCreator) {
        guard self.leafs.contains(where: {
            $0.leaf === leaf
        }) else {
            fatalError()
        }

        self.leafs = self.leafs.filter {
            $0.leaf !== leaf
        }

        leaf.tree.supertree = nil
    }

    func printTrace(_ count: Int = 0) {
        print("\((0..<count).map {_ in "\t"}.joined())", self.root!)

        self.leafs.forEach {
            $0.leaf.tree.printTrace(count + 1)
        }
    }
}

extension Tree {
    struct Leaf {
        private(set) weak var leaf: ViewCreator!

        init(_ leaf: ViewCreator) {
            self.leaf = leaf
        }
    }
}

extension ViewCreator {
    var tree: Tree {
        get { self.mem_objects.tree.value }
        set { self.mem_objects.tree.value = newValue }
    }
}

extension ViewCreator {
    var root: ViewCreator? {
        sequence(first: self as ViewCreator, next: { $0.tree.supertree?.root })
            .reversed()
            .first
    }
}

public extension UIView {
    func printCreatorTrace() {
        if let root = self.superCreator?.root {
            root.tree.printTrace()
            return
        }

        self.viewCreators.forEach {
            $0.tree.printTrace()
        }
    }
}
