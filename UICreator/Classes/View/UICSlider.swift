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

#if os(iOS)
public class _Slider: UISlider {

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            RenderManager(self)?.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            RenderManager(self)?.frame(newValue)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self)?.willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self)?.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self)?.didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self)?.layoutSubviews()
    }
}

public class UICSlider: UIViewCreator, Control {
    public typealias View = _Slider

    public init() {
        self.loadView { [unowned self] in
            View.init(builder: self)
        }
    }
}

public extension UIViewCreator where View: UISlider {
    func maximumValue(_ value: Float) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.maximumValue = value
        }
    }

    func minimumValue(_ value: Float) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.minimumValue = value
        }
    }

    func isContinuous(_ flag: Bool) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.isContinuous = flag
        }
    }

    func maximumTrackTintColor(_ tintColor: UIColor) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.maximumTrackTintColor = tintColor
        }
    }

    func minimumTrackTintColor(_ tintColor: UIColor) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.minimumTrackTintColor = tintColor
        }
    }

    func maximumValueImage(_ image: UIImage?) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.maximumValueImage = image
        }
    }

    func minimumValueImage(_ image: UIImage?) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.minimumValueImage = image
        }
    }

    func maximumTrackImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.onRendered {
            ($0 as? View)?.setMaximumTrackImage(image, for: state)
        }
    }

    func minimumTrackImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.onRendered {
            ($0 as? View)?.setMinimumTrackImage(image, for: state)
        }
    }

    func thumbImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.onRendered {
            ($0 as? View)?.setThumbImage(image, for: state)
        }
    }

    func thumbTintColor(_ color: UIColor?) -> Self {
        self.onRendered {
            ($0 as? View)?.thumbTintColor = color
        }
    }

    func value(_ value: Float) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.value = value
        }
    }
}

public extension UIViewCreator where Self: Control, View: UISlider {
    func onValueChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onEvent(.valueChanged, handler)
    }
}
#endif
