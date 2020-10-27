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

public struct NavigationRepresentable {
    weak var view: UIView!
}

func OBJCSet<Object>(
    _ index: Any,
    _ key: UnsafeRawPointer,
    policity: objc_AssociationPolicy,
    orLoad: @escaping () -> Object) -> Object {
    guard let object = objc_getAssociatedObject(index, key) as? Object else {
        let object = orLoad()
        objc_setAssociatedObject(index, key, object, policity)
        return object
    }

    return object
}

public extension NavigationRepresentable {
    var navigationController: UINavigationController! {
        guard
            let viewController = ViewControllerSearch(
                self.view,
                searchFor: UINavigationController.self
            ).viewNearFromSearch
        else { return nil }

        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }

        return viewController.navigationController
    }
}

public extension NavigationRepresentable {

    var navigationBar: UINavigationBar {
        self.navigationController.navigationBar
    }

    @discardableResult
    func push(animated: Bool, content: @escaping () -> ViewCreator) -> Self {
        self.navigationController.pushViewController(UICHostingController(content: content), animated: animated)
        return self
    }

    @discardableResult
    func push(animated: Bool, _ viewController: UIViewController) -> Self {
        self.navigationController.pushViewController(viewController, animated: animated)
        return self
    }

    @discardableResult
    func pop(animated: Bool) -> Self {
        self.navigationController.popViewController(animated: animated)
        return self
    }

    @discardableResult
    func popToRoot(animated: Bool) -> Self {
        self.navigationController.popToRootViewController(animated: animated)
        return self
    }

    @discardableResult
    func popTo(view: ViewCreator, animated: Bool) -> Self {
        guard let viewController = self.navigationController.viewControllers.first(where: {
            $0.view.contains(view)
        }) else {
            Fatal.Builder("\(type(of: view)) is not on first hierarchy").die()
        }

        self.navigationController.popToViewController(viewController, animated: animated)
        return self
    }
}

public extension UIView {
    func contains(_ viewCreator: ViewCreator) -> Bool {
        fatalError()
    }

    func contains(where handler: @escaping (ViewCreator) -> Bool) -> Bool {
        fatalError()
    }
}
