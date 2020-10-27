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

public class PageControl: UIPageControl {

    init() {
        super.init(frame: .zero)
        self.makeSelfImplemented()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

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

public struct UICPageControl: UIViewCreator {
    public typealias View = PageControl

    @Relay var numberOfPages: Int
    @Relay var currentPage: Int

    init(
        numberOfPages: Int,
        currentPage: Relay<Int>) {

        self._numberOfPages = .constant(numberOfPages)
        self._currentPage = currentPage
    }

    init(
        numberOfPages: Relay<Int>,
        currentPage: Relay<Int>) {

        self._numberOfPages = numberOfPages
        self._currentPage = currentPage
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return PageControl()
            .onNotRendered {
                weak var view = $0 as? View

                _self.$numberOfPages.sync {
                    view?.numberOfPages = $0
                }

                _self.$currentPage.distinctSync {
                    view?.currentPage = $0
                }
            }
            .onEvent(.valueChanged) {
                _self.currentPage = ($0 as? View)?.currentPage ?? .zero
            }
    }
}

public extension UIViewCreator where View: UIPageControl {

    func currentPageIndicatorTintColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.currentPageIndicatorTintColor = color
        }
    }

    func defersCurrentPageDisplay(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.defersCurrentPageDisplay = flag
        }
    }

    func hidesForSinglePage(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.hidesForSinglePage = flag
        }
    }

    func numberOfPages(_ pages: Int) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.numberOfPages = pages
        }
    }

    func pageIndicatorTintColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.pageIndicatorTintColor = color
        }
    }
}
