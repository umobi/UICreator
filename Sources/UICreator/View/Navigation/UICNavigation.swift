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

public protocol UIViewControllerCreator: ViewCreator {
    associatedtype ViewController: UIViewController
}

public extension UIViewControllerCreator {
    var wrappedViewController: ViewController! {
        if let controllerView = self.uiView as? ControllerView<UIViewController> {
            return controllerView.view as? ViewController
        }

        if self is ViewControllerRepresentable {
            return self.uiView.next as? ViewController
        }

        fatalError("Couldn't find view controller")
    }
}

public extension UIViewControllerCreator {
    func `as`(_ reference: UICOutlet<ViewController>) -> Self {
        return self.onInTheScene { [weak self, reference] _ in
            reference.ref(self?.wrappedViewController)
        }
    }
}

public class UICNavigation: UIViewControllerCreator {
    private typealias View = ControllerView<UIViewController>
    
    public typealias ViewController = UINavigationController

    public init(_ content: @escaping () -> ViewCreator) {
        self.loadView {
            View(builder: self)
        }
        .onInTheScene {
            ($0 as? View)?.contain(viewController: ViewController(rootViewController: UICHostingController(content: content)))
        }
    }
}

private extension UIView {
    var presentable: UIViewController! {
        guard let viewController = self.window?.rootViewController else {
            return nil
        }

        return sequence(
            first: viewController,
            next: { $0.presentedViewController }
        )
        .reversed()
        .first
    }
}

private extension ViewCreator {
    func dynamicPresent(
        _ relay: Relay<Bool>,
        animated flag: Bool = true,
        content: @escaping () -> ViewCreator,
        viewControllerBuilder: ((UIViewController) -> Void)?) -> Self {

        self.onInTheScene {
            weak var view = $0
            weak var presentingView: UIViewController?

            relay.sync {
                if $0 {
                    guard presentingView == nil else {
                        return
                    }

                    guard let presentable = view?.viewCreator?.presentable else {
                        relay.wrappedValue = false
                        return
                    }

                    let aboutToPresent = UICHostingController(content: content)
                    aboutToPresent.onDismiss {
                        relay.wrappedValue = false
                    }

                    viewControllerBuilder?(aboutToPresent)

                    presentable.present(aboutToPresent, animated: flag, completion: nil)
                    presentingView = aboutToPresent
                } else {
                    guard let presentedView = presentingView else {
                        return
                    }

                    presentedView.dismiss(animated: flag, completion: nil)
                }
            }
        }
    }
}

public extension ViewCreator {

    private var presentable: UIViewController! {
        self.uiView?.presentable
    }

    @discardableResult
    func present(animated: Bool, onCompletion: (() -> Void)? = nil, content: @escaping () -> ViewCreator) -> Self {
        let controller = UICHostingController(content: content)
        self.presentable?.present(controller, animated: animated, completion: onCompletion)
        return self
    }

    @discardableResult
    func present(animated: Bool, onCompletion: (() -> Void)? = nil, _ viewController: UIViewController) -> Self {
        self.presentable?.present(viewController, animated: animated, completion: onCompletion)
        return self
    }

    func present(_ relay: Relay<Bool>, content: @escaping () -> ViewCreator) -> Self {
        self.dynamicPresent(
            relay,
            content: content,
            viewControllerBuilder: nil
        )
    }

    func presentMaker(_ relay: Relay<Bool>, maker: @escaping (UICPresent) -> UICPresent) -> Self {
        let maker = maker(.init(fromView: self))

        return self.dynamicPresent(
            relay,
            animated: maker.animated,
            content: maker.toView!,
            viewControllerBuilder: maker.recycle(viewController:)
        )
    }

    @discardableResult
    func presentModal(animated: Bool, onCompletion: (() -> Void)? = nil, content: @escaping () -> ViewCreator) -> Self {
        let controller = UICHostingController(content: content)
        controller.modalPresentationStyle = .overFullScreen
        self.presentable?.present(controller, animated: animated, completion: onCompletion)
        return self
    }

    @discardableResult
    func presentModal(animated: Bool, onCompletion: (() -> Void)? = nil, _ viewController: UIViewController) -> Self {
        viewController.modalPresentationStyle = .overFullScreen
        self.presentable?.present(viewController, animated: animated, completion: onCompletion)
        return self
    }

    func presentModal(_ relay: Relay<Bool>, content: @escaping () -> ViewCreator) -> Self {
        self.dynamicPresent(
            relay,
            content: content,
            viewControllerBuilder: {
                $0.modalPresentationStyle = .overFullScreen
            }
        )
    }

    @discardableResult
    func dismiss(animated: Bool, onCompletion: (() -> Void)? = nil) -> Self {
        self.viewController?.dismiss(animated: animated, completion: onCompletion)
        return self
    }

    var navigationItem: UINavigationItem! {
        return self.uiView?.navigationItem
    }
}

public extension UIView {
    var navigationItem: UINavigationItem! {
        guard
            let viewController = ViewControllerSearch(
                self,
                searchFor: UINavigationController.self
            ).viewNearFromSearch
        else { return nil }

        if let navigationController = viewController as? UINavigationController {
            return navigationController.visibleViewController?.navigationItem
        }

        return viewController.navigationItem
    }
}

struct ViewControllerSearch<ViewController: UIViewController> {
    weak var view: UIView!

    init(_ view: UIView, searchFor type: ViewController.Type) {
        self.view = view
    }

    var viewNearFromSearch: UIViewController? {
        guard let viewController = self.view.viewController else {
            return nil
        }

        var viewNearFromNavigation: UIViewController? = viewController

        for viewController in sequence(first: viewController, next: { $0.parent }) {
            if viewController is ViewController {
                return viewNearFromNavigation
            }

            viewNearFromNavigation = viewController
        }

        return viewNearFromNavigation
    }
}
