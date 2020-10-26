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
public class Slider: UISlider {

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

public struct UICSlider: UIViewCreator {
    public typealias View = Slider

    @Relay var minimumValue: Double
    @Relay var maximumValue: Double
    @Relay var value: Double

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

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
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

    func isContinuous(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.isContinuous = flag
        }
    }

    func maximumTrackTintColor(_ tintColor: UIColor) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.maximumTrackTintColor = tintColor
        }
    }

    func minimumTrackTintColor(_ tintColor: UIColor) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.minimumTrackTintColor = tintColor
        }
    }

    func maximumValueImage(_ image: UICImage?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.maximumValueImage = image?.uiImage
        }
    }

    func minimumValueImage(_ image: UICImage?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.minimumValueImage = image?.uiImage
        }
    }

    func maximumTrackImage(_ image: UICImage?, for state: UIControl.State = .normal) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.setMaximumTrackImage(image?.uiImage, for: state)
        }
    }

    func minimumTrackImage(_ image: UICImage?, for state: UIControl.State = .normal) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.setMinimumTrackImage(image?.uiImage, for: state)
        }
    }

    func thumbImage(_ image: UICImage?, for state: UIControl.State = .normal) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.setThumbImage(image?.uiImage, for: state)
        }
    }

    func thumbTintColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.thumbTintColor = color
        }
    }
}

#endif
