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
public struct UICVPageCurl: UIViewControllerCreator {
    public typealias ViewController = ViewControllers.PageViewController

    @Relay private var currentPage: Int
    private let contents: [ViewCreator]
    private let spacing: CGFloat

    public init(
        currentPage: Relay<Int>,
        spacing: CGFloat = .zero,
        @UICViewBuilder contents: @escaping () -> ViewCreator) {

        self._currentPage = currentPage
        self.spacing = spacing
        self.contents = contents().zip
    }

    @inline(__always)
    public static func makeUIViewController(_ viewCreator: ViewCreator) -> CBViewController {
        let _self = viewCreator as! Self

        let pageController = ViewControllers.PageViewController(
            transitionStyle: .pageCurl,
            navigationOrientation: .vertical,
            options: [.interPageSpacing: _self.spacing],
            viewControllers: {
                _self.contents.map {
                    UICHostingController(rootView: $0)
                }
            }(),
            onPageChanged: { _self.currentPage = $0 }
        )

        _self.$currentPage.distinctSync { [weak pageController] in
            pageController?.currentPage = $0
        }

        return pageController
    }
}
