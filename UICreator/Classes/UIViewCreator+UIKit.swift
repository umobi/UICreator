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

public extension UIViewCreator {
    func background(color: UIColor?) -> Self {
        return self.onNotRendered {
            $0.backgroundColor = color
        }
    }

    func tintColor(_ color: UIColor?) -> Self {
        self.onNotRendered {
            $0.tintColor = color
        }
    }

    func contentScaleFactor(_ scale: CGFloat) -> Self {
        self.onNotRendered {
            $0.contentScaleFactor = scale
        }
    }

    func zIndex(_ zIndex: CGFloat) -> Self {
        self.onNotRendered {
            $0.layer.zPosition = zIndex
        }
    }

    func border(color: UIColor?) -> Self {
        return self.onNotRendered {
            $0.layer.borderColor = color?.cgColor
        }
    }

    func border(width: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.borderWidth = width
        }
    }

    func corner(radius: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.cornerRadius = radius
        }
    }

    func alpha(_ constant: CGFloat) -> Self {
        return self.onNotRendered {
            $0.alpha = constant
        }
    }

    func `as`<UIElement: UIView>(_ reference: inout UIElement!) -> Self {
        reference = self.uiView as? UIElement
        return self
    }
}

public extension UIViewCreator {
    func shadow(radius: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.shadowRadius = radius
        }
    }

    func shadow(offset: CGSize) -> Self {
        return self.onNotRendered {
            $0.layer.shadowOffset = offset
        }
    }

    func shadow(ocupacity alpha: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.shadowOpacity = Float(alpha)
        }
    }

    func shadow(color: UIColor?) -> Self {
        return self.onNotRendered {
            $0.layer.shadowColor = color?.cgColor
        }
    }

    func clips(toBounds flag: Bool) -> Self {
        return self.onInTheScene {
            $0.clipsToBounds = flag
        }
    }

    func isOpaque(_ flag: Bool) -> Self {
        return self.onInTheScene {
            $0.isOpaque = flag
        }
    }

    func isHidden(_ flag: Bool) -> Self {
        return self.onInTheScene {
            $0.isHidden = flag
        }
    }

    func isUserInteractionEnabled(_ flag: Bool) -> Self {
        return self.onInTheScene {
            $0.isUserInteractionEnabled = flag
        }
    }

    #if os(iOS)
    func isExclusiveTouch(_ flag: Bool) -> Self {
        return self.onInTheScene {
            $0.isExclusiveTouch = flag
        }
    }
    #endif
}

public extension ViewCreator {
    func transform3d(_ transform3d: CATransform3D) -> Self {
        self.onRendered {
            if #available(iOS 12.0, *) {
                $0.transform3D = transform3d
            } else {
                $0.layer.transform = transform3d
            }
        }
    }

    func transform(_ transform: CGAffineTransform) -> Self {
        self.onRendered {
            $0.transform = transform
        }
    }
}

public extension ViewCreator {
    @available(iOS 13, *)
    func userInterfaceStyle(_ style: UIUserInterfaceStyle) -> Self {
        self.onNotRendered {
            $0.overrideUserInterfaceStyle = style
        }
    }
}

public extension UIViewCreator {
    func accessibily(_ handler: @escaping (UIAccessibilityCreator<Self>) -> UIAccessibilityCreator<Self>) -> Self {
        _ = handler(.init(self))
        return self
    }
}

public struct UIAccessibilityCreator<UICreator: UIViewCreator> {
    public typealias View = UICreator.View

//    private let creator: UICreator
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

    @available(iOS 11.0, tvOS 11, *)
    func onVoiceOverChange(_ handler: @escaping (UIView) -> Void) -> Self {
        NotificationCenter.default.addObserver(forName: UIAccessibility.voiceOverStatusDidChangeNotification, object: nil, queue: nil) { (_) in
            handler(self.uiView)
        }

        return self
    }

    func onElementFocused(_ handler: @escaping (UIView) -> Void) -> Self {
        var isFocused = false
        NotificationCenter.default.addObserver(forName: UIAccessibility.elementFocusedNotification, object: nil, queue: nil) { notification in
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

        return self
    }

//    func a() {
//        self.uiView.accessibilityRespondsToUserInteraction
//    }
}
