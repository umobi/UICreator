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
        print(self)
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

    deinit {
        fatalError()
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

/**
 The root is the base view creator class for some of the view creators. You shouldn’t use this directly, instead, check `UICView` or `UICViewRepresentable`.

 Root support some of the protocols that is used in some of representable of view controllers like the protocol `ViewControllerAppearStates`.
 */
open class Root: ViewCreator {
    public typealias View = RootView

    public init() {
        var body: ViewCreator?

        if let templateView = self as? TemplateView {
            let _body = templateView.body
            self.tree.append(_body)
            body = _body
        }

        self.loadView { [unowned self] in
            return View.init(builder: self)
        }
        .onNotRendered {
            if let body = body {
                $0.add(priority: .required, body.releaseUIView())
            }
        }
    }
}

private var kViewDidLoad: UInt = 0
private extension Root {
    var didViewLoadMutable: Mutable<Bool> {
        OBJCSet(self, &kViewDidLoad) {
            .init(value: false)
        }
    }
}

@objc extension Root {
    private(set) var didViewLoad: Bool {
        get { self.didViewLoadMutable.value }
        set { self.didViewLoadMutable.value = newValue }
    }

    /// The viewDidLoad function is a similar method used by UIKit for view controllers. This method means in UICreator that it is now allowed to directly access the subviews or manipulate data without having some errors thrown.
    open func viewDidLoad() {
        self.didViewLoad = true
    }
}

private var kTemplateViewDidConfiguredView: UInt = 0
extension TemplateView where Self: Root {
    private var didConfiguredViewMutable: Mutable<Bool> {
        OBJCSet(self, &kTemplateViewDidConfiguredView) {
            .init(value: false)
        }
    }
    private var didConfiguredView: Bool {
        get { self.didConfiguredViewMutable.value }
        set { self.didConfiguredViewMutable.value = newValue }
    }

    internal func viewDidChanged() {
        guard !self.didConfiguredView else {
            return
        }

        self.didConfiguredView = true

        (self.uiView as? View)?.didCommitNotRenderedHandler = { [unowned self] in
            if !self.didViewLoad {
                self.viewDidLoad()
            }
        }
    }
}
