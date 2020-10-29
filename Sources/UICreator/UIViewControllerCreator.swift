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

public protocol UIViewControllerCreator: ViewCreator {
    associatedtype ViewController: CBViewController

    static func _makeUIViewController(_ viewCreator: ViewCreator) -> CBViewController

    /**
     This method should be used when it is necessarly to set a property to the view, but only the ones that don't
     depend on view hierarchy. `onNotRendered(_:)` is executed on `willMoveToSuperview`.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    func onNotRendered(_ handler: @escaping (CBViewController) -> Void) -> UICModifiedViewController<ViewController>

    /**
     This method should be used when the view is in the local hierarchy and it's needed to set
     a property on that moment. `onRendered(_:)` is executed on `didMoveToSuperview(_:)`.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    func onRendered(_ handler: @escaping (CBViewController) -> Void) -> UICModifiedViewController<ViewController>

    /**
     This method should be used when the view is in the window hierarchy, accessing view controllers
     on hierarchy. `onInTheScene(_:)` is executed on `didMoveToWindow`.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    func onInTheScene(_ handler: @escaping (CBViewController) -> Void) -> UICModifiedViewController<ViewController>

    /**
     This method calls the handler parameter when the UIView calls `layoutSubviews`.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    func onLayout(_ handler: @escaping (CBViewController) -> Void) -> UICModifiedViewController<ViewController>

    /**
     This method calls the handler parameter when the UIView is hidden, moved from heirarchy or when the frame changes
     to visible layout.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    func onAppear(_ handler: @escaping (CBViewController) -> Void) -> UICModifiedViewController<ViewController>

    /**
     This method calls the handler parameter when the UIView is hidden, moved from heirarchy or when the frame changes
     to invisible layout.

     - Parameters:
        - handler: The commit handler that expose the UIView inside the ViewCreator.

     - Returns: Returns a self reference to compose the declarative programming.
     */
    func onDisappear(_ handler: @escaping (CBViewController) -> Void) -> UICModifiedViewController<ViewController>
}

extension UIViewControllerCreator {
    @usableFromInline
    func releaseCastedViewController() -> ViewController {
        Self._makeUIViewController(self) as! ViewController
    }
}

public extension UIViewControllerCreator {
    static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        Views.ViewControllerAdaptor((viewCreator as! Self).releaseCastedViewController())
    }
}

public extension UIViewControllerCreator {
    @inlinable
    func onNotRendered(_ handler: @escaping (CBViewController) -> Void) -> UICModifiedViewController<ViewController> {
        UICModifiedViewController {
            let viewController = self.releaseCastedViewController()
            viewController.view.onNotRendered { [weak viewController] _ in
                handler(viewController!)
            }
            return viewController
        }
    }

    @inlinable
    func onRendered(_ handler: @escaping (CBViewController) -> Void) -> UICModifiedViewController<ViewController> {
        UICModifiedViewController {
            let viewController = self.releaseCastedViewController()
            viewController.view.onRendered { [weak viewController] _ in
                handler(viewController!)
            }
            return viewController
        }
    }

    @inlinable
    func onInTheScene(_ handler: @escaping (CBViewController) -> Void) -> UICModifiedViewController<ViewController> {
        UICModifiedViewController {
            let viewController = self.releaseCastedViewController()
            viewController.view.onInTheScene { [weak viewController] _ in
                handler(viewController!)
            }
            return viewController
        }
    }
}

public extension UIViewControllerCreator {

    @inlinable
    func onLayout(_ handler: @escaping (CBViewController) -> Void) -> UICModifiedViewController<ViewController> {
        UICModifiedViewController {
            let viewController = self.releaseCastedViewController()
            viewController.view.onLayout { [weak viewController] _ in
                handler(viewController!)
            }
            return viewController
        }
    }

    @inlinable
    func onAppear(_ handler: @escaping (CBViewController) -> Void) -> UICModifiedViewController<ViewController> {
        UICModifiedViewController {
            let viewController = self.releaseCastedViewController()
            viewController.view.onAppear { [weak viewController] _ in
                handler(viewController!)
            }
            return viewController
        }
    }

    @inlinable
    func onDisappear(_ handler: @escaping (CBViewController) -> Void) -> UICModifiedViewController<ViewController> {
        UICModifiedViewController {
            let viewController = self.releaseCastedViewController()
            viewController.view.onDisappear { [weak viewController] _ in
                handler(viewController!)
            }
            return viewController
        }
    }
}

public extension UIViewControllerCreator {

    @inlinable
    func `as`(_ outlet: UICOutlet<ViewController>) -> UICModifiedViewController<ViewController> {
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
