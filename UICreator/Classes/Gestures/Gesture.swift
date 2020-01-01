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

private var kOnBegan: UInt = 0
private var kOnCancelled: UInt = 0
private var kOnChanged: UInt = 0
private var kOnFailed: UInt = 0
private var kOnRecognized: UInt = 0
private var kOnPossible: UInt = 0
private var kOnEnded: UInt = 0
private var kOnAnyOther: UInt = 0

public protocol Gesture {
    init(target view: UIView!)
}

public protocol UIGesture: Gesture {
    associatedtype Gesture: UIGestureRecognizer
}

private var kGesture: UInt = 0
internal extension UIGestureRecognizer {
    var parent: Gesture? {
        get { objc_getAssociatedObject(self, &kGesture) as? Gesture }
        set { objc_setAssociatedObject(self, &kGesture, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    convenience init(target view: UIView!) {
        self.init(target: view, action: #selector(view.someGestureRecognized(_:)))
    }
}

private var kGestureRecognized: UInt = 0
internal extension Gesture {
    var gesture: UIGestureRecognizer! {
        get { objc_getAssociatedObject(self, &kGestureRecognized) as? UIGestureRecognizer }
        nonmutating
        set { setGesture(newValue, policity: newValue?.view != nil ? .OBJC_ASSOCIATION_ASSIGN : .OBJC_ASSOCIATION_RETAIN) }
    }

    func setGesture(_ uiGesture: UIGestureRecognizer, policity: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN) {
        objc_setAssociatedObject(self, &kGestureRecognized, uiGesture, policity)
    }
}

internal class Handler {
    let handler: (UIGestureRecognizer) -> Void

    init(_ handler: @escaping (UIGestureRecognizer) -> Void) {
        self.handler = handler
    }
}

internal extension Gesture {
    var began: Handler? {
        get { objc_getAssociatedObject(self, &kOnBegan) as? Handler }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnBegan, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var cancelled: Handler? {
        get { objc_getAssociatedObject(self, &kOnCancelled) as? Handler }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnCancelled, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var changed: Handler? {
        get { objc_getAssociatedObject(self, &kOnChanged) as? Handler }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnChanged, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var failed: Handler? {
        get { objc_getAssociatedObject(self, &kOnFailed) as? Handler }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnFailed, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var recognized: Handler? {
        get { objc_getAssociatedObject(self, &kOnRecognized) as? Handler }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnRecognized, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var possible: Handler? {
        get { objc_getAssociatedObject(self, &kOnPossible) as? Handler }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnPossible, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var ended: Handler? {
        get { objc_getAssociatedObject(self, &kOnEnded) as? Handler }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnEnded, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var anyOther: Handler? {
        get { objc_getAssociatedObject(self, &kOnAnyOther) as? Handler }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnAnyOther, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

public extension UIGesture {
    func `as`<UIGesture: UIGestureRecognizer>(_ reference: inout UIGesture!) -> Self {
        reference = self.gesture as? UIGesture
        return self
    }

    func allowedPress(types pressTypes: Set<UIPress.PressType>) -> Self {
        self.gesture.allowedPressTypes = pressTypes.map { NSNumber(value: $0.rawValue) }
        return self
    }

    func allowedTouch(types touchTypes: Set<UITouch.TouchType>) -> Self {
        self.gesture.allowedTouchTypes = touchTypes.map { NSNumber(value: $0.rawValue) }
        return self
    }

    func cancelsTouches(inView flag: Bool) -> Self {
        self.gesture.cancelsTouchesInView = flag
        return self
    }

    func delaysTouches(atBegan flag: Bool) -> Self {
        self.gesture.delaysTouchesEnded = flag
        return self
    }

    func delaysTouches(atEnded flag: Bool) -> Self {
        self.gesture.delaysTouchesEnded = flag
        return self
    }

    func isEnabled(_ flag: Bool) -> Self {
        self.gesture.isEnabled = flag
        return self
    }

    @available(tvOS 11.0, *)
    @available(iOS 11, *)
    func name(_ string: String?) -> Self {
        self.gesture.name = string
        return self
    }

    func requiredExclusive(touchType flag: Bool) -> Self {
        self.gesture.requiresExclusiveTouchType = flag
        return self
    }
}

public extension UIGesture {
    func onBegan(_ handler: @escaping (Gesture) -> Void) -> Self {
        let allBegan = self.began
        self.began = .init {
            guard let gesture = $0 as? Gesture else {
                return
            }

            handler(gesture)
            allBegan?.handler(gesture)
        }
        return self
    }

    func onCancelled(_ handler: @escaping (Gesture) -> Void) -> Self {
        let allCancelled = self.cancelled
        self.cancelled = .init {
            guard let gesture = $0 as? Gesture else {
                return
            }

            handler(gesture)
            allCancelled?.handler(gesture)
        }
        return self
    }

    func onChanged(_ handler: @escaping (Gesture) -> Void) -> Self {
        let allChanged = self.changed
        self.changed = .init {
            guard let gesture = $0 as? Gesture else {
                return
            }

            handler(gesture)
            allChanged?.handler(gesture)
        }
        return self
    }

    func onFailed(_ handler: @escaping (Gesture) -> Void) -> Self {
        let allFailed = self.failed
        self.failed = .init {
            guard let gesture = $0 as? Gesture else {
                return
            }

            handler(gesture)
            allFailed?.handler(gesture)
        }
        return self
    }

    func onRecognized(_ handler: @escaping (Gesture) -> Void) -> Self {
        let allRecognized = self.recognized
        self.recognized = .init {
            guard let gesture = $0 as? Gesture else {
                return
            }

            handler(gesture)
            allRecognized?.handler(gesture)
        }
        return self
    }

    func onPossible(_ handler: @escaping (Gesture) -> Void) -> Self {
        let allPossible = self.possible
        self.possible = .init {
            guard let gesture = $0 as? Gesture else {
                return
            }

            handler(gesture)
            allPossible?.handler(gesture)
        }
        return self
    }

    func onEnded(_ handler: @escaping (Gesture) -> Void) -> Self {
        let allEnded = self.ended
        self.ended = .init {
            guard let gesture = $0 as? Gesture else {
                return
            }

            handler(gesture)
            allEnded?.handler(gesture)
        }
        return self
    }

    func onAnyOther(_ handler: @escaping (Gesture) -> Void) -> Self {
        let allAnyOther = self.anyOther
        self.anyOther = .init {
            guard let gesture = $0 as? Gesture else {
                return
            }

            handler(gesture)
            allAnyOther?.handler(gesture)
        }
        return self
    }
}

internal extension Gesture {
    func commit(_ sender: UIGestureRecognizer) {
        switch sender.state {
        case .possible:
            (self.possible ?? self.recognized)?.handler(sender)
        case .began:
            (self.began ?? self.recognized)?.handler(sender)
        case .changed:
            (self.changed ?? self.recognized)?.handler(sender)
        case .ended:
            (self.ended ?? self.recognized)?.handler(sender)
        case .cancelled:
            (self.cancelled ?? self.recognized)?.handler(sender)
        case .failed:
            (self.failed ?? self.recognized)?.handler(sender)
        @unknown default:
            self.anyOther?.handler(sender)
        }
    }
}
