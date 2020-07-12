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
public class DatePicker: UIDatePicker {

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

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        RenderManager(self)?.traitDidChange()
    }
}

public class UICDatePicker: UIViewCreator, Control {
    public typealias View = DatePicker

    public init(calendar: Calendar? = nil) {
        self.loadView { [unowned self] in
            let view = View.init(builder: self)
            if #available(iOS 13.4, *) {
                view.preferredDatePickerStyle = .wheels
            }
            return view
        }
        .onNotRendered {
            ($0 as? View)?.calendar = calendar ?? .current
        }
    }
}

public extension UIViewCreator where View: UIDatePicker {
    @available(iOS 13.4, *)
    func preferredStyle(_ style: UIDatePickerStyle) -> Self {
        self.onNotRendered {
            ($0 as? View)?.preferredDatePickerStyle = style
        }
    }

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

public extension UIViewCreator where Self: Control, View: UIDatePicker {
    func selectedDate(_ value: Relay<Date>) -> Self {
        self.onValueChanged {
            guard let date = ($0 as? View)?.date else {
                return
            }

            value.wrappedValue = date
        }.onInTheScene {
            weak var datePicker = $0 as? View

            value.sync {
                datePicker?.setDate($0, animated: true)
            }
        }
    }

    func selectedTime(_ value: Relay<TimeInterval>) -> Self {
        self.onValueChanged {
            guard let time = ($0 as? View)?.countDownDuration else {
                return
            }

            value.wrappedValue = time
        }.onInTheScene {
            weak var datePicker = $0 as? View

            value.sync {
                datePicker?.countDownDuration = $0
            }
        }
    }

    func maximumDate(_ value: Relay<Date?>) -> Self {
        self.onInTheScene {
            weak var view = $0 as? View
            value.sync {
                view?.maximumDate = $0
            }
        }
    }

    func minimumDate(_ value: Relay<Date?>) -> Self {
        self.onInTheScene {
            weak var view = $0 as? View
            value.sync {
                view?.minimumDate = $0
            }
        }
    }

    func maximumDate(_ value: Relay<Date>) -> Self {
        self.onInTheScene {
            weak var view = $0 as? View
            value.sync {
                view?.maximumDate = $0
            }
        }
    }

    func minimumDate(_ value: Relay<Date>) -> Self {
        self.onInTheScene {
            weak var view = $0 as? View
            value.sync {
                view?.minimumDate = $0
            }
        }
    }
}

#endif
