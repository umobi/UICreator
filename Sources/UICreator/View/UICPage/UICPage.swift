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

public class UICPage: UIViewControllerCreator {
    public typealias ViewController = PageViewController

    public init(
        transitionStyle: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey: Any]?) {

        let pageController = PageViewController(
            transitionStyle: transitionStyle,
            navigationOrientation: navigationOrientation,
            options: options
        )

        pageController.delegate = pageController
        pageController.dataSource = pageController

        self.setViewController(pageController)
    }

    var pageController: PageViewController! {
        self.weakViewControllerAdaptor.adaptedViewController as? PageViewController
    }
}

public extension UICPage {
    func `as`<Controller: UIPageViewController>(_ reference: UICOutlet<Controller>) -> Self {
        return self.onInTheScene { [weak self, reference] _ in
            reference.ref(self?.pageController as? Controller)
        }
    }

    func pages(
        direction: UIPageViewController.NavigationDirection,
        _ contents: @escaping () -> [ViewCreator]) -> Self {
        let contents: [UICHostingController] = contents().map { content in
            self.tree.append(content)

            return UICHostingController(view: content)
        }

        return self.onInTheScene { [unowned self] _ in
            self.pageController.updateViewControllers(contents, direction: direction, animated: false, completion: nil)
        }
    }
}

public extension UICPage {
    #if os(iOS)
    func spineLocation(_ handler: @escaping (UIInterfaceOrientation) -> UIPageViewController.SpineLocation) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.pageController.spineLocationHandler = handler
        }
    }
    #endif

    func onPageChanged(_ handler: @escaping (Int) -> Void) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.pageController.onPageChangeHandler = handler
        }
    }

    func isInfinityScroll(_ flag: Bool) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.pageController.isInfinityScroll = flag
        }
    }
}
