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

protocol RenderWillMoveToSuperviewState {
    func render_willMoveToSuperview()
}

protocol RenderDidMoveToSuperviewState {
    func render_didMoveToSuperview()
}

protocol RenderDidMoveToWindowState {
    func render_didMoveToWindow()
}

protocol RenderLayoutSubviewsState {
    func render_layoutSubviews()
}

struct RenderManager {
    private(set) weak var manager: ViewCreator!

    init?(_ view: UIView?) {
        guard let manager = view?.viewCreator else {
            return nil
        }

        self.manager = manager
    }
}

extension UIView {
    var superCreator: ViewCreator? {
        guard let superview = self.superview else {
            return nil
        }

        return sequence(first: superview, next: { $0.superview })
            .first(where: { $0.viewCreator != nil })?
            .viewCreator
    }

    var viewCreators: [ViewCreator] {
        self.subviews.reduce([]) {
            $0 + {
                guard let creator = $0.viewCreator else {
                    return $0.viewCreators
                }

                return [creator]
            }($1)
        }
    }
}

extension RenderManager {
    func checkSupercreator(_ superview: UIView? = nil) {
        let superview = superview ?? self.manager.uiView.superview
        guard let supercreator = superview?.viewCreator ?? superview?.superCreator else {
            return
        }

        if supercreator !== self.manager.tree.supertree?.root {
            self.manager.tree.supertree?.remove(self.manager)
            supercreator.tree.append(self.manager)
        }
    }

    func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            self.manager.tree.supertree?.remove(self.manager)
            return
        }

        self.checkSupercreator(newSuperview)

        if let override = self.manager.uiView as? RenderWillMoveToSuperviewState {
            override.render_willMoveToSuperview()
            return
        }

        manager.render.commit(.notRendered)
    }

    func didMoveToSuperview() {
        guard self.manager.uiView.superview != nil else {
            return
        }

        self.checkSupercreator()

        if let override = self.manager.uiView as? RenderDidMoveToSuperviewState {
            override.render_didMoveToSuperview()
            return
        }

        manager.render.commit(.rendered)
    }

    func didMoveToWindow() {
        guard self.manager.uiView.window != nil else {
            if let root = self.manager.root {
                root.tree.supertree?.remove(root)
            }
            manager.commitDisappear()
            return
        }

        self.checkSupercreator()

        if let override = self.manager.uiView as? RenderDidMoveToWindowState {
            override.render_didMoveToWindow()
            self.frame(manager.uiView.frame)
            return
        }

        manager.render.commit(.inTheScene)
        self.frame(manager.uiView.frame)
    }

    func layoutSubviews() {
        if let override = self.manager.uiView as? RenderLayoutSubviewsState {
            override.render_layoutSubviews()
            self.frame(manager.uiView.frame)
            return
        }

        manager.commitLayout()
        self.frame(manager.uiView.frame)
    }

    func traitDidChange() {
        self.manager.commitTrait()
    }

    func frame(_ rect: CGRect) {
        guard manager.uiView.window != nil, !manager.uiView.isHidden else {
            return
        }

        guard rect.size.height != .zero && rect.size.width != .zero else {
            return
        }

        manager.commitAppear()
    }

    func isHidden(_ isHidden: Bool) {
        if isHidden {
            manager.commitDisappear()
            return
        }

        self.frame(manager.uiView.frame)
    }
}
