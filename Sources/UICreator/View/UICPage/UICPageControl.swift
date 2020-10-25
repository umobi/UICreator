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

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            self.renderManager.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            self.renderManager.frame(newValue)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.renderManager.willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.renderManager.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.renderManager.didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.renderManager.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.renderManager.traitDidChange()
    }
}

public class UICPageControl: UIViewCreator, Control {
    public typealias View = PageControl

    public init(numberOfPages: Int) {
        self.loadView { [unowned self] in
            View.init(builder: self)
        }
        .onNotRendered {
            ($0 as? View)?.numberOfPages = numberOfPages
        }
    }

    public init(numberOfPages: Relay<Int>) {
        self.loadView { [unowned self] in
            View.init(builder: self)
        }
        .onNotRendered {
            weak var view = $0 as? View
            numberOfPages.sync {
                view?.numberOfPages = $0
            }
        }
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

    func currentPage(_ value: Relay<Int>) -> Self {
        self.onNotRendered {
            weak var view = $0 as? View
            value.sync {
                view?.currentPage = $0
            }
        }
    }
}

public extension UIViewCreator where Self: Control, View: UIPageControl {
    func onPageChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onEvent(.valueChanged, handler)
    }

    func currentPage(_ value: Relay<Int>) -> Self {
        self.onNotRendered { [weak self] in
            weak var view = $0 as? View
            _ = self?.onPageChanged { _ in
                value.wrappedValue = view?.currentPage ?? .zero
            }

            value.sync {
                view?.currentPage = $0
            }
        }
    }
}
