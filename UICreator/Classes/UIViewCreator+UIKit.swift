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

    func `as`<UIElement: UIView>(_ reference: inout [UIElement]) -> Self {
        if let view = self.uiView as? UIElement {
            reference.append(view)
        }
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
            if #available(iOS 12.0, tvOS 12.0, *) {
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
    @available(iOS 13, tvOS 13, *)
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

public extension ViewCreator {
    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    func frame(x: CGFloat) -> Self {
        self.onRendered {
            let frame = $0.frame
            $0.frame = .init(x: x, y: frame.origin.y, width: frame.width, height: frame.height)
        }
    }

    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    func frame(y: CGFloat) -> Self {
        self.onRendered {
            let frame = $0.frame
            $0.frame = .init(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
        }
    }

    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    func frame(height: CGFloat) -> Self {
        self.onRendered {
            let frame = $0.frame
            $0.frame = .init(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: height)
        }
    }

    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    func frame(width: CGFloat) -> Self {
        self.onRendered {
            let frame = $0.frame
            $0.frame = .init(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.height)
        }
    }
}

public extension ViewCreator {

    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    func frame(insetByX x: CGFloat) -> Self {
        self.onRendered {
            let frame = $0.frame
            $0.frame = frame.insetBy(dx: x, dy: 0)
        }
    }

    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    func frame(insetByY y: CGFloat) -> Self {
        self.onRendered {
            let frame = $0.frame
            $0.frame = frame.insetBy(dx: 0, dy: y)
        }
    }
}

public extension ViewCreator {

    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    func frame(offsetByX x: CGFloat) -> Self {
        self.onRendered {
            let frame = $0.frame
            $0.frame = frame.offsetBy(dx: x, dy: 0)
        }
    }

    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    func frame(offsetByY y: CGFloat) -> Self {
        self.onRendered {
            let frame = $0.frame
            $0.frame = frame.offsetBy(dx: 0, dy: y)
        }
    }
}

public extension ViewCreator {
    /// Set frame to UIView
    func frame(_ frame: CGRect) -> Self {
        self.onRendered {
            $0.frame = frame
        }
    }
}


public extension ViewCreator {
    @discardableResult
    func animate(_ duration: TimeInterval, animations: @escaping (UIView) -> Void) -> Self {
        UIView.animate(withDuration: duration, animations: {
            animations(self.uiView)
            self.uiView.setNeedsLayout()
        }, completion: nil)
        return self
    }

    @discardableResult
    func animate(_ duration: TimeInterval, animations: @escaping (UIView) -> Void, completion: @escaping (Bool) -> Void) -> Self {
        UIView.animate(withDuration: duration, animations: {
            animations(self.uiView)
            self.uiView.setNeedsLayout()
        }, completion: completion)
        return self
    }

    @discardableResult
    func animate(_ duration: TimeInterval, delay: TimeInterval, options: UIView.AnimationOptions, animations: @escaping (UIView) -> Void, completion: ((Bool) -> Void)? = nil) -> Self {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            animations(self.uiView)
            self.uiView.setNeedsLayout()
        }, completion: completion)
        return self
    }

    @discardableResult
    func animateWithKeyframes(_ duration: TimeInterval, delay: TimeInterval = 0, options: UIView.KeyframeAnimationOptions = [], animations animationsSequence: UIView.CreatorKeyframeSequence, completion: ((Bool) -> Void)? = nil) -> Self {
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: options, animations: {
            animationsSequence.sequence.forEach { keyframe in
                UIView.addKeyframe(withRelativeStartTime: keyframe.startTime, relativeDuration: keyframe.duration, animations: {
                    keyframe.animations(self.uiView)
                })
            }
        }, completion: completion)
        return self
    }
}

public extension UIView {
    struct CreatorKeyframe {
        let startTime: TimeInterval
        let duration: TimeInterval
        let animations: (UIView) -> Void

        private init(startAt startTime: TimeInterval, duration: TimeInterval, animations: @escaping (UIView) -> Void) {
            self.startTime = startTime
            self.duration = duration
            self.animations = animations
        }

        public static func keyframe(startAt startTime: TimeInterval, duration: TimeInterval, animations: @escaping (UIView) -> Void) -> CreatorKeyframe{
            return .init(startAt: startTime, duration: duration, animations: animations)
        }
    }

    struct CreatorKeyframeSequence {
        let sequence: [CreatorKeyframe]

        public init(_ sequence: CreatorKeyframe...) {
            self.sequence = sequence
        }
    }
}

public extension ViewCreator {
    func addLayer(_ handler: @escaping (UIView) -> CALayer) -> Self {
        self.onNotRendered {
            $0.layer.addSublayer(handler($0))
        }
    }
}
