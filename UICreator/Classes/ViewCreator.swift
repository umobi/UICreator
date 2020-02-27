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

/**
`protocol ViewCreator` is the **Main** engine that do all the magic for views.

The protocol provides six functions. The `onNotRendered(_:)`, `onRendered(_:)`, `onInTheScene(_:)` that is metods that append callback to view stack
 and the `commitNotRendered()`, `commitRendered()`, `commitInTheScene` that will execute the **subviews** associated callbacks provided by `watchingViews`.
 The basic views may hold subviews, but views like `UIStackView` may return as watchingViews its arrangedSubviews.

The commits functions and UIView's life cycle:
    - `commitNotRendered()` should be executed at `willMove(toSuperview:)`.
    - `commitRendered()` should be executed at `didMoveToSuperview()`.
    - `commitInTheScene()` should be executed at `didMoveToWindow()`.

After committed the callbacks are removed from the stack of Handlers and cannot be redone.

Definitions of UIView as ViewBuild:
    - **root** are views that implements the `var body: UIView` as TemplateView and should add the body as subviews. This core implements the `class View` that does this, so you may change the superclass that your view is extending.
    - **leaf** are views that is the last view in the hierarchy of builders views, so it may manage it self content. This core has `Stack` as `UIStackView`, `Child` as `UIView`, `Table` as `UITableView`. If the view is to much complex and there is no way to keep the right hierarchy of ViewBuilder's methods, you can use the `UICHost` view in the middle of subviews that will keep the integrity of the hierarchy by calling the commits methods for its subviews.
*/

public protocol ViewCreator: class {
    /// It is executed in `willMove(toSubview:)` and depends of superview to call the `commitNotRendered()`.
    @discardableResult
    func onNotRendered(_ handler: @escaping (UIView) -> Void) -> Self

    /// It is executed in `didMoveToSuperview()` and depends of superview to call the `commitRendered()`.
    @discardableResult
    func onRendered(_ handler: @escaping (UIView) -> Void) -> Self

    /// It is executed in `didMoveToWindow()` and depends of superview to call the `commitInTheScene()`.
    @discardableResult
    func onInTheScene(_ handler: @escaping (UIView) -> Void) -> Self

    @discardableResult
    func onLayout(_ handler: @escaping (UIView) -> Void) -> Self

    @discardableResult
    func onAppear(_ handler: @escaping (UIView) -> Void) -> Self

    @discardableResult
    func onDisappear(_ handler: @escaping (UIView) -> Void) -> Self
}

private struct UIViewObject {
    private weak var __weak_uiView: UIView!
    private var __strong_uiView: UIView!

    weak var uiView: UIView! {
        self.__strong_uiView ?? self.__weak_uiView
    }

    private init(weak view: UIView!) {
        self.__weak_uiView = view
        self.__strong_uiView = nil
    }

    private init(strong view: UIView!) {
        self.__weak_uiView = nil
        self.__strong_uiView = view
    }

    static func `weak`(_ view: UIView) -> Self {
        .init(weak: view)
    }

    static func strong(_ view: UIView) -> Self {
        .init(strong: view)
    }

    static var `nil`: Self {
        .init(weak: nil)
    }
}

private var kUIView: UInt = 0
private extension ViewCreator {
    private(set) var viewObject: UIViewObject {
        get {
            objc_getAssociatedObject(self, &kUIView) as? UIViewObject ?? {
                let object = UIViewObject.nil
                self.viewObject = object
                return object
            }()
        }
        set { objc_setAssociatedObject(self, &kUIView, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    func setView(_ uiView: UIView, asWeak: Bool = false) {
        self.viewObject = {
            if asWeak {
                return .weak(uiView)
            }

            return .strong(uiView)
        }()

        if let root = self as? (Root & TemplateView) {
            root.viewDidChanged()
        }
    }
}

internal extension ViewCreator {
    weak var uiView: UIView! {
        self.viewObject.uiView
    }

    func releaseUIView() -> UIView! {
        let uiView: UIView! = self.loadViewIfNeeded()
        guard uiView.viewCreator === self else {
            return uiView
        }
        uiView.setCreator(self, policity: .OBJC_ASSOCIATION_RETAIN)
        self.setView(uiView, asWeak: true)
        return uiView
    }
}

private var kLoadView: UInt = 0
extension ViewCreator {
    private(set) var loadViewHandler: (() -> UIView)? {
        get { objc_getAssociatedObject(self, &kLoadView) as? (() -> UIView) }
        set { objc_setAssociatedObject(self, &kLoadView, newValue, .OBJC_ASSOCIATION_RETAIN)}
    }

    var isViewLoaded: Bool {
        self.uiView != nil
    }

    func loadViewIfNeeded() -> UIView! {
        if self.isViewLoaded {
            return self.uiView
        }

        let loadView: UIView! = self.loadViewHandler?() ?? (self as? UIViewMaker)?.makeView()
        self.loadViewHandler = nil
        if loadView.viewCreator === self {
            self.setView(loadView, asWeak: true)
        }

        return loadView
    }

    @discardableResult
    func loadView(_ handler: @escaping () -> UIView) -> Self {
        self.loadViewHandler = handler
        return self
    }
}
