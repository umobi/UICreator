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
public struct UICDatePicker: UIViewCreator {
    public typealias View = UIDatePicker

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

    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        let minimumDate = _self.$minimumDate
        let maximumDate = _self.$maximumDate
        let selectedDate = _self.$selectedDate

        return Views.DatePicker()
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

                minimumDate.sync {
                    view?.minimumDate = $0
                }

                maximumDate.sync {
                    view?.maximumDate = $0
                }

                selectedDate.distinctSync {
                    guard let date = $0 else {
                        return
                    }

                    view?.setDate(date, animated: true)
                }
            }
            .onEvent(.valueChanged) {
                selectedDate.wrappedValue = ($0 as? View)?.date
            }
    }
}

public extension UIViewCreator where View: UIDatePicker {

    @available(iOS 13.4, *)
    @inlinable
    func preferredStyle(_ style: UIDatePickerStyle) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.preferredDatePickerStyle = style
        }
    }

    @inlinable
    func countDownDuration(_ duration: TimeInterval) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.countDownDuration = duration
        }
    }

    @inlinable
    func minuteInterval(_ interval: Int) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.minuteInterval = interval
        }
    }
}

#endif
