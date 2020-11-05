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
import ConstraintBuilder

public protocol ViewControllerCreator: ViewCreator {

    static func _makeUIViewController(_ viewCreator: ViewCreator) -> CBViewController
}

public protocol UIViewControllerCreator: ViewControllerCreator {
    associatedtype ViewController: CBViewController

    /**
     This method should be used when it is necessarly to set a property to the view, but only the ones that don't
     depend on view hierarchy. `onNotRendered(_:)` is executed on `willMoveToSuperview`.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    func onNotRendered(_ handler: @escaping (CBViewController) -> Void) -> UICNotRenderedModifierController<ViewController>

    /**
     This method should be used when the view is in the local hierarchy and it's needed to set
     a property on that moment. `onRendered(_:)` is executed on `didMoveToSuperview(_:)`.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    func onRendered(_ handler: @escaping (CBViewController) -> Void) -> UICRenderedModifierController<ViewController>

    /**
     This method should be used when the view is in the window hierarchy, accessing view controllers
     on hierarchy. `onInTheScene(_:)` is executed on `didMoveToWindow`.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    func onInTheScene(_ handler: @escaping (CBViewController) -> Void) -> UICInTheSceneModifierController<ViewController>

    /**
     This method calls the handler parameter when the UIView calls `layoutSubviews`.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    func onLayout(_ handler: @escaping (CBViewController) -> Void) -> UICLayoutModifierController<ViewController>

    /**
     This method calls the handler parameter when the UIView is hidden, moved from heirarchy or when the frame changes
     to visible layout.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    func onAppear(_ handler: @escaping (CBViewController) -> Void) -> UICAppearModifierController<ViewController>

    /**
     This method calls the handler parameter when the UIView is hidden, moved from heirarchy or when the frame changes
     to invisible layout.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    func onDisappear(_ handler: @escaping (CBViewController) -> Void) -> UICDisappearModifierController<ViewController>
}

extension ViewControllerCreator {
    @usableFromInline
    func releaseViewController() -> CBViewController {
        Self._makeUIViewController(self)
    }
}

public extension UIViewControllerCreator {
    static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        Views.ViewControllerAdaptor((viewCreator as! Self).releaseViewController())
    }
}

public extension UIViewControllerCreator {
    @inline(__always) @inlinable
    func onNotRendered(_ handler: @escaping (CBViewController) -> Void) -> UICNotRenderedModifierController<ViewController> {
        UICNotRenderedModifierController(self, onNotRendered: handler)
    }

    @inline(__always) @inlinable
    func onRendered(_ handler: @escaping (CBViewController) -> Void) -> UICRenderedModifierController<ViewController> {
        UICRenderedModifierController(self, onRendered: handler)
    }

    @inline(__always) @inlinable
    func onInTheScene(_ handler: @escaping (CBViewController) -> Void) -> UICInTheSceneModifierController<ViewController> {
        UICInTheSceneModifierController(self, onInTheScene: handler)
    }
}

public extension UIViewControllerCreator {

    @inline(__always) @inlinable
    func onLayout(_ handler: @escaping (CBViewController) -> Void) -> UICLayoutModifierController<ViewController> {
        UICLayoutModifierController(self, onLayout: handler)
    }

    @inline(__always) @inlinable
    func onAppear(_ handler: @escaping (CBViewController) -> Void) -> UICAppearModifierController<ViewController> {
        UICAppearModifierController(self, onAppear: handler)
    }

    @inline(__always) @inlinable
    func onDisappear(_ handler: @escaping (CBViewController) -> Void) -> UICDisappearModifierController<ViewController> {
        UICDisappearModifierController(self, onDisappear: handler)
    }
}

public extension UIViewControllerCreator {

    @inlinable
    func `as`(_ outlet: UICOutlet<ViewController>) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            outlet.ref($0 as? ViewController)
        }
    }
}

public extension UIViewControllerCreator {

    @inlinable
    func eraseToAnyView() -> UICAnyView {
        UICAnyView(self)
    }
}
