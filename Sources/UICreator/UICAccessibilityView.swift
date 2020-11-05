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

@frozen
public struct UICAccessibilityView<View>: UIViewCreator where View: CBView {
    private let content: ViewCreator

    @usableFromInline
    init<Content>(_ content: Content) where Content: UIViewCreator, Content.View == View {
        self.content = content
    }

    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        (viewCreator as! Self).content.releaseUIView()
    }
}

public extension UICAccessibilityView {
    @available(iOS 11.0, tvOS 11.0, *) @inlinable
    func ignoresInvertColors(_ flag: Bool) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityIgnoresInvertColors = flag
        }
        .makeAccessibility()
    }

    @inlinable
    func traits(_ traits: Set<UIAccessibilityTraits>) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityTraits = .init(traits)
        }
        .makeAccessibility()
    }

    func isEnabled(_ flag: Bool) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.isAccessibilityElement = flag
        }
        .makeAccessibility()
    }

    func identifier(_ string: String) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityIdentifier = string
        }
        .makeAccessibility()
    }

    func label(_ string: String) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityLabel = string
        }
        .makeAccessibility()
    }

    func value(_ string: String) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityValue = string
        }
        .makeAccessibility()
    }

    func frame(_ frame: CGRect) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityFrame = frame
        }
        .makeAccessibility()
    }

    func hint(_ string: String) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityHint = string
        }
        .makeAccessibility()
    }

    func groupAccessibilityChildren(_ flag: Bool) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.shouldGroupAccessibilityChildren = flag
        }
        .makeAccessibility()
    }

    @available(iOS 11.0, tvOS 11.0, *)
    func containerType(_ type: UIAccessibilityContainerType) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityContainerType = type
        }
        .makeAccessibility()
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func respondsToUserInteraction(_ flag: Bool) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityRespondsToUserInteraction = flag
        }
        .makeAccessibility()
    }

    func path(_ path: UIBezierPath?) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityPath = path
        }
        .makeAccessibility()
    }

    func language(_ string: String?) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityLanguage = string
        }
        .makeAccessibility()
    }

    func isModal(_ flag: Bool) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityViewIsModal = flag
        }
        .makeAccessibility()
    }

    func customRotors(_ rotors: [UIAccessibilityCustomRotor]) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityCustomRotors = rotors
        }
        .makeAccessibility()
    }

    func customActions(_ actions: [UIAccessibilityCustomAction]) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityCustomActions = actions
        }
        .makeAccessibility()
    }

    @available(iOS 11.0, tvOS 11, *)
    func attributedHint(_ attributedString: NSAttributedString) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityAttributedHint = attributedString
        }
        .makeAccessibility()
    }

    func elementsHidden(_ flag: Bool) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityElementsHidden = flag
        }
        .makeAccessibility()
    }

    func activationPoint(_ point: CGPoint) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityActivationPoint = point
        }
        .makeAccessibility()
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func textualContext(_ context: UIAccessibilityTextualContext) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityTextualContext = context
        }
        .makeAccessibility()
    }

    @available(iOS 11.0, tvOS 11, *)
    func attributedLabel(_ attributedString: NSAttributedString) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityAttributedLabel = attributedString
        }
        .makeAccessibility()
    }

    @available(iOS 11.0, tvOS 11, *)
    func attributedValue(_ attributedString: NSAttributedString) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityAttributedValue = attributedString
        }
        .makeAccessibility()
    }

    func navigationStyle(_ style: UIAccessibilityNavigationStyle) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityNavigationStyle = style
        }
        .makeAccessibility()
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func userInputLabels(_ labels: [String]) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityUserInputLabels = labels
        }
        .makeAccessibility()
    }

    #if os(iOS)
    @available(iOS 11.0, *)
    func dropPointDescriptors(_ points: [UIAccessibilityLocationDescriptor]) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityDropPointDescriptors = points
        }
        .makeAccessibility()
    }

    @available(iOS 11.0, *)
    func dragSourceDescriptors(_ points: [UIAccessibilityLocationDescriptor]) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityDragSourceDescriptors = points
        }
        .makeAccessibility()
    }
    #endif

    @available(iOS 13.0, tvOS 13.0, *)
    func attributedUserInputLabels(_ labels: [NSAttributedString]) -> UICAccessibilityView<View> {
        self.onNotRendered {
            $0.accessibilityAttributedUserInputLabels = labels
        }
        .makeAccessibility()
    }
}
