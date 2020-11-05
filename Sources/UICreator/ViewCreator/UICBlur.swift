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
public struct UICBlur: UIViewCreator {
    public typealias View = Views.BlurView

    @Relay private var style: UIBlurEffect.Style

    public init(_ style: UIBlurEffect.Style) {
        self._style = .constant(style)
    }

    public init(_ dynamicStyle: Relay<UIBlurEffect.Style>) {
        self._style = dynamicStyle
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        let style = _self.$style

        return View()
            .onNotRendered {
                weak var view = $0 as? View

                style.sync {
                    view?.apply(blurEffect: $0)
                }
            }
    }
}

public extension UIViewCreator where View: UICBlur.View {
    @inlinable
    func blurStyle(_ style: UIBlurEffect.Style) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.apply(blurEffect: style)
        }
    }

    @inlinable
    func blurStyle(_ dynamicStyle: Relay<UIBlurEffect.Style>) -> UICRenderedModifier<View> {
        self.onRendered {
            weak var view = $0 as? View

            dynamicStyle.sync {
                view?.apply(blurEffect: $0)
            }
        }
    }
}

#if os(iOS)
@available(iOS 13, *)
public extension UIViewCreator where View: UICBlur.View {
    @inlinable
    func vibrancyEffect(_ effect: UIVibrancyEffectStyle) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.apply(vibrancyEffect: effect)
        }
    }

    @inlinable
    func vibrancyEffect(_ dynamicEffect: Relay<UIVibrancyEffectStyle>) -> UICRenderedModifier<View> {
        self.onRendered {
            weak var view = $0 as? View

            dynamicEffect.sync {
                view?.apply(vibrancyEffect: $0)
            }
        }
    }
}
#endif
