//
//  ViewBuilder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation

/**
`protocol ViewBuilder` is the **Main** engine that do all the magic for views.

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
public protocol ViewBuilder: UIView {

    /// It is executed in `willMove(toSubview:)` and depends of superview to call the `commitNotRendered()`.
    func onNotRendered(_ handler: @escaping (UIView) -> Void) -> Self

    /// It is executed in `didMoveToSuperview()` and depends of superview to call the `commitRendered()`.
    func onRendered(_ handler: @escaping (UIView) -> Void) -> Self

    /// It is executed in `didMoveToWindow()` and depends of superview to call the `commitInTheScene()`.
    func onInTheScene(_ handler: @escaping (UIView) -> Void) -> Self

    func onLayout(_ handler: @escaping (UIView) -> Void) -> Self

    /// Subviews that has commits that needs to be done.
    var watchingViews: [UIView] { get }
}

public extension ViewBuilder {
    func onRendered(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.appendBeforeRendering(handler)
    }

    func onInTheScene(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.appendRendered(handler)
    }

    func onNotRendered(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.appendBeforeRendering(handler)
    }

    func onLayout(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.appendLayout(handler)
    }

    func commitNotRendered() {
        self.watchingViews.forEach {
            ($0 as? ViewBuilder)?.notRenderedHandler?.commit(in: $0)
            ($0 as? ViewBuilder)?.notRenderedHandler = nil
        }
    }

    func commitRendered() {
        guard self.superview != nil else {
            return
        }

        self.watchingViews.forEach {
            ($0 as? ViewBuilder)?.renderedHandler?.commit(in: $0)
            ($0 as? ViewBuilder)?.renderedHandler = nil
        }
    }

    func commitInTheScene() {
        guard self.window != nil else {
            return
        }

        self.watchingViews.forEach {
            ($0 as? ViewBuilder)?.inTheSceneHandler?.commit(in: $0)
            ($0 as? ViewBuilder)?.inTheSceneHandler = nil
        }
    }

    func commitLayout() {
        self.watchingViews.forEach {
            ($0 as? ViewBuilder)?.layoutHandler?.commit(in: $0)
        }
    }

    var watchingViews: [UIView] {
        return self.subviews
    }
}
