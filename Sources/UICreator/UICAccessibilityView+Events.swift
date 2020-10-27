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

public extension UICAccessibilityView {
    // swiftlint:disable discarded_notification_center_observer
    @inline(__always) @usableFromInline
    internal func notification(
        _ name: NSNotification.Name,
        _ handler: @escaping (Notification, UIView) -> Void) -> UICAccessibilityView<View> {
        self.onNotRendered {
            weak var view = $0

            $0.notificationObservable.append(
                NotificationCenter.default.addObserver(
                    forName: name,
                    object: nil,
                    queue: nil,
                    using: {
                        guard let view = view else {
                            return
                        }

                        handler($0, view)
                    }
                )
            )
        }
        .makeAccessibility()
    }

    @inline(__always) @usableFromInline
    internal func notification(
        _ notificationName: NSNotification.Name,
        _ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(notificationName) { _, view in
            handler(view)
        }
    }

    @available(iOS 11.0, tvOS 11, *) @inlinable
    func onVoiceOverChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.voiceOverStatusDidChangeNotification,
            handler
        )
    }

    @inlinable
    func onElementFocusedChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        var isFocused = false

        return self.notification(UIAccessibility.elementFocusedNotification) { notification, view in
            if let focused = notification
                .userInfo?[UIAccessibility.focusedElementUserInfoKey] as? View,
                focused === view {
                isFocused = true
                handler(view)
                return
            }

            if isFocused && !view.accessibilityElementIsFocused() {
                isFocused = false
                handler(view)
            }
        }
    }

    @inlinable
    func onBoldTextChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.boldTextStatusDidChangeNotification,
            handler
        )
    }

    @inlinable
    func onMonoAudioChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.monoAudioStatusDidChangeNotification,
            handler
        )
    }

    @inlinable
    func onClosedCaptionChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.closedCaptioningStatusDidChangeNotification,
            handler
        )
    }

    @inlinable @available(*, deprecated, message: "Use Property(\\.accessibilityInvertColors)")
    func onInvertColorsChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.invertColorsStatusDidChangeNotification,
            handler
        )
    }

    @inlinable
    func onGuidedAccessChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.guidedAccessStatusDidChangeNotification,
            handler
        )
    }

    @inlinable @available(*, deprecated, message: "Use Property(\\.accessibilityGrayscaleEnabled)")
    func onGrayScaleChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.grayscaleStatusDidChangeNotification,
            handler
        )
    }

    @inlinable @available(*, deprecated, message: "Use Property(\\.accessibilityReduceTransparency)")
    func onReduceTransparencyChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.reduceTransparencyStatusDidChangeNotification,
            handler
        )
    }

    @inlinable @available(*, deprecated, message: "Use Property(\\.accessibilityReduceMotion)")
    func onReduceMotionChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.reduceMotionStatusDidChangeNotification,
            handler
        )
    }

    @inlinable @available(iOS 13.0, tvOS 13.0, *)
    func onViewAutoplayChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.videoAutoplayStatusDidChangeNotification,
            handler
        )
    }

    @inlinable @available(iOS 13.0, tvOS 13.0, *)
    func onDarkerSystemColorsChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.darkerSystemColorsStatusDidChangeNotification,
            handler
        )
    }

    @inlinable
    func onSwitchControlChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.switchControlStatusDidChangeNotification,
            handler
        )
    }

    @inlinable
    func onSpeakSelectionChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.speakSelectionStatusDidChangeNotification,
            handler
        )
    }

    @inlinable
    func onSpeakScreenChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.speakScreenStatusDidChangeNotification,
            handler
        )
    }

    @inlinable
    func onShakeToUndoChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.shakeToUndoDidChangeNotification,
            handler
        )
    }

    @inlinable
    func onAssistiveTouchChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.assistiveTouchStatusDidChangeNotification,
            handler
        )
    }

    @inlinable @available(iOS 13.0, tvOS 13.0, *)
    func onDifferentiateWithoutColorsChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            NSNotification.Name(rawValue: UIAccessibility.differentiateWithoutColorDidChangeNotification),
            handler
        )
    }

    @inlinable @available(iOS 13.0, tvOS 13.0, *)
    func onOnOffSwitchLabelsChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.onOffSwitchLabelsDidChangeNotification,
            handler
        )
    }

    #if os(iOS)
    @inlinable
    func onHearingDevicePairedEarChanged(_ handler: @escaping (UIView) -> Void) -> UICAccessibilityView<View> {
        self.notification(
            UIAccessibility.hearingDevicePairedEarDidChangeNotification,
            handler
        )
    }
    #endif
}
