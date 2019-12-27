//
//  DatePicker.swift
//  UICreator
//
//  Created by brennobemoura on 25/12/19.
//

import Foundation
import UIKit

#if os(iOS)
public class _DatePicker: UIDatePicker {
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.commitNotRendered()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }
}

public class DatePicker: UIViewCreator, Control {
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
