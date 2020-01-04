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

public struct UIAccessibilityCreator<UICreator: UIViewCreator> {
    public typealias View = UICreator.View

    public weak var uiView: View!

    init(_ view: UIView) {
        self.uiView = view as? View
    }

    init(_ creator: ViewCreator) {
        self.init(creator.uiView)
    }
}

public extension UIAccessibilityCreator where View: UIView {
    @available(iOS 11.0, tvOS 11.0, *)
    func ignoresInvertColors(_ flag: Bool) -> Self {
        self.uiView.accessibilityIgnoresInvertColors = flag
        return self
    }

    func traits(_ traits: Set<UIAccessibilityTraits>) -> Self {
        self.uiView.accessibilityTraits = .init(traits)
        return self
    }

    func isEnabled(_ flag: Bool) -> Self {
        self.uiView.isAccessibilityElement = flag
        return self
    }

    func identifier(_ string: String) -> Self {
        self.uiView.accessibilityIdentifier = string
        return self
    }

    func label(_ string: String) -> Self {
        self.uiView.accessibilityLabel = string
        return self
    }

    func value(_ string: String) -> Self {
        self.uiView.accessibilityValue = string
        return self
    }

    func frame(_ frame: CGRect) -> Self {
        self.uiView.accessibilityFrame = frame
        return self
    }

    func hint(_ string: String) -> Self {
        self.uiView.accessibilityHint = string
        return self
    }

    func groupAccessibilityChildren(_ flag: Bool) -> Self {
        self.uiView.shouldGroupAccessibilityChildren = flag
        return self
    }

    @available(iOS 11.0, tvOS 11.0, *)
    func containerType(_ type: UIAccessibilityContainerType) -> Self {
        self.uiView.accessibilityContainerType = type
        return self
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func respondsToUserInteraction(_ flag: Bool) -> Self {
        self.uiView.accessibilityRespondsToUserInteraction = flag
        return self
    }

    func path(_ path: UIBezierPath?) -> Self {
        self.uiView.accessibilityPath = path
        return self
    }

    func language(_ string: String?) -> Self {
        self.uiView.accessibilityLanguage = string
        return self
    }

    func isModal(_ flag: Bool) -> Self {
        self.uiView.accessibilityViewIsModal = flag
        return self
    }

    func customRotors(_ rotors: [UIAccessibilityCustomRotor]) -> Self {
        self.uiView.accessibilityCustomRotors = rotors
        return self
    }

    func customActions(_ actions: [UIAccessibilityCustomAction]) -> Self {
        self.uiView.accessibilityCustomActions = actions
        return self
    }

    @available(iOS 11.0, tvOS 11, *)
    func attributedHint(_ attributedString: NSAttributedString) -> Self {
        self.uiView.accessibilityAttributedHint = attributedString
        return self
    }

    func elementsHidden(_ flag: Bool) -> Self {
        self.uiView.accessibilityElementsHidden = flag
        return self
    }

    func activationPoint(_ point: CGPoint) -> Self {
        self.uiView.accessibilityActivationPoint = point
        return self
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func textualContext(_ context: UIAccessibilityTextualContext) -> Self {
        self.uiView.accessibilityTextualContext = context
        return self
    }

    @available(iOS 11.0, tvOS 11, *)
    func attributedLabel(_ attributedString: NSAttributedString) -> Self {
        self.uiView.accessibilityAttributedLabel = attributedString
        return self
    }

    @available(iOS 11.0, tvOS 11, *)
    func attributedValue(_ attributedString: NSAttributedString) -> Self {
        self.uiView.accessibilityAttributedValue = attributedString
        return self
    }

    func navigationStyle(_ style: UIAccessibilityNavigationStyle) -> Self {
        self.uiView.accessibilityNavigationStyle = style
        return self
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func userInputLabels(_ labels: [String]) -> Self {
        self.uiView.accessibilityUserInputLabels = labels
        return self
    }

    #if os(iOS)
    @available(iOS 11.0, *)
    func dropPointDescriptors(_ points: [UIAccessibilityLocationDescriptor]) -> Self {
        self.uiView.accessibilityDropPointDescriptors = points
        return self
    }

    @available(iOS 11.0, *)
    func dragSourceDescriptors(_ points: [UIAccessibilityLocationDescriptor]) -> Self {
        self.uiView.accessibilityDragSourceDescriptors = points
        return self
    }
    #endif

    @available(iOS 13.0, tvOS 13.0, *)
    func attributedUserInputLabels(_ labels: [NSAttributedString]) -> Self {
        self.uiView.accessibilityAttributedUserInputLabels = labels
        return self
    }
}

public extension UIAccessibilityCreator where View: UIView {
    private func onNotification(_ name: NSNotification.Name, handler: @escaping (Notification) -> Void) -> Self {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) {
            handler($0)
        }

        return self
    }

    @available(iOS 11.0, tvOS 11, *)
    func onVoiceOverChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.voiceOverStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    func onElementFocusedChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        var isFocused = false

        return self.onNotification(UIAccessibility.elementFocusedNotification) { notification in
            if let focused = notification.userInfo?[UIAccessibility.focusedElementUserInfoKey] as? View, focused === self.uiView {
                isFocused = true
                handler(self.uiView)
                return
            }

            if isFocused && !self.uiView.accessibilityElementIsFocused() {
                isFocused = false
                handler(self.uiView)
            }
        }
    }

    func onBoldTextChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.boldTextStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    func onMonoAudioChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.monoAudioStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    func onClosedCaptionChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.closedCaptioningStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    func onInvertColorsChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.invertColorsStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    func onGuidedAccessChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.guidedAccessStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    func onGrayScaleChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.grayscaleStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    func onReduceTransparencyChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.reduceTransparencyStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    func onReduceMotionChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.reduceMotionStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func onViewAutoplayChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.videoAutoplayStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func onDarkerSystemColorsChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.darkerSystemColorsStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    func onSwitchControlChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.switchControlStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    func onSpeakSelectionChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.speakSelectionStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    func onSpeakScreenChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.speakScreenStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    func onShakeToUndoChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.shakeToUndoDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    func onAssistiveTouchChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.assistiveTouchStatusDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func onDifferentiateWithoutColorsChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(NSNotification.Name(rawValue: UIAccessibility.differentiateWithoutColorDidChangeNotification)) { _ in
            handler(self.uiView)
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func onOnOffSwitchLabelsChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.onOffSwitchLabelsDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }

    #if os(iOS)
    func onHearingDevicePairedEarChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onNotification(UIAccessibility.hearingDevicePairedEarDidChangeNotification) { _ in
            handler(self.uiView)
        }
    }
    #endif
}
