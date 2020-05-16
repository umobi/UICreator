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

// swiftlint:disable file_length
public extension ViewCreator {
    func backgroundColor(_ color: UIColor?) -> Self {
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

    func borderColor(_ color: UIColor?) -> Self {
        return self.onNotRendered {
            $0.layer.borderColor = color?.cgColor
            $0.onTrait {
                $0.layer.borderColor = color?.cgColor
            }
        }
    }

    func borderWidth(_ width: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.borderWidth = width
        }
    }

    func cornerRadius(_ radius: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.cornerRadius = radius
        }
    }

    func alpha(_ constant: CGFloat) -> Self {
        return self.onNotRendered {
            $0.alpha = constant
        }
    }

    func `as`<UIElement: UIView>(_ reference: UICOutlet<UIElement>) -> Self {
        return self.onNotRendered { [reference] in
            reference.ref($0 as? UIElement)
        }
    }
}

public extension ViewCreator {
    func shadowRadius(_ radius: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.shadowRadius = radius
        }
    }

    func shadowOffset(_ offset: CGSize) -> Self {
        return self.onNotRendered {
            $0.layer.shadowOffset = offset
        }
    }

    // swiftlint:disable identifier_name
    func shadowOffset(x: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.shadowOffset = .init(width: x, height: 0)
        }
    }

    // swiftlint:disable identifier_name
    func shadowOffset(y: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.shadowOffset = .init(width: 0, height: y)
        }
    }

    // swiftlint:disable identifier_name
    func shadowOffset(x: CGFloat, y: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.shadowOffset = .init(width: x, height: y)
        }
    }

    func shadowOcupacity(_ alpha: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.shadowOpacity = Float(alpha)
        }
    }

    func shadowColor(_ color: UIColor?) -> Self {
        return self.onNotRendered {
            $0.layer.shadowColor = color?.cgColor
            $0.onTrait {
                $0.layer.shadowColor = color?.cgColor
            }
        }
    }

    func clipsToBounds(_ flag: Bool) -> Self {
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
    #if os(iOS)
    func statusBar(_ appearanceStyle: UIStatusBarStyle) -> Self {
        self.onInTheScene {
            ($0.viewController as? UICHostingView)?.statusBarStyle = appearanceStyle
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
    // swiftlint:disable identifier_name
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
    // swiftlint:disable identifier_name
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
    func frame(insetByX xInset: CGFloat) -> Self {
        self.onRendered {
            let frame = $0.frame
            $0.frame = frame.insetBy(dx: xInset, dy: 0)
        }
    }

    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    func frame(insetByY yInset: CGFloat) -> Self {
        self.onRendered {
            let frame = $0.frame
            $0.frame = frame.insetBy(dx: 0, dy: yInset)
        }
    }
}

public extension ViewCreator {

    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    func frame(offsetByX xOffset: CGFloat) -> Self {
        self.onRendered {
            let frame = $0.frame
            $0.frame = frame.offsetBy(dx: xOffset, dy: 0)
        }
    }

    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    func frame(offsetByY yOffset: CGFloat) -> Self {
        self.onRendered {
            let frame = $0.frame
            $0.frame = frame.offsetBy(dx: 0, dy: yOffset)
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
    func animate(
        _ duration: TimeInterval,
        animations: @escaping (UIView) -> Void) -> Self {

        UIView.animate(withDuration: duration, animations: {
            animations(self.uiView)
            self.uiView.setNeedsLayout()
        }, completion: nil)

        return self
    }

    @discardableResult
    func animate(
        _ duration: TimeInterval,
        animations: @escaping (UIView) -> Void,
        completion: @escaping (Bool) -> Void) -> Self {

        UIView.animate(withDuration: duration, animations: {
            animations(self.uiView)
            self.uiView.setNeedsLayout()
        }, completion: completion)

        return self
    }

    @discardableResult
    func animate(
        _ duration: TimeInterval,
        delay: TimeInterval,
        options: UIView.AnimationOptions,
        animations: @escaping (UIView) -> Void,
        completion: ((Bool) -> Void)? = nil) -> Self {

        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: {
                animations(self.uiView)
                self.uiView.setNeedsLayout()
            },
            completion: completion
        )
        return self
    }

    @discardableResult
    func animateWithKeyframes(
        _ duration: TimeInterval,
        delay: TimeInterval = 0,
        options: UIView.KeyframeAnimationOptions = [],
        animations animationsSequence: UIView.CreatorKeyframeSequence,
        completion: ((Bool) -> Void)? = nil) -> Self {

        UIView.animateKeyframes(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: {
                animationsSequence.sequence.forEach { keyframe in
                    UIView.addKeyframe(
                        withRelativeStartTime: keyframe.startTime,
                        relativeDuration: keyframe.duration,
                        animations: {
                            keyframe.animations(self.uiView)
                        })
                }
            },
            completion: completion
        )
        return self
    }
}

public extension ViewCreator {
    func addLayer(_ handler: @escaping (UIView) -> CALayer) -> Self {
        self.onNotRendered {
            $0.layer.addSublayer(handler($0))
        }
    }
}

public extension ViewCreator {
    func backgroundColor(_ color: Relay<UIColor>) -> Self {
        self.onNotRendered { view in
            weak var view = view
            color.sync {
                view?.backgroundColor = $0
            }
        }
    }

    func borderColor(_ color: Relay<UIColor>) -> Self {

        return self.onNotRendered { view in
            weak var view = view
            color.sync {
                view?.layer.borderColor = $0.cgColor
            }

            view?.onTrait {
                $0.layer.borderColor = color.wrappedValue.cgColor
            }
        }
    }

    func borderWidth(_ constant: Relay<CGFloat>) -> Self {
        self.onNotRendered { view in
            weak var view = view
            constant.sync {
                view?.layer.borderWidth = $0
            }
        }
    }
}

public extension ViewCreator {
    func isUserInteractionEnabled(_ value: Relay<Bool>) -> Self {
        self.onInTheScene {
            weak var view = $0
            value.sync {
                view?.isUserInteractionEnabled = $0
            }
        }
    }
}

public extension ViewCreator {
    func isHidden(_ isHidden: Relay<Bool>) -> Self {
        self.onNotRendered { view in
            weak var weakView = view
            isHidden.sync {
                weakView?.isHidden = $0
            }
        }
    }

    func tintColor(_ tintColor: Relay<UIColor>) -> Self {
        self.onNotRendered { view in
            weak var weakView = view
            tintColor.sync {
                weakView?.tintColor = $0
            }
        }
    }
}

public extension UICViewRepresentable {
    func isHidden(_ isHidden: Relay<Bool>) -> Self {
        self.onRendered { [weak self] _ in
            isHidden.sync {
                self?.wrapper?.isHidden = $0
            }
        }
    }

    func isHidden(_ flag: Bool) -> Self {
        self.onRendered { [weak self] _ in
            self?.wrapper.isHidden = flag
        }
    }
}
