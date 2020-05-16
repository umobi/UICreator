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

public class UICNavigation: NavigationRepresentable {

    public var navigationLoader: (UIViewController) -> UINavigationController {
        return {
            return .init(rootViewController: $0)
        }
    }

    public init(_ content: @escaping () -> ViewCreator) {
        self.content = .init(content)
    }
}

public extension UICNavigation {
    class Other<NavigationController: UINavigationController>: UICNavigation {
        override public var navigationLoader: (UIViewController) -> UINavigationController {
            return {
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
    func present(animated: Bool, onCompletion: (() -> Void)? = nil, content: @escaping () -> ViewCreator) -> Self {
        let controller = UICHostingView(content: content)
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
        let controller = UICHostingView(content: content)
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
