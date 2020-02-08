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
public class _DatePicker: UIDatePicker {
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self).willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self).didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self).didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self).layoutSubviews()
    }
}

public class UICDatePicker: UIViewCreator, Control {
    public typealias View = _DatePicker

    public init(calendar: Calendar? = nil) {
        self.uiView = View.init(builder: self)
        (self.uiView as? View)?.calendar = calendar ?? .current
    }
}

public extension UIViewCreator where View: UIDatePicker {

    func date(_ date: Date) -> Self {
        self.onInTheScene {
            ($0 as? View)?.date = date
        }
    }

    func mode(_ mode: UIDatePicker.Mode) -> Self {
        self.onNotRendered {
            ($0 as? View)?.datePickerMode = mode
        }
    }

    func locale(_ locale: Locale?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.locale = locale
        }
    }

    func maximumDate(_ maximumDate: Date?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.maximumDate = maximumDate
        }
    }

    func minimumDate(_ minimumDate: Date?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.minimumDate = minimumDate
        }
    }

    func countDownDuration(_ duration: TimeInterval) -> Self {
        self.onNotRendered {
            ($0 as? View)?.countDownDuration = duration
        }
    }

    func minuteInterval(_ interval: Int) -> Self {
        self.onNotRendered {
            ($0 as? View)?.minuteInterval = interval
        }
    }

    func timeZone(_ timeZone: TimeZone?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.timeZone = timeZone
        }
    }
}

public extension UIViewCreator where Self: Control, View: UIDatePicker {
    func onValueChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onEvent(.valueChanged, handler)
    }
}

#endif
