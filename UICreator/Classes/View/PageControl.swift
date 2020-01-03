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

public class PageControl: UIPageControl {
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.commitNotRendered()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }
}

public class Page: UIViewCreator, Control {
    public typealias View = PageControl

    public init(numberOfPages: Int) {
        self.uiView = View.init(builder: self)
        (self.uiView as? View)?.numberOfPages = numberOfPages
    }
}

public extension UIViewCreator where View: UIPageControl {
    func currentPage(_ page: Int) -> Self {
        self.onInTheScene {
            ($0 as? View)?.currentPage = page
        }
    }

    func currentPage(indicatorTintColor: UIColor?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.currentPageIndicatorTintColor = indicatorTintColor
        }
    }

    func defersCurrentPageDisplay(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.defersCurrentPageDisplay = flag
        }
    }

    func hidesForSinglePage(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.hidesForSinglePage = flag
        }
    }

    func numberOfPages(_ pages: Int) -> Self {
        self.onNotRendered {
            ($0 as? View)?.numberOfPages = pages
        }
    }

    func page(indicatorTintColor: UIColor?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.pageIndicatorTintColor = indicatorTintColor
        }
    }
}
