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

extension CBView {
    @usableFromInline
    var viewController: CBViewController! {
        sequence(first: self, next: { $0.superview })
            .first(where: { $0.next is CBViewController })?
            .next as? CBViewController
    }
}

extension CBView {
    @usableFromInline
    func nearHostingController() -> UICHostingController! {
        guard let viewController = self.viewController else {
            return nil
        }

        if let hostingController = viewController as? UICHostingController {
            return hostingController
        }

        return sequence(first: viewController, next: { $0.parent })
            .first(where: { $0 is UICHostingController })
            as? UICHostingController
    }
}

extension CBView {
    func nearVCFromTabBarController() -> CBViewController! {
        guard let viewController = self.viewController else {
            return nil
        }

        if let tabBarController = viewController as? UITabBarController {
            return tabBarController.selectedViewController
        }

        return sequence(first: viewController, next: { $0.parent })
            .first(where: { $0.parent is UITabBarController })
    }
}

extension CBView {

    @usableFromInline
    func nearVCFromNavigation() -> CBViewController! {
        guard let viewController = self.viewController else {
            return nil
        }

        if let navigationController = viewController as? UINavigationController {
            return navigationController.visibleViewController
        }

        return sequence(
            first: viewController,
            next: { $0.parent }
        )
        .first(where: {
            $0.parent is UINavigationController
        })
    }
}

extension CBView {

    @usableFromInline
    func presentableViewController() -> CBViewController! {
        self.window?.rootViewController.map {
            sequence(first: $0, next: { $0.presentedViewController })
                .reversed()
                .first!
        }
    }
}

extension CBView {
    @inline(__always) @usableFromInline
    var navigationController: UINavigationController? {
        self.nearVCFromNavigation()?.navigationController
    }
}

extension CBView {
    @inline(__always) @usableFromInline
    var navigationItem: UINavigationItem! {
        self.nearVCFromNavigation()?.navigationItem
    }
}

extension CBView {
    @inline(__always) @usableFromInline
    var tabBarItem: UITabBarItem? {
        get { self.nearVCFromTabBarController()?.tabBarItem }
        set { self.nearVCFromTabBarController()?.tabBarItem = newValue }
    }
}

public extension UITabBarController {
    func setViewControllers(@UICTabItemBuilder _ contents: () -> UICTabItem) {
        let viewControllers: [UIViewController] = contents().zip.map {
            let controller = UICHostingController(rootView: $0.content)
            controller.tabBarItem = $0.tabItem
            return controller
        }

        self.viewControllers = viewControllers
    }
}
