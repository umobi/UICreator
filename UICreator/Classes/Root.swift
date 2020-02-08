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
import UIContainer

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
    weak var view: UIView!

    init(_ view: UIView) {
        self.view = view
    }
}

extension RenderManager {
    func willMove(toSuperview newSuperview: UIView?) {
        guard newSuperview != nil else {
            return
        }

        if let override = self.view as? RenderWillMoveToSuperviewState {
            override.render_willMoveToSuperview()
            return
        }

        view.commitNotRendered()
    }

    func didMoveToSuperview() {
        guard self.view.superview != nil else {
            return
        }

        if let override = self.view as? RenderDidMoveToSuperviewState {
            override.render_didMoveToSuperview()
            return
        }

        view.commitRendered()
    }

    func didMoveToWindow() {
        guard self.view.window != nil else {
            return
        }

        if let override = self.view as? RenderDidMoveToWindowState {
            override.render_didMoveToWindow()
            return
        }

        view.commitInTheScene()
    }

    func layoutSubviews() {
        if let override = self.view as? RenderLayoutSubviewsState {
            override.render_layoutSubviews()
            return
        }

        view.commitLayout()
    }
}

extension RootView: RenderWillMoveToSuperviewState {
    func render_willMoveToSuperview() {
        self.willCommitNotRenderedHandler?()
        self.willCommitNotRenderedHandler = nil

        self.commitNotRendered()

        self.didCommitNotRenderedHandler?()
        self.didCommitNotRenderedHandler = nil
    }
}

/// RootView is an internal view that is used to be the UIView of some view creator to support lazy loads.
public class RootView: UIView {
    var willCommitNotRenderedHandler: (() -> Void)?
    var didCommitNotRenderedHandler: (() -> Void)?

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self).willMove(toSuperview: newSuperview)
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self).didMoveToSuperview()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self).didMoveToWindow()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self).layoutSubviews()
    }

    override var watchingViews: [UIView] {
        return [self] + self.subviews
    }
}

private var kViewDidLoad: UInt = 0
@objc extension Root {

    private(set) var didViewLoad: Bool {
        get { (objc_getAssociatedObject(self, &kViewDidLoad) as? Bool) ?? false }
        set { (objc_setAssociatedObject(self, &kViewDidLoad, newValue, .OBJC_ASSOCIATION_RETAIN)) }
    }

    /// The viewDidLoad function is a similar method used by UIKit for view controllers. This method means in UICreator that it is now allowed to directly access the subviews or manipulate data without having some errors thrown.
    open func viewDidLoad() {
        self.didViewLoad = true
    }
}

/**
 The root is the base view creator class for some of the view creators. You shouldn’t use this directly, instead, check `UICView` or `UICViewRepresentable`.

 Root support some of the protocols that is used in some of representable of view controllers like the protocol `ViewControllerAppearStates`.
 */
open class Root: ViewCreator {
    public typealias View = RootView

    public init() {
        self.uiView = View.init(builder: self)
    }
}

private var kTemplateViewDidConfiguredView: UInt = 0
extension TemplateView where Self: Root {
    private var didConfiguredView: Bool {
        get { (objc_getAssociatedObject(self, &kTemplateViewDidConfiguredView) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &kTemplateViewDidConfiguredView, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    internal func viewDidChanged() {
        guard !self.didConfiguredView else {
            return
        }

        self.didConfiguredView = true

        if self.uiView.subviews.isEmpty {
            (self.uiView as? View)?.willCommitNotRenderedHandler = { [unowned self] in
                self.uiView.add(priority: .required, self.body.releaseUIView())
            }
        }

        (self.uiView as? View)?.didCommitNotRenderedHandler = { [unowned self] in
            if !self.didViewLoad {
                self.viewDidLoad()
            }
        }
    }
}
