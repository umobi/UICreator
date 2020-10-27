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
import ConstraintBuilder

extension Render {

    @usableFromInline
    struct Manager {

        @inline(__always)
        let view: CBView

        @inline(__always)
        init(_ view: CBView) {
            self.view = view
        }

        @inline(__always)
        func willMove(toSuperview newSuperview: CBView?) {
            guard newSuperview != nil else {
                return
            }

            view.render.commit(.notRendered)
        }

        @inline(__always)
        func didMoveToSuperview() {
            guard view.superview != nil else {
                return
            }

            view.render.commit(.rendered)
        }

        @inline(__always)
        func didMoveToWindow() {
            guard view.window != nil else {
                view.appear.commit(.disappeared)
                return
            }

            view.render.commit(.inTheScene)
            frame(view.frame)
        }

        @inline(__always)
        func layoutSubviews() {
            view.layout.commit()
            frame(view.frame)
        }

        @inline(__always)
        func traitDidChange() {
            view.trait.commit()
        }

        @inline(__always)
        func frame(_ rect: CGRect) {
            guard view.window != nil, !view.isHidden else {
                return
            }

            guard rect.size.height != .zero && rect.size.width != .zero else {
                return
            }

            view.appear.commit(.appeared)
        }

        @inline(__always)
        func isHidden(_ isHidden: Bool) {
            if isHidden {
                view.appear.commit(.disappeared)
                return
            }

            frame(view.frame)
        }
    }
}

extension CBView {

    @inline(__always)
    var renderManager: Render.Manager {
        .init(self)
    }
}
