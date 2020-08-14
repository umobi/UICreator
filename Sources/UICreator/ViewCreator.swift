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

public protocol ViewCreator: Opaque {
    /**
     This method should be used when it is necessarly to set a property to the view, but only the ones that don't depend on view hierarchy.
     `onNotRendered(_:)` is executed on `willMoveToSuperview`.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    @discardableResult
    func onNotRendered(_ handler: @escaping (UIView) -> Void) -> Self

    /**
     This method should be used when the view is in the local hierarchy and it's needed to set a property on that moment.
     `onRendered(_:)` is executed on `didMoveToSuperview(_:)`.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    @discardableResult
    func onRendered(_ handler: @escaping (UIView) -> Void) -> Self

    /**
     This method should be used when the view is in the window hierarchy, accessing view controllers on hierarchy.
     `onInTheScene(_:)` is executed on `didMoveToWindow`.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    @discardableResult
    func onInTheScene(_ handler: @escaping (UIView) -> Void) -> Self

    /**
     This method calls the handler parameter when the UIView calls `layoutSubviews`.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    @discardableResult
    func onLayout(_ handler: @escaping (UIView) -> Void) -> Self

    /**
     This method calls the handler parameter when the UIView is hidden, moved from heirarchy or when the frame changes to visible layout.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    @discardableResult
    func onAppear(_ handler: @escaping (UIView) -> Void) -> Self

    /**
     This method calls the handler parameter when the UIView is hidden, moved from heirarchy or when the frame changes to invisible layout.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
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
