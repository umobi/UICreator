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

public protocol GestureRecognizer: UIGestureRecognizer {
    init(target view: UIView!)
}

public protocol Gesture {
    init(target view: UIView!)
}

public protocol UIGesture: Gesture {
    associatedtype Gesture: GestureRecognizer
}

private var kGesture: UInt = 0
internal extension GestureRecognizer {
    var parent: Gesture? {
        get { objc_getAssociatedObject(self, &kGesture) as? Gesture }
        set { objc_setAssociatedObject(self, &kGesture, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

private var kGestureRecognized: UInt = 0
internal extension Gesture {
    var gesture: GestureRecognizer! {
        get { objc_getAssociatedObject(self, &kGestureRecognized) as? GestureRecognizer }
        nonmutating
        set { setGesture(newValue, policity: newValue?.view != nil ? .OBJC_ASSOCIATION_ASSIGN : .OBJC_ASSOCIATION_RETAIN) }
    }

    func setGesture(_ uiGesture: GestureRecognizer, policity: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN) {
        objc_setAssociatedObject(self, &kGestureRecognized, uiGesture, policity)
    }
}

internal class Handler<G: Gesture> {
    let handler: (G) -> Void

    init(_ handler: @escaping (G) -> Void) {
        self.handler = handler
    }
}

internal extension Gesture {
    var began: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnBegan) as? Handler<Self> }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnBegan, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var cancelled: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnCancelled) as? Handler<Self> }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnCancelled, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var changed: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnChanged) as? Handler<Self> }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnChanged, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var failed: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnFailed) as? Handler<Self> }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnFailed, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var recognized: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnRecognized) as? Handler<Self> }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnRecognized, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var possible: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnPossible) as? Handler<Self> }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnPossible, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var ended: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnEnded) as? Handler<Self> }
        nonmutating
        set { objc_setAssociatedObject(self, &kOnEnded, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var anyOther: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnAnyOther) as? Handler<Self> }
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

public extension Gesture {
    func onBegan(_ handler: @escaping (Self) -> Void) -> Self {
        let allBegan = self.began
        self.began = .init {
            handler($0)
            allBegan?.handler($0)
        }
        return self
    }

    func onCancelled(_ handler: @escaping (Self) -> Void) -> Self {
        let allCancelled = self.cancelled
        self.cancelled = .init {
            handler($0)
            allCancelled?.handler($0)
        }
        return self
    }

    func onChanged(_ handler: @escaping (Self) -> Void) -> Self {
        let allChanged = self.changed
        self.changed = .init {
            handler($0)
            allChanged?.handler($0)
        }
        return self
    }

    func onFailed(_ handler: @escaping (Self) -> Void) -> Self {
        let allFailed = self.failed
        self.failed = .init {
            handler($0)
            allFailed?.handler($0)
        }
        return self
    }

    func onRecognized(_ handler: @escaping (Self) -> Void) -> Self {
        let allRecognized = self.recognized
        self.recognized = .init {
            handler($0)
            allRecognized?.handler($0)
        }
        return self
    }

    func onPossible(_ handler: @escaping (Self) -> Void) -> Self {
        let allPossible = self.possible
        self.possible = .init {
            handler($0)
            allPossible?.handler($0)
        }
        return self
    }

    func onEnded(_ handler: @escaping (Self) -> Void) -> Self {
        let allEnded = self.ended
        self.ended = .init {
            handler($0)
            allEnded?.handler($0)
        }
        return self
    }

    func onAnyOther(_ handler: @escaping (Self) -> Void) -> Self {
        let allAnyOther = self.anyOther
        self.anyOther = .init {
            handler($0)
            allAnyOther?.handler($0)
        }
        return self
    }
}

internal extension Gesture {
    func commit(_ sender: GestureRecognizer) {
        switch sender.state {
        case .possible:
            (self.possible ?? self.recognized)?.handler(self)
        case .began:
            (self.began ?? self.recognized)?.handler(self)
        case .changed:
            (self.changed ?? self.recognized)?.handler(self)
        case .ended:
            (self.ended ?? self.recognized)?.handler(self)
        case .cancelled:
            (self.cancelled ?? self.recognized)?.handler(self)
        case .failed:
            (self.failed ?? self.recognized)?.handler(self)
        @unknown default:
            self.anyOther?.handler(self)
        }
    }
}
