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
public struct UICDashed: UIViewCreator {
    public typealias View = Views.DashedView

    @Relay var color: UIColor
    @Relay var width: CGFloat
    @Relay var pattern: [NSNumber]

    let content: ViewCreator

    public init(
        color: UIColor,
        width: CGFloat = 1,
        pattern: [NSNumber] = [2, 3],
        content: () -> ViewCreator) {

        self.content = content()
        self._color = .constant(color)
        self._width = .constant(width)
        self._pattern = .constant(pattern)
    }

    public init(
        color: Relay<UIColor>,
        width: Relay<CGFloat> = .constant(1),
        pattern: Relay<[NSNumber]> = .constant([2, 3]),
        content: () -> ViewCreator) {

        self.content = content()
        self._color = color
        self._width = width
        self._pattern = pattern
    }

    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return View()
            .onNotRendered {
                ($0 as? View)?.addContent(_self.content.releaseUIView())
            }
            .onNotRendered {
                weak var view = $0 as? View

                _self.$color.sync {
                    view?.apply(strokeColor: $0)
                        .refreshView()
                }
            }
            .onNotRendered {
                weak var view = $0 as? View

                _self.$pattern.sync {
                    view?.apply(dashPattern: $0)
                        .refreshView()
                }
            }
            .onNotRendered {
                weak var view = $0 as? View

                _self.$width.sync {
                    view?.apply(lineWidth: $0)
                        .refreshView()
                }
            }
    }
}
