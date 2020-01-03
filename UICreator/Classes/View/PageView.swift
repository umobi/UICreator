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

public class PageController: UIPageViewController {
    private var queuedViewControllers: [UIViewController]!

    public func updateViewControllers(_ viewControllers: [UIViewController], direction: UIPageViewController.NavigationDirection, animated flag: Bool, completion: ((Bool) -> Void)? = nil) {
        self.queuedViewControllers = viewControllers
        self.setViewControllers([viewControllers.first].compactMap { $0 }, direction: .forward, animated: flag, completion: completion)
    }
}

extension PageController: UIPageViewControllerDelegate {

}

extension PageController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let queueViews = self.queuedViewControllers ?? []
        return queueViews.split(maxSplits: 1, omittingEmptySubsequences: true, whereSeparator: {
            $0 === viewController
        }).first?.last
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let queueViews = self.queuedViewControllers ?? []
        return queueViews.split(maxSplits: 1, omittingEmptySubsequences: true, whereSeparator: {
            $0 === viewController
        }).last?.first
    }
}

public class Pages: Root {
    private(set) var transitionStyle: UIPageViewController.TransitionStyle = .scroll
    private(set) var navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal
    private(set) var options: [UIPageViewController.OptionsKey: Any]?

    private lazy var _pageViewController: PageController? = {
        let pageController: PageController = .init(transitionStyle: self.transitionStyle, navigationOrientation: self.navigationOrientation, options: self.options)

        pageController.dataSource = pageController
        pageController.delegate = pageController.delegate

        return pageController
    }()

    private weak var pageViewController: PageController! {
        willSet {
            self._pageViewController = nil
        }
    }

    var pageController: PageController! {
        return self._pageViewController ?? self.pageViewController
    }

    public convenience init(transitionStyle: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey: Any]?) {
        self.init()
        self.transitionStyle = transitionStyle
        self.navigationOrientation = navigationOrientation
        self.options = options
    }
}

extension Pages: TemplateView {
    public var body: ViewCreator {
        Container {
            let pageViewController = self._pageViewController!
            self.pageViewController = pageViewController
            return pageViewController
        }
    }
}

public extension Pages {
    func `as`(_ ref: inout UIPageViewController!) -> Self {
        ref = self.pageController
        return self
    }
    
    func pages(direction: UIPageViewController.NavigationDirection,_ subview: Subview) -> Self {
        self.pageController.updateViewControllers(subview.views.map { view in
            ContainerController(Host {
                view
            })
        }, direction: direction, animated: false, completion: nil)
        return self
    }
}
