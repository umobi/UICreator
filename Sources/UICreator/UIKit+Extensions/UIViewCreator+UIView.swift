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

// swiftlint:disable file_length
public extension UIViewCreator {
    @inlinable
    func backgroundColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.backgroundColor = color
        }
    }

    @inlinable
    func tintColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.tintColor = color
        }
    }

    @inlinable
    func contentScaleFactor(_ scale: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.contentScaleFactor = scale
        }
    }

    @inlinable
    func zIndex(_ zIndex: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.zPosition = zIndex
        }
    }

    @inlinable
    func alpha(_ constant: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.alpha = constant
        }
    }

    @inlinable
    func alpha(_ dynamicConstant: Relay<CGFloat>) -> UICModifiedView<View> {
        self.onNotRendered {
            weak var view = $0 as? View

            dynamicConstant.sync {
                view?.alpha = $0
            }
        }
    }

    @inlinable
    func `as`(_ reference: UICOutlet<View>) -> UICModifiedView<View> {
        self.onNotRendered { [reference] in
            reference.ref($0 as? View)
        }
    }
}

public extension UIViewCreator {
    @inlinable
    func shadowRadius(_ radius: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowRadius = radius
        }
    }

    @inlinable
    func shadowOffset(_ offset: CGSize) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowOffset = offset
        }
    }

    // swiftlint:disable identifier_name
    @inlinable
    func shadowOffset(x: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowOffset = .init(width: x, height: 0)
        }
    }

    // swiftlint:disable identifier_name
    @inlinable
    func shadowOffset(y: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowOffset = .init(width: 0, height: y)
        }
    }

    // swiftlint:disable identifier_name
    @inlinable
    func shadowOffset(x: CGFloat, y: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowOffset = .init(width: x, height: y)
        }
    }

    @inlinable
    func shadowOcupacity(_ alpha: CGFloat) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowOpacity = Float(alpha)
        }
    }

    @inlinable
    func shadowColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.shadowColor = color?.cgColor
            $0.onTrait {
                $0.layer.shadowColor = color?.cgColor
            }
        }
    }

    @inlinable
    func clipsToBounds(_ flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.clipsToBounds = flag
        }
    }

    @inlinable
    func isOpaque(_ flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.isOpaque = flag
        }
    }

    @inlinable
    func isHidden(_ flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.isHidden = flag
        }
    }

    @inlinable
    func isUserInteractionEnabled(_ flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.isUserInteractionEnabled = flag
        }
    }

    #if os(iOS)
    @inlinable
    func isExclusiveTouch(_ flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.isExclusiveTouch = flag
        }
    }
    #endif
}

public extension UIViewCreator {
    #if os(iOS)
    @inlinable
    func statusBar(_ appearanceStyle: UIStatusBarStyle) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.nearHostingController().statusBarStyle = appearanceStyle
        }
    }
    #endif
}

public extension UIViewCreator {
    @available(iOS 13.0, tvOS 13.0, *) @inlinable
    func transform3d(_ transform3d: CATransform3D) -> UICModifiedView<View> {
        self.onRendered {
            $0.transform3D = transform3d
        }
    }

    @inlinable
    func transform(_ transform: CGAffineTransform) -> UICModifiedView<View> {
        self.onRendered {
            $0.transform = transform
        }
    }
}

public extension UIViewCreator {
    @available(iOS 13, tvOS 13, *) @inlinable
    func userInterfaceStyle(_ style: UIUserInterfaceStyle) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.overrideUserInterfaceStyle = style
        }
    }
}

public extension UIViewCreator {
    @inlinable
    func makeAccessibility() -> UICAccessibilityView<View> {
        UICAccessibilityView {
            self.releaseOperationCastedView()
        }
    }
}

public extension UIViewCreator {
    /**
        Use this function to move the view inside superview
        If you trying to set the frame directly at `var body: ViewCreator { get }`, use the frame(_:).
     */
    @inlinable
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
    @inlinable
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
    @inlinable
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
    @inlinable
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
    @inlinable
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
    @inlinable
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
    @inlinable
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
    @inlinable
    func frame(offsetByY yOffset: CGFloat) -> UICModifiedView<View> {
        self.onRendered {
            let frame = $0.frame
            $0.frame = frame.offsetBy(dx: 0, dy: yOffset)
        }
    }
}

public extension UIViewCreator {
    /// Set frame to CBView
    @inlinable
    func frame(_ frame: CGRect) -> UICModifiedView<View> {
        self.onRendered {
            $0.frame = frame
        }
    }
}

public extension UIViewCreator {
    @inlinable
    func animate(
        _ isAnimating: Relay<Bool>,
        _ duration: TimeInterval,
        animations: @escaping (CBView) -> Void) -> UICModifiedView<View> {

        self.onInTheScene {
            weak var view = $0

            isAnimating.sync {
                guard $0, let view = view else {
                    return
                }

                CBView.animate(withDuration: duration, animations: {
                    animations(view)
                    view.setNeedsLayout()
                }, completion: nil)
            }
        }
    }

    @inlinable
    func animate(
        _ isAnimating: Relay<Bool>,
        _ duration: TimeInterval,
        animations: @escaping (CBView) -> Void,
        completion: @escaping (Bool) -> Void) -> UICModifiedView<View> {

        self.onInTheScene {
            weak var view = $0

            isAnimating.sync {
                guard $0, let view = view else {
                    return
                }

                CBView.animate(withDuration: duration, animations: {
                    animations(view)
                    view.setNeedsLayout()
                }, completion: completion)
            }
        }
    }

    @inlinable
    func animate(
        _ isAnimating: Relay<Bool>,
        _ duration: TimeInterval,
        delay: TimeInterval,
        options: CBView.AnimationOptions,
        animations: @escaping (CBView) -> Void,
        completion: ((Bool) -> Void)? = nil) -> UICModifiedView<View> {

        self.onInTheScene {
            weak var view = $0

            isAnimating.sync {
                guard $0, let view = view else {
                    return
                }

                CBView.animate(
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

    @inlinable
    func animateWithKeyframes(
        _ isAnimating: Relay<Bool>,
        _ duration: TimeInterval,
        delay: TimeInterval = 0,
        options: CBView.KeyframeAnimationOptions = [],
        animations animationsSequence: CBView.CreatorKeyframeSequence,
        completion: ((Bool) -> Void)? = nil) -> UICModifiedView<View> {

        self.onInTheScene {
            weak var view = $0

            isAnimating.sync {
                guard $0, let view = view else {
                    return
                }

                CBView.animateKeyframes(
                    withDuration: duration,
                    delay: delay,
                    options: options,
                    animations: {
                        animationsSequence.sequence.forEach { keyframe in
                            CBView.addKeyframe(
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
    @inlinable
    func addLayer(_ handler: @escaping (CBView) -> CALayer) -> UICModifiedView<View> {
        self.onNotRendered {
            $0.layer.addSublayer(handler($0))
        }
    }
}

public extension UIViewCreator {
    @inlinable
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
    @inlinable
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
    @inlinable
    func isHidden(_ isHidden: Relay<Bool>) -> UICModifiedView<View> {
        self.onNotRendered { view in
            weak var weakView = view

            isHidden.sync {
                weakView?.isHidden = $0
            }
        }
    }

    @inlinable
    func tintColor(_ tintColor: Relay<UIColor>) -> UICModifiedView<View> {
        self.onNotRendered { view in
            weak var weakView = view
            tintColor.sync {
                weakView?.tintColor = $0
            }
        }
    }
}
