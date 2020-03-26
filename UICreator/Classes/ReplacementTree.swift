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

class ReplacementTree {
    private let manager: ViewCreator

    init(_ manager: ViewCreator) {
        self.manager = manager
    }

    func swap(_ newManager: ViewCreator) {
        newManager.setView(self.manager.uiView, asWeak: self.manager.isViewWeaked)
        self.manager.uiView.setCreator(newManager, policity: self.manager.isViewWeaked ? .OBJC_ASSOCIATION_RETAIN : .OBJC_ASSOCIATION_ASSIGN)

        self.manager.tree.supertree?.append(newManager)
        self.manager.tree.supertree?.remove(self.manager)
    }

    func commit(_ newManager: ViewCreator) {
        newManager.render.repeat()
        newManager.releaseLoader()
    }

    private func recursive(_ newManager: ViewCreator) {
        self.swap(newManager)

        var toAppend = newManager.tree.leafs

//        guard (self.manager.tree.leafs.allSatisfy { old in
//            if toAppend.contains(where: { type(of: $0.leaf) == type(of: old.leaf) }) {
//                return true
//            }
//
//            return false
//        }) else {
//            self.manager.root?.uiView.subviews.forEach {
//                $0.removeFromSuperview()
//            }
//        }

        self.manager.tree.leafs.forEach { old in
            if let new = toAppend.enumerated().first(where: { type(of: $0.element.leaf) == type(of: old.leaf) }) {
                if ReplacementTree(old.leaf).replace(with: new.element.leaf) {
                    toAppend.remove(at: new.offset)
                    return
                }
            }

            if let oldLeaf = old.leaf {
                oldLeaf.tree.supertree?.remove(oldLeaf)
                oldLeaf.uiView.removeFromSuperview()
            }
        }

        self.commit(newManager)
    }

    func replace(with newManager: ViewCreator) -> Bool {
        if let maker = newManager as? UIViewMaker, let adaptor = self.manager as? Adaptor {
            adaptor.removeSubviews()
            let newAdaptor = maker.makeView().viewCreator as! Adaptor
            self.swap(newAdaptor)
            self.commit(newAdaptor)
            return true
        }

        guard type(of: self.manager) == type(of: newManager) else {
            return false
        }

        self.recursive(newManager)

        return true
    }
}

private extension Render {
    func `repeat`() {
        if self.manager.uiView.superview != nil {
            self.commit(.notRendered)
            self.commit(.rendered)
        }

        if self.manager.uiView.window != nil {
            self.commit(.inTheScene)
        }
    }
}
