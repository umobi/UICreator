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

public class UICPage: UICViewControllerCreator {
    public typealias View = ViewControllerAdaptor<PageViewController>
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

    public static func makeUIView(_ viewCreator: ViewCreator) -> UIView {
        let _self = viewCreator as! Self

        return UICControllerAdapt {
            {
                let pageController = PageViewController(
                    transitionStyle: _self.transitionStyle,
                    navigationOrientation: _self.navigationOrientation,
                    options: _self.options
                )

                pageController.delegate = pageController
                pageController.dataSource = pageController

                return pageController
            }()
        }
        .releaseUIView()
    }
}

public extension UICViewControllerCreator where ViewController: UIPageViewController {
    func pages(
        direction: UIPageViewController.NavigationDirection,
        @UICViewBuilder  _ contents: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?
                .dynamicViewController
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

public extension UICPage {
    #if os(iOS)
    func spineLocation(_ handler: @escaping (UIInterfaceOrientation) -> UIPageViewController.SpineLocation) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?
                .dynamicViewController
                .spineLocationHandler = handler
        }
    }
    #endif

    func onPageChanged(_ handler: @escaping (Int) -> Void) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?
                .dynamicViewController
                .onPageChangeHandler = handler
        }
    }

    func isInfinityScroll(_ flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?
                .dynamicViewController
                .isInfinityScroll = flag
        }
    }
}
