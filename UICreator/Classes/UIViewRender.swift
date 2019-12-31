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

protocol UIViewRender: UIView {
    func commitNotRendered()
    func commitRendered()
    func commitInTheScene()
    func commitLayout()

    /// Subviews that has commits that needs to be done.
    var watchingViews: [UIView] { get }
}

private var kViewBuilder: UInt = 0
internal extension UIViewRender {
    private(set) var ViewCreator: ViewCreator? {
        get { objc_getAssociatedObject(self, &kViewBuilder) as? ViewCreator }
        set { objc_setAssociatedObject(self, &kViewBuilder, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    init(builder: ViewCreator) {
        self.init()
        self.ViewCreator = builder
    }

    func updateBuilder(_ builder: ViewCreator) {
        self.ViewCreator = builder
    }
}

extension UIView: UIViewRender {
    func commitNotRendered() {
        self.watchingViews.forEach {
            $0.notRenderedHandler?.commit(in: $0)
            $0.notRenderedHandler = nil
        }
    }

    func commitRendered() {
        guard self.superview != nil else {
            return
        }

        self.watchingViews.forEach {
            $0.renderedHandler?.commit(in: $0)
            $0.renderedHandler = nil
        }

        self.ViewCreator?.setView(self, policity: .OBJC_ASSOCIATION_ASSIGN)
    }

    func commitInTheScene() {
        guard self.window != nil else {
            return
        }

        self.watchingViews.forEach {
            $0.inTheSceneHandler?.commit(in: $0)
            $0.inTheSceneHandler = nil
        }
    }

    func commitLayout() {
        self.watchingViews.forEach {
            $0.layoutHandler?.commit(in: $0)
        }
    }

    @objc
    var watchingViews: [UIView] {
        return self.subviews
    }
}
