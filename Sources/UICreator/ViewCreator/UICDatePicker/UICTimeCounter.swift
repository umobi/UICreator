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
public struct UICTimeCounter: UIViewCreator {
    public typealias View = UIDatePicker

    @Relay var selectedTimeInterval: TimeInterval

    let timeZone: TimeZone?
    let locale: Locale?

    public init(
        selectedTimeInterval: Relay<TimeInterval>,
        timeZone: TimeZone? = nil,
        locale: Locale? = nil) {

        self._selectedTimeInterval = selectedTimeInterval
        self.timeZone = timeZone
        self.locale = locale
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        let selectedTimeInterval = _self.$selectedTimeInterval

        return Views.DatePicker()
            .onNotRendered {
                if #available(iOS 13.4, *) {
                    ($0 as? View)?.preferredDatePickerStyle = .wheels
                }

                ($0 as? View)?.datePickerMode = .countDownTimer
                ($0 as? View)?.timeZone = _self.timeZone
                ($0 as? View)?.locale = _self.locale
            }
            .onNotRendered {
                weak var view = $0 as? View

                selectedTimeInterval.distinctSync {
                    view?.countDownDuration = $0
                }
            }
            .onEvent(.valueChanged) {
                guard let time = ($0 as? View)?.countDownDuration else {
                    return
                }

                selectedTimeInterval.wrappedValue = time
            }
    }
}
#endif
