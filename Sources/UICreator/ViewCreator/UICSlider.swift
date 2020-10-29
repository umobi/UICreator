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

#if os(iOS)
@frozen
public struct UICSlider: UIViewCreator {
    public typealias View = UISlider

    @Relay private var minimumValue: Double
    @Relay private var maximumValue: Double
    @Relay private var value: Double

    public init(minimumValue: Double, maximumValue: Double, value: Relay<Double>) {
        self._minimumValue = .constant(minimumValue)
        self._maximumValue = .constant(maximumValue)
        self._value = value
    }

    public init(minimumValue: Relay<Double>, maximumValue: Relay<Double>, value: Relay<Double>) {
        self._minimumValue = minimumValue
        self._maximumValue = maximumValue
        self._value = value
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return View()
            .onNotRendered {
                weak var view = $0 as? View

                _self.$minimumValue.sync {
                    view?.minimumValue = Float($0)
                }
            }
            .onNotRendered {
                weak var view = $0 as? View

                _self.$maximumValue.sync {
                    view?.maximumValue = Float($0)
                }
            }
            .onNotRendered {
                weak var view = $0 as? View

                _self.$value.distinctSync {
                    view?.value = Float($0)
                }
            }
            .onEvent(.valueChanged) {
                _self.value = Double(($0 as! View).value)
            }
    }
}

public extension UIViewCreator where View: UISlider {

    @inlinable
    func isContinuous(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.isContinuous = flag
        }
    }

    @inlinable
    func maximumTrackTintColor(_ tintColor: UIColor) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.maximumTrackTintColor = tintColor
        }
    }

    @inlinable
    func minimumTrackTintColor(_ tintColor: UIColor) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.minimumTrackTintColor = tintColor
        }
    }

    @inlinable
    func maximumValueImage(_ image: UICImage?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.maximumValueImage = image?.uiImage
        }
    }

    @inlinable
    func minimumValueImage(_ image: UICImage?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.minimumValueImage = image?.uiImage
        }
    }

    @inlinable
    func maximumTrackImage(_ image: UICImage?, for state: UIControl.State = .normal) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.setMaximumTrackImage(image?.uiImage, for: state)
        }
    }

    @inlinable
    func minimumTrackImage(_ image: UICImage?, for state: UIControl.State = .normal) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.setMinimumTrackImage(image?.uiImage, for: state)
        }
    }

    @inlinable
    func thumbImage(_ image: UICImage?, for state: UIControl.State = .normal) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.setThumbImage(image?.uiImage, for: state)
        }
    }

    @inlinable
    func thumbTintColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.thumbTintColor = color
        }
    }
}

#endif
