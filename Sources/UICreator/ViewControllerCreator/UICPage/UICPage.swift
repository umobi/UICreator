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

public struct UICPage: UIViewControllerCreator {
    public typealias ViewController = PageViewController

    let transitionStyle: UIPageViewController.TransitionStyle
    let navigationOrientation: UIPageViewController.NavigationOrientation
    let options: [UIPageViewController.OptionsKey: Any]?

    public init(
        transitionStyle: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey: Any]?) {

        self.transitionStyle = transitionStyle
        self.navigationOrientation = navigationOrientation
        self.options = options
    }

    public static func makeUIViewController(_ viewCreator: ViewCreator) -> UIViewController {
        let _self = viewCreator as! Self

        let pageController = PageViewController(
            transitionStyle: _self.transitionStyle,
            navigationOrientation: _self.navigationOrientation,
            options: _self.options
        )

        pageController.delegate = pageController
        pageController.dataSource = pageController

        return pageController
    }
}

public extension UIViewControllerCreator where ViewController: UIPageViewController {
    func pages(
        direction: UIPageViewController.NavigationDirection,
        @UICViewBuilder  _ contents: @escaping () -> ViewCreator) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?
                .updateViewControllers(
                    {
                        contents().zip.map {
                            UICHostingController(rootView: $0)
                        }
                    }(),
                    direction: direction,
                    animated: false,
                    completion: nil
                )
        }
    }
}

public extension UIViewControllerCreator where ViewController: PageViewController {
    #if os(iOS)
    func spineLocation(_ handler: @escaping (UIInterfaceOrientation) -> UIPageViewController.SpineLocation) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.spineLocationHandler = handler
        }
    }
    #endif

    func onPageChanged(_ handler: @escaping (Int) -> Void) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.onPageChangeHandler = handler
        }
    }

    func isInfinityScroll(_ flag: Bool) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.isInfinityScroll = flag
        }
    }
}
