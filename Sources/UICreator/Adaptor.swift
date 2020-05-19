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

class ViewAdaptor: RootView {
    weak var hosted: UIView!

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self)?.willMove(toSuperview: newSuperview)
        RenderManager(self.hosted)?.willMove(toSuperview: self)
    }

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            RenderManager(self)?.isHidden(newValue)
            RenderManager(self.hosted)?.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            RenderManager(self)?.frame(newValue)
            RenderManager(self.hosted)?.frame(self.hosted.frame)
        }
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self)?.didMoveToSuperview()
        RenderManager(self.hosted)?.didMoveToSuperview()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self)?.didMoveToWindow()
        RenderManager(self.hosted)?.didMoveToWindow()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self)?.layoutSubviews()
        RenderManager(self.hosted)?.layoutSubviews()
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        RenderManager(self)?.traitDidChange()
    }
}

class Adaptor: UIViewCreator {
    public typealias View = ViewAdaptor

    public init(_ viewCreator: ViewCreator) {
        viewCreator.tree.supertree?.append(self)
        viewCreator.tree.supertree?.remove(viewCreator)
        self.tree.append(viewCreator)
        let hostedView: UIView! = viewCreator.releaseUIView()

        self.loadView { [unowned self] in
            View.init(builder: self)
        }.onNotRendered {
            ($0 as? View)?.hosted = hostedView
            ($0 as? View)?.add(priority: .required, hostedView)
        }
    }

    func removeSubviews() {
        self.uiView?.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
