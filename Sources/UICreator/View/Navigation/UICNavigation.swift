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

public class ViewControllerAdaptor: UIView, ViewCreatorNoLayoutConstraints {
    weak var adaptedViewController: UIViewController!

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self)?.willMove(toSuperview: newSuperview)
        RenderManager(self.adaptedViewController?.view)?.willMove(toSuperview: self)
    }

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            RenderManager(self)?.isHidden(newValue)
            RenderManager(self.adaptedViewController?.view)?.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            RenderManager(self)?.frame(newValue)
            RenderManager(self.adaptedViewController?.view)?.frame(self.adaptedViewController.view.frame)
        }
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self)?.didMoveToSuperview()
        RenderManager(self.adaptedViewController?.view)?.didMoveToSuperview()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self)?.didMoveToWindow()
        RenderManager(self.adaptedViewController?.view)?.didMoveToWindow()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self)?.layoutSubviews()
        RenderManager(self.adaptedViewController?.view)?.layoutSubviews()
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        RenderManager(self.adaptedViewController?.view)?.traitDidChange()
    }
}

private var kViewControllerAdaptor = 0
public protocol ViewControllerCreator: ViewCreator {}

extension ViewControllerCreator {
    var weakViewControllerAdaptor: ViewControllerAdaptor! {
        get {
            (objc_getAssociatedObject(
                self,
                &kViewControllerAdaptor
            ) as? ViewAdaptor.Weak<ViewControllerAdaptor>)?.object
        }

        set {
            objc_setAssociatedObject(
                self,
                &kViewControllerAdaptor,
                ViewAdaptor.Weak(object: newValue),
                .OBJC_ASSOCIATION_COPY
            )
        }
    }
}

public protocol UIViewControllerCreator: UIViewCreator, ViewControllerCreator where View == ViewControllerAdaptor {
    associatedtype ViewController: UIViewController
}

extension UIViewControllerCreator {

    func setViewController(_ viewController: ViewController) {
        let viewAdaptor = ViewControllerAdaptor(builder: self)
        self.weakViewControllerAdaptor = viewAdaptor
        self.loadView {
            return viewAdaptor
        }
        .onNotRendered {
            ($0 as? View)?.adaptedViewController = viewController
        }
        .onInTheScene {
            $0.viewController.addChild(viewController)
            $0.add(priority: .required, viewController.view)
            viewController.didMove(toParent: $0.viewController)
        }
    }
}

public protocol UICNavigationExtendable {
    func makeNavigationController(_ rootViewController: UIViewController) -> UINavigationController
}

open class UICNavigation: UIViewControllerCreator, NavigationRepresentable {
    public typealias ViewController = UINavigationController

    public init(_ content: @escaping () -> ViewCreator) {
        let viewController = UICHostingController(content: content)

        if let extended = self as? UICNavigationExtendable {
            self.setViewController(extended.makeNavigationController(viewController))
            return
        }

        self.setViewController(UINavigationController(rootViewController: viewController))
    }
}

public extension ViewCreator {

    private var presentable: UIViewController! {
        guard let viewController = self.uiView?.window?.rootViewController else {
            return nil
        }

        return sequence(
            first: viewController,
            next: { $0.presentedViewController }
        )
        .reversed()
        .first
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

    var presentMaker: UICPresent {
        .init(fromView: self)
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
        return ViewControllerSearch(
            self,
            searchFor: UINavigationController.self
        ).viewNearFromSearch?.navigationItem
    }
}

struct ViewControllerSearch<ViewController: UIViewController> {
    weak var view: UIView!

    init(_ view: UIView, searchFor type: ViewController.Type) {
        self.view = view
    }

    var viewNearFromSearch: UIViewController? {
        let responders = sequence(
            first: self.view! as UIResponder,
            next: { $0.next }
        )

        var viewNearFromNavigation: UIViewController?

        for responder in responders {
            if responder is ViewController {
                return viewNearFromNavigation
            }

            if let viewController = responder as? UIViewController {
                viewNearFromNavigation = viewController
            }
        }

        return viewNearFromNavigation
    }
}
