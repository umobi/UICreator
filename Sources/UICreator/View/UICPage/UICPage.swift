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
    private typealias View = ControllerView<UIViewController>

    public typealias ViewController = PageViewController

    public init(
        transitionStyle: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey: Any]?) {

        self.loadView {
            ControllerView<ViewController>(builder: self)
        }
        .onInTheScene {
            ($0 as? View)?.contain(viewController: {
                let pageController = PageViewController(
                    transitionStyle: transitionStyle,
                    navigationOrientation: navigationOrientation,
                    options: options
                )

                pageController.delegate = pageController
                pageController.dataSource = pageController

                return pageController
            }())
        }
    }
}

public extension UIViewControllerCreator where ViewController: UIPageViewController {
    func pages(
        direction: UIPageViewController.NavigationDirection,
        @UICViewBuilder  _ contents: @escaping () -> ViewCreator) -> Self {
        let contents: [UICHostingController] = contents().zip.map { content in
            self.tree.append(content)

            return UICHostingController(view: content)
        }

        return self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.updateViewControllers(contents, direction: direction, animated: false, completion: nil)
        }
    }
}

public extension UICPage {
    #if os(iOS)
    func spineLocation(_ handler: @escaping (UIInterfaceOrientation) -> UIPageViewController.SpineLocation) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.spineLocationHandler = handler
        }
    }
    #endif

    func onPageChanged(_ handler: @escaping (Int) -> Void) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.onPageChangeHandler = handler
        }
    }

    func isInfinityScroll(_ flag: Bool) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.isInfinityScroll = flag
        }
    }
}
