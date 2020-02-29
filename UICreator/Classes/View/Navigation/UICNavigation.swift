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

public struct UICPresent {
    let presentingStyle: UIModalPresentationStyle
    let transitionStyle: UIModalTransitionStyle
    let fromView: ViewCreator
    let toView: ViewCreator?
    let onCompletion: (() -> Void)?
    let animated: Bool

    init(fromView: ViewCreator) {
        self.fromView = fromView
        self.toView = nil
        self.onCompletion = nil
        if #available(iOS 13, tvOS 13, *) {
            self.presentingStyle = .automatic
        } else {
            self.presentingStyle = .currentContext
        }
        self.transitionStyle = .coverVertical
        self.animated = true
    }

    private init(_ original: UICPresent, editable: Editable) {
        self.presentingStyle = editable.presentingStyle
        self.transitionStyle = editable.transitionStyle
        self.fromView = original.fromView
        self.toView = editable.toView
        self.onCompletion = editable.onCompletion
        self.animated = editable.animated
    }

    private func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    public func presentingStyle(_ style: UIModalPresentationStyle) -> Self {
        self.edit {
            $0.presentingStyle = style
        }
    }

    public func transitionStyle(_ style: UIModalTransitionStyle) -> Self {
        self.edit {
            $0.transitionStyle = style
        }
    }

    public func onCompletion(_ handler: @escaping () -> Void) -> Self {
        self.edit {
            $0.onCompletion = handler
        }
    }

    public func animated(_ flag: Bool) -> Self {
        self.edit {
            $0.animated = flag
        }
    }

    func present() {
        let viewController = ContainerController(UICHost {
            self.toView!
        })

        viewController.modalPresentationStyle = self.presentingStyle
        viewController.modalTransitionStyle = self.transitionStyle

        self.fromView.present(animated: self.animated, onCompletion: self.onCompletion, viewController)
    }

    public func present(content: @escaping () -> ViewCreator) {
        self.edit {
            $0.toView = content()
        }.present()
    }

    private class Editable {
        var presentingStyle: UIModalPresentationStyle
        var transitionStyle: UIModalTransitionStyle
        var toView: ViewCreator?
        var onCompletion: (() -> Void)?
        var animated: Bool

        init(_ present: UICPresent) {
            self.presentingStyle = present.presentingStyle
            self.transitionStyle = present.transitionStyle
            self.toView = present.toView
            self.onCompletion = present.onCompletion
            self.animated = present.animated
        }
    }
}

public class UICNavigation: Root, NavigationRepresentable {

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

public extension UICNavigation {
    class Other<NavigationController: UINavigationController>: UICNavigation {
        override public var navigationLoader: (UIViewController) -> UINavigationController {
            {
                return NavigationController(rootViewController: $0)
            }
        }
    }
}

public extension ViewCreator {

    private var presentable: UIViewController! {
        guard let viewController = self.uiView.window?.rootViewController else {
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
    func present<View: ViewCreator>(animated: Bool, onCompletion: (() -> Void)? = nil, content: @escaping () -> View) -> Self {
        let controller = ContainerController(UICHost(content: content))
        self.presentable?.present(controller, animated: animated, completion: onCompletion)
        return self
    }

    @discardableResult
    func present<View: ViewControllerType>(animated: Bool, onCompletion: (() -> Void)? = nil,_ content: View) -> Self {
        let controller = ContainerController(content)
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
    func presentModal<View: ViewCreator>(animated: Bool, onCompletion: (() -> Void)? = nil, content: @escaping () -> View) -> Self {
        let controller = ContainerController(UICHost(content: content))
        controller.modalPresentationStyle = .overFullScreen
        self.presentable?.present(controller, animated: animated, completion: onCompletion)
        return self
    }

    @discardableResult
    func presentModal<View: ViewControllerType>(animated: Bool, onCompletion: (() -> Void)? = nil,_ content: View) -> Self {
        let controller = ContainerController(content)
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
        return self.viewController?.navigationItem
    }
}

public extension UIView {
    var navigationItem: UINavigationItem! {
        return self.viewController?.navigationItem
    }
}
