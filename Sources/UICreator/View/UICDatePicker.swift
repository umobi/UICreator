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
public class DatePicker: UIDatePicker {

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

public struct UICDatePicker: UIViewCreator {
    public typealias View = DatePicker

    @Relay var minimumDate: Date?
    @Relay var maximumDate: Date?
    @Relay var selectedDate: Date?

    let calendar: Calendar?
    let pickerMode: UICDatePicker.Mode
    let timeZone: TimeZone?
    let locale: Locale?

    public init(
        _ pickerMode: UICDatePicker.Mode = .date,
        minimumDate: Relay<Date?>,
        maximumDate: Relay<Date?>,
        selectedDate: Relay<Date?>,
        calendar: Calendar? = nil,
        timeZone: TimeZone? = nil,
        locale: Locale? = nil) {

        self._minimumDate = minimumDate
        self._maximumDate = maximumDate
        self._selectedDate = selectedDate
        self.calendar = calendar
        self.pickerMode = pickerMode
        self.timeZone = timeZone
        self.locale = locale
    }

    public init(
        _ pickerMode: UICDatePicker.Mode = .date,
        minimumDate: Date? = nil,
        maximumDate: Date? = nil,
        selectedDate: Relay<Date?>,
        calendar: Calendar? = nil,
        timeZone: TimeZone? = nil,
        locale: Locale? = nil) {

        self._minimumDate = .constant(minimumDate)
        self._maximumDate = .constant(maximumDate)
        self._selectedDate = selectedDate
        self.calendar = calendar
        self.pickerMode = pickerMode
        self.timeZone = timeZone
        self.locale = locale
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return DatePicker()
            .onNotRendered {
                if #available(iOS 13.4, *) {
                    ($0 as? View)?.preferredDatePickerStyle = .wheels
                }

                ($0 as? View)?.calendar = _self.calendar
                ($0 as? View)?.datePickerMode = _self.pickerMode.uiPickerMode
                ($0 as? View)?.timeZone = _self.timeZone
                ($0 as? View)?.locale = _self.locale
            }
            .onNotRendered {
                weak var view = $0 as? View

                _self.$minimumDate.sync {
                    view?.minimumDate = $0
                }

                _self.$maximumDate.sync {
                    view?.maximumDate = $0
                }

                _self.$maximumDate.distinctSync {
                    guard let date = $0 else {
                        return
                    }

                    view?.setDate(date, animated: true)
                }
            }
            .onEvent(.valueChanged) {
                _self.selectedDate = ($0 as? View)?.date
            }
    }
}

public extension UICDatePicker {
    enum Mode {
        case date
        case dateAndTime
        case time

        internal var uiPickerMode: UIDatePicker.Mode {
            switch self {
            case .date:
                return .date
            case .dateAndTime:
                return .dateAndTime
            case .time:
                return .time
            }
        }
    }
}

public extension UIViewCreator where View: UIDatePicker {
    @available(iOS 13.4, *)
    func preferredStyle(_ style: UIDatePickerStyle) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.preferredDatePickerStyle = style
        }
    }

    func countDownDuration(_ duration: TimeInterval) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.countDownDuration = duration
        }
    }

    func minuteInterval(_ interval: Int) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.minuteInterval = interval
        }
    }
}

#endif
