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

public struct UIAccessibilityCreator<UICreator: UIViewCreator> {
    public typealias View = UICreator.View

    private(set) weak var manager: ViewCreator!

    init(_ manager: ViewCreator) {
        self.manager = manager
    }
}

public extension UIAccessibilityCreator where View: UIView {
    @available(iOS 11.0, tvOS 11.0, *)
    func ignoresInvertColors(_ flag: Bool) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityIgnoresInvertColors = flag
        }
        return self
    }

    func traits(_ traits: Set<UIAccessibilityTraits>) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityTraits = .init(traits)
        }
        return self
    }

    func isEnabled(_ flag: Bool) -> Self {
        self.manager.onNotRendered {
            $0.isAccessibilityElement = flag
        }
        return self
    }

    func identifier(_ string: String) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityIdentifier = string
        }
        return self
    }

    func label(_ string: String) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityLabel = string
        }
        return self
    }

    func value(_ string: String) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityValue = string
        }
        return self
    }

    func frame(_ frame: CGRect) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityFrame = frame
        }
        return self
    }

    func hint(_ string: String) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityHint = string
        }
        return self
    }

    func groupAccessibilityChildren(_ flag: Bool) -> Self {
        self.manager.onNotRendered {
            $0.shouldGroupAccessibilityChildren = flag
        }
        return self
    }

    @available(iOS 11.0, tvOS 11.0, *)
    func containerType(_ type: UIAccessibilityContainerType) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityContainerType = type
        }
        return self
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func respondsToUserInteraction(_ flag: Bool) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityRespondsToUserInteraction = flag
        }
        return self
    }

    func path(_ path: UIBezierPath?) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityPath = path
        }
        return self
    }

    func language(_ string: String?) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityLanguage = string
        }
        return self
    }

    func isModal(_ flag: Bool) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityViewIsModal = flag
        }
        return self
    }

    func customRotors(_ rotors: [UIAccessibilityCustomRotor]) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityCustomRotors = rotors
        }
        return self
    }

    func customActions(_ actions: [UIAccessibilityCustomAction]) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityCustomActions = actions
        }
        return self
    }

    @available(iOS 11.0, tvOS 11, *)
    func attributedHint(_ attributedString: NSAttributedString) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityAttributedHint = attributedString
        }
        return self
    }

    func elementsHidden(_ flag: Bool) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityElementsHidden = flag
        }
        return self
    }

    func activationPoint(_ point: CGPoint) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityActivationPoint = point
        }
        return self
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func textualContext(_ context: UIAccessibilityTextualContext) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityTextualContext = context
        }
        return self
    }

    @available(iOS 11.0, tvOS 11, *)
    func attributedLabel(_ attributedString: NSAttributedString) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityAttributedLabel = attributedString
        }
        return self
    }

    @available(iOS 11.0, tvOS 11, *)
    func attributedValue(_ attributedString: NSAttributedString) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityAttributedValue = attributedString
        }
        return self
    }

    func navigationStyle(_ style: UIAccessibilityNavigationStyle) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityNavigationStyle = style
        }
        return self
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func userInputLabels(_ labels: [String]) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityUserInputLabels = labels
        }
        return self
    }

    #if os(iOS)
    @available(iOS 11.0, *)
    func dropPointDescriptors(_ points: [UIAccessibilityLocationDescriptor]) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityDropPointDescriptors = points
        }
        return self
    }

    @available(iOS 11.0, *)
    func dragSourceDescriptors(_ points: [UIAccessibilityLocationDescriptor]) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityDragSourceDescriptors = points
        }
        return self
    }
    #endif

    @available(iOS 13.0, tvOS 13.0, *)
    func attributedUserInputLabels(_ labels: [NSAttributedString]) -> Self {
        self.manager.onNotRendered {
            $0.accessibilityAttributedUserInputLabels = labels
        }
        return self
    }
}
