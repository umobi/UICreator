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
    func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            self.manager.tree.supertree?.remove(self.manager)
            return
        }

        if self.manager.tree.supertree == nil {
            self.manager.uiView.superCreator?.tree.append(self.manager)
        }

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

        if self.manager.tree.supertree == nil {
            self.manager.uiView.superCreator?.tree.append(self.manager)
        }

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
        guard isHidden else {
            manager.commitDisappear()
            return
        }

        self.frame(manager.uiView.frame)
    }
}

extension RootView: RenderWillMoveToSuperviewState {
    func render_willMoveToSuperview() {
        self.willCommitNotRenderedHandler?()
        self.willCommitNotRenderedHandler = nil

        self.viewCreator?.render.commit(.notRendered)

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
        RenderManager(self)?.willMove(toSuperview: newSuperview)
    }

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            RenderManager(self)?.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            RenderManager(self)?.frame(newValue)
        }
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self)?.didMoveToSuperview()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self)?.didMoveToWindow()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self)?.layoutSubviews()
    }

    override var watchingViews: [UIView] {
        return self.subviews
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
        self.loadView { [unowned self] in
            View.init(builder: self)
        }
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
        let body = self.body
        self.tree.append(body)

        if self.uiView.subviews.isEmpty {
            (self.uiView as? View)?.willCommitNotRenderedHandler = { [unowned self] in
                self.uiView.add(priority: .required, body.releaseUIView())
            }
        }

        (self.uiView as? View)?.didCommitNotRenderedHandler = { [unowned self] in
            if !self.didViewLoad {
                self.viewDidLoad()
            }
        }
    }
}
