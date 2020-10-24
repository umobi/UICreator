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

public extension UIAccessibilityCreator where View: UIView {
    private func notification(
        _ name: NSNotification.Name,
        _ handler: @escaping (Notification, UIView) -> Void
    ) -> Self {
        // swiftlint:disable discarded_notification_center_observer
        self.modify {
            $0.onNotRendered {
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
        }

    }

    func notification(
        _ notificationName: NSNotification.Name,
        _ handler: @escaping (UIView) -> Void
    ) -> Self {
        self.notification(notificationName) { _, view in
            handler(view)
        }
    }

    @available(iOS 11.0, tvOS 11, *)
    func onVoiceOverChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.voiceOverStatusDidChangeNotification,
            handler
        )
    }

    func onElementFocusedChanged(_ handler: @escaping (UIView) -> Void) -> Self {
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

    func onBoldTextChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.boldTextStatusDidChangeNotification,
            handler
        )
    }

    func onMonoAudioChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.monoAudioStatusDidChangeNotification,
            handler
        )
    }

    func onClosedCaptionChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.closedCaptioningStatusDidChangeNotification,
            handler
        )
    }

    @available(*, deprecated, message: "Use Property(\\.accessibilityInvertColors)")
    func onInvertColorsChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.invertColorsStatusDidChangeNotification,
            handler
        )
    }

    func onGuidedAccessChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.guidedAccessStatusDidChangeNotification,
            handler
        )
    }

    @available(*, deprecated, message: "Use Property(\\.accessibilityGrayscaleEnabled)")
    func onGrayScaleChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.grayscaleStatusDidChangeNotification,
            handler
        )
    }

    @available(*, deprecated, message: "Use Property(\\.accessibilityReduceTransparency)")
    func onReduceTransparencyChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.reduceTransparencyStatusDidChangeNotification,
            handler
        )
    }

    @available(*, deprecated, message: "Use Property(\\.accessibilityReduceMotion)")
    func onReduceMotionChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.reduceMotionStatusDidChangeNotification,
            handler
        )
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func onViewAutoplayChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.videoAutoplayStatusDidChangeNotification,
            handler
        )
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func onDarkerSystemColorsChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.darkerSystemColorsStatusDidChangeNotification,
            handler
        )
    }

    func onSwitchControlChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.switchControlStatusDidChangeNotification,
            handler
        )
    }

    func onSpeakSelectionChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.speakSelectionStatusDidChangeNotification,
            handler
        )
    }

    func onSpeakScreenChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.speakScreenStatusDidChangeNotification,
            handler
        )
    }

    func onShakeToUndoChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.shakeToUndoDidChangeNotification,
            handler
        )
    }

    func onAssistiveTouchChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.assistiveTouchStatusDidChangeNotification,
            handler
        )
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func onDifferentiateWithoutColorsChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            NSNotification.Name(rawValue: UIAccessibility.differentiateWithoutColorDidChangeNotification),
            handler
        )
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func onOnOffSwitchLabelsChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.onOffSwitchLabelsDidChangeNotification,
            handler
        )
    }

    #if os(iOS)
    func onHearingDevicePairedEarChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notification(
            UIAccessibility.hearingDevicePairedEarDidChangeNotification,
            handler
        )
    }
    #endif
}
