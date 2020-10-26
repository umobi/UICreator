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
public extension UIViewCreator {
    func backgroundColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.backgroundColor = color
        }
    }

    func tintColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.tintColor = color
        }
    }

    func contentScaleFactor(_ scale: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.contentScaleFactor = scale
        }
    }

    func zIndex(_ zIndex: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.zPosition = zIndex
        }
    }

    func alpha(_ constant: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.alpha = constant
        }
    }

    func alpha(_ dynamicConstant: Relay<CGFloat>) -> UICModifiedView<View> {
        self.onNotRendered {
            weak var view = $0 as? View

            dynamicConstant.sync {
                view?.alpha = $0
            }
        }
    }

    func `as`(_ reference: UICOutlet<View>) -> UICModifiedView<View> {
        self.onNotRendered { [reference] in
            reference.ref($0 as? View)
        }
    }
}

public extension UIViewCreator {
    func shadowRadius(_ radius: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowRadius = radius
        }
    }

    func shadowOffset(_ offset: CGSize) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowOffset = offset
        }
    }

    // swiftlint:disable identifier_name
    func shadowOffset(x: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowOffset = .init(width: x, height: 0)
        }
    }

    // swiftlint:disable identifier_name
    func shadowOffset(y: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowOffset = .init(width: 0, height: y)
        }
    }

    // swiftlint:disable identifier_name
    func shadowOffset(x: CGFloat, y: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowOffset = .init(width: x, height: y)
        }
    }

    func shadowOcupacity(_ alpha: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowOpacity = Float(alpha)
        }
    }

    func shadowColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowColor = color?.cgColor
            $0.onTrait {
                $0.layer.shadowColor = color?.cgColor
            }
        }
    }

    func clipsToBounds(_ flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.clipsToBounds = flag
        }
    }

    func isOpaque(_ flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.isOpaque = flag
        }
    }

    func isHidden(_ flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.isHidden = flag
        }
    }

    func isUserInteractionEnabled(_ flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.isUserInteractionEnabled = flag
        }
    }

    #if os(iOS)
    func isExclusiveTouch(_ flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.isExclusiveTouch = flag
        }
    }
    #endif
}

public extension UIViewCreator {
    #if os(iOS)
    func statusBar(_ appearanceStyle: UIStatusBarStyle) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0.viewController as? UICHostingController)?.statusBarStyle = appearanceStyle
        }
    }
    #endif
}

public extension UIViewCreator {
    @available(iOS 13.0, tvOS 13.0, *)
    func transform3d(_ transform3d: CATransform3D) -> UICModifiedView<View> {
        self.onRendered {
            $0.transform3D = transform3d
        }
    }

    func transform(_ transform: CGAffineTransform) -> UICModifiedView<View> {
        self.onRendered {
            $0.transform = transform
        }
    }
}

public extension UIViewCreator {
    @available(iOS 13, tvOS 13, *)
    func userInterfaceStyle(_ style: UIUserInterfaceStyle) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.overrideUserInterfaceStyle = style
        }
    }
}

public extension UIViewCreator {
    func accessibily(_ handler: @escaping () -> UIAccessibilityCreator<Self>) -> UICModifiedView<View> {
        handler().viewCreator(self)
    }
}

