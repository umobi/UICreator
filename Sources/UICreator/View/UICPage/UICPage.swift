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

public class UICPage: UIViewCreator {
    public typealias View = UICPageContainer

    private(set) var transitionStyle: UIPageViewController.TransitionStyle = .scroll
    private(set) var navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal
    private(set) var options: [UIPageViewController.OptionsKey: Any]?

    private lazy var _pageViewController: UICPageViewController? = {
        let pageController: UICPageViewController = .init(
            transitionStyle: self.transitionStyle,
            navigationOrientation: self.navigationOrientation,
            options: self.options
        )

        pageController.dataSource = pageController
        pageController.delegate = pageController

        return pageController
    }()

    private weak var pageViewController: UICPageViewController! {
        willSet {
            self._pageViewController = nil
        }
    }

    var pageController: UICPageViewController! {
        return self._pageViewController ?? self.pageViewController
    }

    public init(
        transitionStyle: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey: Any]?) {
        self.loadView { [unowned self] in
            self.transitionStyle = transitionStyle
            self.navigationOrientation = navigationOrientation
            self.options = options
            let view = View.init(builder: self)
            view.setContent { [unowned self] in
                let pageViewController = self._pageViewController!
                self.pageViewController = pageViewController
                return pageViewController
            }
            return view
        }
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
        let contents = contents().map { content in
            UICHostingView(content: { content })
        }

        contents.forEach {
            self.tree.append($0.hostedView)
        }

        return self.onInTheScene { [unowned self] _ in
            self.pageController.updateViewControllers(contents, direction: direction, animated: false, completion: nil)
        }
    }

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

    func addIndicator(atLocation location: View.IndicatorViewPosition, content: @escaping () -> ViewCreator) -> Self {
        let content = UICHost(content: content)
        self.tree.append(content)

        return self.onInTheScene {
            ($0 as? View)?.setIndicatorViews(location: location, views: [content.releaseUIView()])
        }
    }
}
