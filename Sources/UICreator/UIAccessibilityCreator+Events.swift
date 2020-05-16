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
    private func onNotification(
        _ name: NSNotification.Name,
        handler: @escaping (Notification) -> Void) -> Self {
        // swiftlint:disable discarded_notification_center_observer
        NotificationCenter.default.addObserver(
            forName: name,
            object: nil,
            queue: nil) {
                handler($0)
        }
        return self
    }

    @available(iOS 11.0, tvOS 11, *)
    func onVoiceOverChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.voiceOverStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    func onElementFocusedChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        var isFocused = false

        return self.onNotification(UIAccessibility.elementFocusedNotification) { notification in
            self.manager.onNotRendered {
                if let focused = notification
                    .userInfo?[UIAccessibility.focusedElementUserInfoKey] as? View,
                    focused === $0 {
                    isFocused = true
                    handler($0)
                    return
                }

                if isFocused && !$0.accessibilityElementIsFocused() {
                    isFocused = false
                    handler($0)
                }
            }
        }
    }

    func onBoldTextChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.boldTextStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    func onMonoAudioChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.monoAudioStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    func onClosedCaptionChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.closedCaptioningStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    func onInvertColorsChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.invertColorsStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    func onGuidedAccessChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.guidedAccessStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    func onGrayScaleChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.grayscaleStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    func onReduceTransparencyChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.reduceTransparencyStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    func onReduceMotionChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.reduceMotionStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func onViewAutoplayChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.videoAutoplayStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func onDarkerSystemColorsChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.darkerSystemColorsStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    func onSwitchControlChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.switchControlStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    func onSpeakSelectionChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.speakSelectionStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    func onSpeakScreenChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.speakScreenStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    func onShakeToUndoChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.shakeToUndoDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    func onAssistiveTouchChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.assistiveTouchStatusDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func onDifferentiateWithoutColorsChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(NSNotification.Name(rawValue:
            UIAccessibility.differentiateWithoutColorDidChangeNotification
        )) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func onOnOffSwitchLabelsChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.onOffSwitchLabelsDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }

    #if os(iOS)
    func onHearingDevicePairedEarChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.hearingDevicePairedEarDidChangeNotification) { _ in
            self.manager.onNotRendered {
                handler($0)
            }
        }
    }
    #endif
}