public extension UIViewCreator {
    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    // swiftlint:disable identifier_name
    func frame(x: CGFloat) -> UICModifiedView<View> {
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
    func frame(y: CGFloat) -> UICModifiedView<View> {
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
    func frame(height: CGFloat) -> UICModifiedView<View> {
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
    func frame(width: CGFloat) -> UICModifiedView<View> {
        self.onRendered {
            let frame = $0.frame
            $0.frame = .init(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.height)
        }
    }
}

public extension UIViewCreator {

    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    func frame(insetByX xInset: CGFloat) -> UICModifiedView<View> {
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
    func frame(insetByY yInset: CGFloat) -> UICModifiedView<View> {
        self.onRendered {
            let frame = $0.frame
            $0.frame = frame.insetBy(dx: 0, dy: yInset)
        }
    }
}

public extension UIViewCreator {

    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @discardableResult
    func frame(offsetByX xOffset: CGFloat) -> UICModifiedView<View> {
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
    func frame(offsetByY yOffset: CGFloat) -> UICModifiedView<View> {
        self.onRendered {
            let frame = $0.frame
            $0.frame = frame.offsetBy(dx: 0, dy: yOffset)
        }
    }
}

public extension UIViewCreator {
    /// Set frame to UIView
    func frame(_ frame: CGRect) -> UICModifiedView<View> {
        self.onRendered {
            $0.frame = frame
        }
    }
}

public extension UIViewCreator {
    @discardableResult
    func animate(
        _ isAnimating: Relay<Bool>,
        _ duration: TimeInterval,
        animations: @escaping (UIView) -> Void) -> UICModifiedView<View> {

        self.onInTheScene {
            weak var view = $0

            isAnimating.sync {
                guard $0, let view = view else {
                    return
                }

                UIView.animate(withDuration: duration, animations: {
                    animations(view)
                    view.setNeedsLayout()
                }, completion: nil)
            }
        }
    }

    @discardableResult
    func animate(
        _ isAnimating: Relay<Bool>,
        _ duration: TimeInterval,
        animations: @escaping (UIView) -> Void,
        completion: @escaping (Bool) -> Void) -> UICModifiedView<View> {

        self.onInTheScene {
            weak var view = $0

            isAnimating.sync {
                guard $0, let view = view else {
                    return
                }

                UIView.animate(withDuration: duration, animations: {
                    animations(view)
                    view.setNeedsLayout()
                }, completion: completion)
            }
        }
    }

    @discardableResult
    func animate(
        _ isAnimating: Relay<Bool>,
        _ duration: TimeInterval,
        delay: TimeInterval,
        options: UIView.AnimationOptions,
        animations: @escaping (UIView) -> Void,
        completion: ((Bool) -> Void)? = nil) -> UICModifiedView<View> {

        self.onInTheScene {
            weak var view = $0

            isAnimating.sync {
                guard $0, let view = view else {
                    return
                }

                UIView.animate(
                    withDuration: duration,
                    delay: delay,
                    options: options,
                    animations: {
                        animations(view)
                        view.setNeedsLayout()
                    },
                    completion: completion
                )
            }
        }
    }

    @discardableResult
    func animateWithKeyframes(
        _ isAnimating: Relay<Bool>,
        _ duration: TimeInterval,
        delay: TimeInterval = 0,
        options: UIView.KeyframeAnimationOptions = [],
        animations animationsSequence: UIView.CreatorKeyframeSequence,
        completion: ((Bool) -> Void)? = nil) -> UICModifiedView<View> {

        self.onInTheScene {
            weak var view = $0

            isAnimating.sync {
                guard $0, let view = view else {
                    return
                }

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
                                    keyframe.animations(view)
                                })
                        }
                    },
                    completion: completion)
            }
        }
    }
}

public extension UIViewCreator {
    func addLayer(_ handler: @escaping (UIView) -> CALayer) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.addSublayer(handler($0))
        }
    }
}

public extension UIViewCreator {
    func backgroundColor(_ color: Relay<UIColor>) -> UICModifiedView<View> {
        self.onNotRendered { view in
            weak var view = view
            color.sync {
                view?.backgroundColor = $0
            }
        }
    }
}

public extension UIViewCreator {
    func isUserInteractionEnabled(_ value: Relay<Bool>) -> UICModifiedView<View> {
        self.onInTheScene {
            weak var view = $0
            value.sync {
                view?.isUserInteractionEnabled = $0
            }
        }
    }
}

public extension UIViewCreator {
    func isHidden(_ isHidden: Relay<Bool>) -> UICModifiedView<View> {
        self.onNotRendered { view in
            weak var weakView = view
            isHidden.sync {
                weakView?.isHidden = $0
            }
        }
    }

    func tintColor(_ tintColor: Relay<UIColor>) -> UICModifiedView<View> {
        self.onNotRendered { view in
            weak var weakView = view
            tintColor.sync {
                weakView?.tintColor = $0
            }
        }
    }
}
