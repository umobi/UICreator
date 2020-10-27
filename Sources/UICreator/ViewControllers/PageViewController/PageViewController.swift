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

extension ViewControllers {
    public class PageViewController: UIPageViewController {
        #if os(iOS)
        @usableFromInline
        internal var spineLocationHandler: ((UIInterfaceOrientation) -> SpineLocation)?
        #endif
        @usableFromInline
        internal var onPageChangeHandler: ((Int) -> Void)?
        @usableFromInline
        internal var isInfinityScroll: Bool = false
    }
}

private var kQueueViewControllers = 0
extension UIPageViewController {
    var queuedViewControllers: [UIViewController]! {
        get { objc_getAssociatedObject(self, &kQueueViewControllers) as? [UIViewController] }
        set { objc_setAssociatedObject(self, &kQueueViewControllers, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    public func updateViewControllers(
        _ viewControllers: [UIViewController],
        direction: UIPageViewController.NavigationDirection,
        animated flag: Bool,
        completion: ((Bool) -> Void)? = nil) {

        self.queuedViewControllers = viewControllers
        self.setViewControllers(
            [viewControllers.first].compactMap { $0 },
            direction: .forward,
            animated: flag,
            completion: completion
        )
    }

    public var currentPage: Int {
        get {
            guard let currentSlice = (self.queuedViewControllers.enumerated().compactMap { slice -> (Int, CGRect)? in
                guard let rect = slice.element.view.superview?.convert(slice.element.view.bounds, to: self.view) else {
                    return nil
                }

                return (slice.offset, self.view.frame.intersection(rect))
            }.max(by: {
                ($0.1.size.height * $0.1.size.width) <= ($1.1.size.height * $1.1.size.width)
            })) else { return 0 }

            return currentSlice.0
        }

        set {
            let currentPage = self.currentPage
            if currentPage != newValue {
                guard let toPageView = self.queuedViewControllers.enumerated().first(where: {
                    $0.offset == newValue
                }) else {
                    return
                }

                self.setViewControllers([toPageView.element], direction: {
                    if currentPage <= toPageView.offset {
                        return .forward
                    }

                    return .reverse
                }(), animated: !UIAccessibility.isReduceMotionEnabled && self.view.window != nil, completion: nil)
            }
        }
    }
}
