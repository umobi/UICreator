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

public protocol ViewCreator: Opaque {
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

public extension ViewCreator {

    @discardableResult
    func onNotRendered(_ handler: @escaping (UIView) -> Void) -> Self {
        self.render.onNotRendered(handler)
        return self
    }

    @discardableResult
    func onRendered(_ handler: @escaping (UIView) -> Void) -> Self {
        self.render.onRendered(handler)
        return self
    }

    @discardableResult
    func onInTheScene(_ handler: @escaping (UIView) -> Void) -> Self {
        self.render.onInTheScene(handler)
        return self
    }
}
