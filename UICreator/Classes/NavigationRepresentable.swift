//
//  NavigationRepresentable.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public protocol NavigationRepresentable: TemplateView {
    var navigationLoader: (UIViewController) -> UINavigationController { get }
    init(_ content: @escaping () -> UIView)

    @discardableResult
    func push(animated: Bool, _ content: () -> UIView) -> Self

    @discardableResult
    func push(animated: Bool, _ viewController: UIViewController) -> Self

    @discardableResult
    func pop(animated: Bool) -> Self

    @discardableResult
    func popToRoot(animated: Bool) -> Self

    @discardableResult
    func popTo(view: UIView, animated: Bool) -> Self
}

private var kContentHandler: UInt = 0

class ContentHandler {
    let content: () -> UIView
    init(_ content: @escaping () -> UIView) {
        self.content = content
    }
}

public extension NavigationRepresentable {
    weak var navigationController: UINavigationController! {
        return (self.subviews.first(where: {
            $0 is Container<UIViewController>
        }) as? Container<UIViewController>)?.view as? UINavigationController
    }

    private var content: ContentHandler? {
        get { objc_getAssociatedObject(self, &kContentHandler) as? ContentHandler }
        set { objc_setAssociatedObject(self, &kContentHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    init(_ content: @escaping () -> UIView) {
        self.init()
        self.content = .init(content)
    }

    var body: UIView {
        Container {
            guard let content = self.content?.content else {
                fatalError()
            }

            self.content = nil
            return self.navigationLoader(ContainerController(Host(content)))
        }
    }

    @discardableResult
    func push(animated: Bool, _ content: () -> UIView) -> Self {
        self.navigationController.pushViewController(ContainerController(Host(content)), animated: animated)
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
    func popTo(view: UIView, animated: Bool) -> Self {
        guard let viewController = self.navigationController.viewControllers.first(where: {
            ($0 as? ContainerController<Host>)?.contentView?.subviews.first(where: {
                $0 === view
            }) != nil
        }) else {
            fatalError("\(type(of: view)) is not on first hierarchy")
        }

        self.navigationController.popToViewController(viewController, animated: animated)
        return self
    }
}
