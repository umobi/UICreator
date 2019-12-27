//
//  ViewCreator.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
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
    - **leaf** are views that is the last view in the hierarchy of builders views, so it may manage it self content. This core has `Stack` as `UIStackView`, `Child` as `UIView`, `Table` as `UITableView`. If the view is to much complex and there is no way to keep the right hierarchy of ViewBuilder's methods, you can use the `Host` view in the middle of subviews that will keep the integrity of the hierarchy by calling the commits methods for its subviews.
*/

public protocol ViewCreator {
    /// It is executed in `willMove(toSubview:)` and depends of superview to call the `commitNotRendered()`.
    func onNotRendered(_ handler: @escaping (UIView) -> Void) -> Self

    /// It is executed in `didMoveToSuperview()` and depends of superview to call the `commitRendered()`.
    func onRendered(_ handler: @escaping (UIView) -> Void) -> Self

    /// It is executed in `didMoveToWindow()` and depends of superview to call the `commitInTheScene()`.
    func onInTheScene(_ handler: @escaping (UIView) -> Void) -> Self

    func onLayout(_ handler: @escaping (UIView) -> Void) -> Self
}

public protocol UIViewCreator: ViewCreator {
    associatedtype View: UIView
}

protocol UIViewRender: UIView {
    func commitNotRendered()
    func commitRendered()
    func commitInTheScene()
    func commitLayout()

    /// Subviews that has commits that needs to be done.
    var watchingViews: [UIView] { get }
}

private var kUIView: UInt = 0

internal extension ViewCreator {
    var uiView: UIView! {
        get { objc_getAssociatedObject(self, &kUIView) as? UIView }
        nonmutating
        set { setView(newValue, policity: newValue?.superview != nil ? .OBJC_ASSOCIATION_ASSIGN : .OBJC_ASSOCIATION_RETAIN) }
    }

    func setView(_ uiView: UIView, policity: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN) {
        objc_setAssociatedObject(self, &kUIView, uiView, policity)
    }
}

public extension ViewCreator {

    func onNotRendered(_ handler: @escaping (UIView) -> Void) -> Self {
        _ = self.uiView.appendBeforeRendering(handler)
        return self
    }
    
    func onRendered(_ handler: @escaping (UIView) -> Void) -> Self {
        _ = self.uiView.appendRendered(handler)
        return self
    }

    func onInTheScene(_ handler: @escaping (UIView) -> Void) -> Self {
        _ = self.uiView.appendInTheScene(handler)
        return self
    }

    func onLayout(_ handler: @escaping (UIView) -> Void) -> Self {
        _ = self.uiView.appendLayout(handler)
        return self
    }
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
