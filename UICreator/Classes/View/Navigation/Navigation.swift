//
//  Navigation.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
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

    public required init(loader: (() -> View)? = nil) {
        super.init(loader: loader)
    }
}

public extension TemplateView where Self: Root & NavigationRepresentable {
    init(_ content: @escaping () -> ViewCreator) {
        self.init()
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
