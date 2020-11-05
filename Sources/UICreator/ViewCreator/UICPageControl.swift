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

@frozen
public struct UICPageControl: UIViewCreator {
    public typealias View = UIPageControl

    @Relay private var numberOfPages: Int
    @Relay private var currentPage: Int

    public init(
        numberOfPages: Int,
        currentPage: Relay<Int>) {

        self._numberOfPages = .constant(numberOfPages)
        self._currentPage = currentPage
    }

    public init(
        numberOfPages: Relay<Int>,
        currentPage: Relay<Int>) {

        self._numberOfPages = numberOfPages
        self._currentPage = currentPage
    }

    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        let numberOfPages = _self.$numberOfPages
        let currentPage = _self.$currentPage

        return Views.PageControl()
            .onNotRendered {
                weak var view = $0 as? View

                numberOfPages.sync {
                    view?.numberOfPages = $0
                }

                currentPage.distinctSync {
                    view?.currentPage = $0
                }
            }
            .onEvent(.valueChanged) {
                currentPage.wrappedValue = ($0 as? View)?.currentPage ?? .zero
            }
    }
}

public extension UIViewCreator where View: UIPageControl {

    @inlinable
    func currentPageIndicatorTintColor(_ color: UIColor?) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.currentPageIndicatorTintColor = color
        }
    }

    @inlinable
    func defersCurrentPageDisplay(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.defersCurrentPageDisplay = flag
        }
    }

    @inlinable
    func hidesForSinglePage(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.hidesForSinglePage = flag
        }
    }

    @inlinable
    func numberOfPages(_ pages: Int) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.numberOfPages = pages
        }
    }

    @inlinable
    func pageIndicatorTintColor(_ color: UIColor?) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.pageIndicatorTintColor = color
        }
    }
}
