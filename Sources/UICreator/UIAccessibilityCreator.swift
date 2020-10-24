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

public struct UIAccessibilityCreator<ViewCreator: UIViewCreator> {
    public typealias View = ViewCreator.View

    private let modifierHandler: (ViewCreator) -> ViewCreator

    public init() {
        self.modifierHandler = { $0 }
    }

    private init(_ original: UIAccessibilityCreator<ViewCreator>, modifier: @escaping (ViewCreator) -> ViewCreator) {
        self.modifierHandler = {
            modifier(original.modifierHandler($0))
        }
    }

    public func modify(_ handler: @escaping (ViewCreator) -> ViewCreator) -> Self {
        .init(self, modifier: handler)
    }

    func viewCreator(_ viewCreator: ViewCreator) -> ViewCreator {
        self.modifierHandler(viewCreator)
    }
}

public extension UIAccessibilityCreator where View: UIView {
    @available(iOS 11.0, tvOS 11.0, *)
    func ignoresInvertColors(_ flag: Bool) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityIgnoresInvertColors = flag
            }
        }
    }

    func traits(_ traits: Set<UIAccessibilityTraits>) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityTraits = .init(traits)
            }
        }
    }

    func isEnabled(_ flag: Bool) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.isAccessibilityElement = flag
            }
        }
    }

    func identifier(_ string: String) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityIdentifier = string
            }
        }
    }

    func label(_ string: String) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityLabel = string
            }
        }
    }

    func value(_ string: String) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityValue = string
            }
        }
    }

    func frame(_ frame: CGRect) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityFrame = frame
            }
        }
    }

    func hint(_ string: String) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityHint = string
            }
        }
    }

    func groupAccessibilityChildren(_ flag: Bool) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.shouldGroupAccessibilityChildren = flag
            }
        }
    }

    @available(iOS 11.0, tvOS 11.0, *)
    func containerType(_ type: UIAccessibilityContainerType) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityContainerType = type
            }
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func respondsToUserInteraction(_ flag: Bool) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityRespondsToUserInteraction = flag
            }
        }
    }

    func path(_ path: UIBezierPath?) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityPath = path
            }
        }
    }

    func language(_ string: String?) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityLanguage = string
            }
        }
    }

    func isModal(_ flag: Bool) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityViewIsModal = flag
            }
        }
    }

    func customRotors(_ rotors: [UIAccessibilityCustomRotor]) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityCustomRotors = rotors
            }
        }
    }

    func customActions(_ actions: [UIAccessibilityCustomAction]) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityCustomActions = actions
            }
        }
    }

    @available(iOS 11.0, tvOS 11, *)
    func attributedHint(_ attributedString: NSAttributedString) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityAttributedHint = attributedString
            }
        }
    }

    func elementsHidden(_ flag: Bool) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityElementsHidden = flag
            }
        }
    }

    func activationPoint(_ point: CGPoint) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityActivationPoint = point
            }
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func textualContext(_ context: UIAccessibilityTextualContext) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityTextualContext = context
            }
        }
    }

    @available(iOS 11.0, tvOS 11, *)
    func attributedLabel(_ attributedString: NSAttributedString) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityAttributedLabel = attributedString
            }
        }
    }

    @available(iOS 11.0, tvOS 11, *)
    func attributedValue(_ attributedString: NSAttributedString) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityAttributedValue = attributedString
            }
        }
    }

    func navigationStyle(_ style: UIAccessibilityNavigationStyle) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityNavigationStyle = style
            }
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    func userInputLabels(_ labels: [String]) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityUserInputLabels = labels
            }
        }
    }

    #if os(iOS)
    @available(iOS 11.0, *)
    func dropPointDescriptors(_ points: [UIAccessibilityLocationDescriptor]) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityDropPointDescriptors = points
            }
        }
    }

    @available(iOS 11.0, *)
    func dragSourceDescriptors(_ points: [UIAccessibilityLocationDescriptor]) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityDragSourceDescriptors = points
            }
        }
    }
    #endif

    @available(iOS 13.0, tvOS 13.0, *)
    func attributedUserInputLabels(_ labels: [NSAttributedString]) -> Self {
        self.modify {
            $0.onNotRendered {
                $0.accessibilityAttributedUserInputLabels = labels
            }
        }
    }
}
