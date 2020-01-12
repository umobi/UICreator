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

public class Navigation: Root, NavigationRepresentable {

    public var navigationLoader: (UIViewController) -> UINavigationController {
        {
            return .init(rootViewController: $0)
        }
    }

    public init(_ content: @escaping () -> ViewCreator) {
        super.init()
        self.content = .init(content)
    }
}

public extension Navigation {
    class Other<NavigationController: UINavigationController>: Navigation {
        override public var navigationLoader: (UIViewController) -> UINavigationController {
            {
                return NavigationController(rootViewController: $0)
            }
        }
    }
}


//public extension UIView {
//    weak var navigation: UINavigationController? {
////        guard self is UIViewRender else {
////            fatalError("You shouldn't call present on view that is not of ViewCreator type")
////        }
//
//        return sequence(first: self, next: { $0.superview }).first(where: {
//            $0 is Navigation
//        }) as? Navigation
//    }
//}

public extension ViewCreator {

    @discardableResult
    func present<View: ViewCreator>(animated: Bool, onCompletion: (() -> Void)? = nil, content: @escaping () -> View) -> Self {
        let controller = ContainerController(Host(content: content))
        self.viewController?.present(controller, animated: animated, completion: onCompletion)
        return self
    }

    @discardableResult
    func present<View: ViewControllerType>(animated: Bool, onCompletion: (() -> Void)? = nil,_ content: View) -> Self {
        let controller = ContainerController(content)
        self.viewController?.present(controller, animated: animated, completion: onCompletion)
        return self
    }

    @discardableResult
    func dismiss(animated: Bool, onCompletion: (() -> Void)? = nil) -> Self {
        self.viewController?.dismiss(animated: animated, completion: onCompletion)
        return self
    }

    @discardableResult
    func present(animated: Bool, onCompletion: (() -> Void)? = nil, _ viewController: UIViewController) -> Self {
        self.viewController?.present(viewController, animated: animated, completion: onCompletion)
        return self
    }

    var navigationItem: UINavigationItem! {
        return self.viewController?.navigationItem
    }
}

public extension UIView {
    var navigationItem: UINavigationItem! {
        return self.viewController?.navigationItem
    }
}
