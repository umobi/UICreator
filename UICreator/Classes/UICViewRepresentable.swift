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

public class UIViewWrapper {
    private let wrap: ViewCreator
    public init(_ wrap: ViewCreator) {
        self.wrap = wrap
    }

    /// This will retain view on viewCreator
    public weak var uiView: UIView! {
        return self.wrap.uiView
    }

    /// This changes the keeper reference to UIView
    public func releaseUIView() -> UIView! {
        return self.wrap.releaseUIView()
    }
}

public protocol UIViewMaker: ViewCreator {
    var loadView: UIView { get }
}

public protocol UICViewRepresentable: UIViewCreator, UIViewMaker {
    var uiView: View! { get }
    func makeUIView() -> View
    func updateView(_ view: View)
}

class ViewMaker: RootView {
    weak var hosted: UIView!

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self.hosted)?.willMove(toSuperview: newSuperview)
    }

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            RenderManager(self.hosted)?.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            RenderManager(self.hosted)?.frame(newValue)
        }
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self.hosted)?.didMoveToSuperview()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self.hosted)?.didMoveToWindow()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self.hosted)?.layoutSubviews()
    }
}

class Maker: ViewCreator {
    public typealias View = ViewMaker

    public init(_ viewCreator: ViewCreator) {
        viewCreator.tree.supertree?.append(self)
        viewCreator.tree.supertree?.remove(viewCreator)
        self.tree.append(viewCreator)

        self.loadView { [unowned self] in
            let view = View.init(builder: self)
            let hostedView: UIView! = viewCreator.releaseUIView()
            view.hosted = hostedView
            view.add(priority: .required, hostedView)
            return view
        }
    }
}

internal extension UIViewMaker {
    func makeView() -> UIView {
        if let view = self.uiView {
            return view
        }

        self.loadView { [unowned self] in
            let view = self.loadView
            view.updateBuilder(self)
            return view
        }
        
        return Maker(self).releaseUIView()
    }
}

public extension UICViewRepresentable {
    var loadView: UIView {
        return self.onInTheScene { [weak self] in
            guard let view = ($0 as? View) else {
                return
            }

            self?.updateView(view)
        }.makeUIView()
    }

    weak var uiView: View! {
        return (self as ViewCreator).uiView as? View
    }

    weak var wrapper: UIView! {
        return self.uiView.superview
    }
}
