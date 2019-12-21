//
//  UIView+Base.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public extension UIView {
    weak var navigation: Navigation? {
        guard self is ViewBuilder else {
            fatalError("You shouldn't call present on view that is not of ViewBuilder type")
        }

        return sequence(first: self, next: { $0.superview }).first(where: {
            $0 is Navigation
        }) as? Navigation
    }
}

public extension UIView {

    @discardableResult
    func present(animated: Bool, onCompletion: (() -> Void)? = nil, _ content: () -> UIView) -> Self {
        guard let uiView = self as? ViewBuilder else {
            fatalError("You shouldn't call present on view that is not of ViewBuilder type")
        }

        let controller = ContainerController(Host(content))
        uiView.viewController?.present(controller, animated: animated, completion: onCompletion)
        return self
    }

    @discardableResult
    func present<View: ViewControllerType>(animated: Bool, onCompletion: (() -> Void)? = nil, _ content: View) -> Self {
        guard let uiView = self as? ViewBuilder else {
            fatalError("You shouldn't call present on view that is not of ViewBuilder type")
        }

        let controller = ContainerController(content)
        uiView.viewController?.present(controller, animated: animated, completion: onCompletion)
        return self
    }

    @discardableResult
    func dismiss(animated: Bool, onCompletion: (() -> Void)? = nil) -> Self {
        guard let uiView = self as? ViewBuilder else {
            fatalError("You shouldn't call present on view that is not of ViewBuilder type")
        }

        uiView.viewController?.dismiss(animated: animated, completion: onCompletion)
        return self
    }

    @discardableResult
    func present(animated: Bool, onCompletion: (() -> Void)? = nil, _ viewController: UIViewController) -> Self {
        guard let uiView = self as? ViewBuilder else {
            fatalError("You shouldn't call present on view that is not of ViewBuilder type")
        }

        uiView.viewController?.present(viewController, animated: animated, completion: onCompletion)
        return self
    }

    var navigationItem: UINavigationItem! {
        guard let uiView = self as? ViewBuilder else {
            fatalError("You shouldn't call present on view that is not of ViewBuilder type")
        }

        return uiView.viewController?.navigationItem
    }
}
