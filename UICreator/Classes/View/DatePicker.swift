//
//  DatePicker.swift
//  UICreator
//
//  Created by brennobemoura on 25/12/19.
//

import Foundation
import UIKit

#if os(iOS)
public class DatePicker: UIDatePicker, Control, ViewBuilder {
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

public extension ViewBuilder where Self: UIDatePicker {
    init(calendar: Calendar? = nil) {
        self.init(frame: .zero)
        self.calendar = calendar ?? .current
    }

    func date(_ date: Date) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.date = date
        }
    }

    func mode(_ mode: Self.Mode) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.datePickerMode = mode
        }
    }

    func locale(_ locale: Locale?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.locale = locale
        }
    }

    func maximumDate(_ maximumDate: Date?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.maximumDate = maximumDate
        }
    }

    func minimumDate(_ minimumDate: Date?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.minimumDate = minimumDate
        }
    }

    func countDownDuration(_ duration: TimeInterval) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.countDownDuration = duration
        }
    }

    func minuteInterval(_ interval: Int) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.minuteInterval = interval
        }
    }

    func timeZone(_ timeZone: TimeZone?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.timeZone = timeZone
        }
    }
}

public extension Control where Self: UIDatePicker & Control {
    func onValueChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onEvent(.valueChanged, handler)
    }
}

#endif
