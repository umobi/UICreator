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

extension Views.StackView {
    class Manager: SupportForEach {
        private weak var stackView: UIStackView!

        @WeakBox var firstView: UIView!
        @WeakBox var lastView: UIView!

        init(_ stackView: UIStackView) {
            self.stackView = stackView
        }

        @usableFromInline
        func viewsDidChange(_ placeholderView: UIView!, _ dynamicContent: Relay<[() -> ViewCreator]>) {
            self.firstView = placeholderView
            self.lastView = placeholderView

            dynamicContent.map {
                $0.map { $0().releaseUIView() }
            }.sync { views in
                DispatchQueue.main.async { [unowned self] in
                    guard let stackView = stackView else {
                        return
                    }

                    let startIndex = stackView.arrangedSubviews.enumerated().first(where: {
                        $0.element === firstView
                    })?.offset ?? 0

                    let endIndex = stackView.arrangedSubviews.enumerated().first(where: {
                        $0.element === lastView
                    })?.offset ?? 0

                    if firstView != nil {
                        stackView.arrangedSubviews[startIndex...endIndex].forEach {
                            $0.removeFromSuperview()
                        }
                    }

                    views.enumerated().forEach {
                        UIView.CBSubview(stackView).insertArrangedSubview(
                            $0.element,
                            at: startIndex + $0.offset
                        )
                    }

                    firstView = views.first
                    lastView = views.last
                }
            }
        }
    }
}

private var kStackManager = 0
extension Views.StackView {
    @inline(__always)
    func strongStackManager(_ stackManager: Manager) {
        objc_setAssociatedObject(self, &kStackManager, stackManager, .OBJC_ASSOCIATION_RETAIN)
    }
}
