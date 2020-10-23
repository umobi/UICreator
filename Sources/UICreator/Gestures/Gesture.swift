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

public protocol Gesture: Opaque {
    init(target view: UIView!)
}

public protocol UIGesture: Gesture {
    associatedtype Gesture: UIGestureRecognizer
}

public extension UIGesture {
    func add() {
        self.uiGesture.targetView?.addGestureRecognizer(self.releaseGesture())
    }

    var uiGesture: Gesture! {
        (self as UICreator.Gesture).uiGesture as? Gesture
    }
}

struct GestureUIGestureSwitch {
    static func `switch`(_ gesture: Gesture?, _ uiGesture: UIGestureRecognizer?) {
        if let gesture = gesture {
            guard let uiGesture = uiGesture else {
                gesture.gestureWrapper.value.gesture.value = .nil
                return
            }

            if gesture.gestureWrapper.value.isReleased.value {
                gesture.gestureWrapper.value.gesture.value = .weak(uiGesture)
                UIGestureRecognizer.set(uiGesture, gesture, weak: false)
                return
            }

            gesture.gestureWrapper.value.gesture.value = .strong(uiGesture)
            UIGestureRecognizer.set(uiGesture, gesture, weak: true)
            return
        }

        if let uiGesture = uiGesture {
            UIGestureRecognizer.set(uiGesture, nil, weak: true)
            return
        }
    }
}

public extension Gesture {
    var uiGesture: UIGestureRecognizer! {
        self.gestureWrapper.value.gesture.value.castedObject()
    }

    internal func releaseGesture() -> UIGestureRecognizer! {
        let gesture: UIGestureRecognizer! = self.uiGesture
        self.gestureWrapper.value.isReleased.value = true
        GestureUIGestureSwitch.switch(self, gesture)
        return gesture
    }
}

private var kGestureWrapper: UInt = 0
internal extension Gesture {
    var gestureWrapper: Mutable<GestureMemory> {
        OBJCSet(self, &kGestureWrapper, policity: .OBJC_ASSOCIATION_RETAIN) {
            .init(value: .init())
        }
    }
}

private var kGestureDelegate: UInt = 0
internal extension UIGesture {
    var gestureDelegate: GestureDelegate<Gesture> {
        OBJCSet(self, &kGestureDelegate, policity: .OBJC_ASSOCIATION_RETAIN) {
            let delegate = GestureDelegate<Gesture>()
            self.uiGesture.delegate = delegate
            return delegate
        }
    }
}

public extension UIGesture {
    func `as`<UIGesture: UIGestureRecognizer>(_ outlet: UICOutlet<UIGesture>) -> Self {
        outlet.ref(self.uiGesture as? UIGesture)
        return self
    }

    func allowedPress(types pressTypes: Set<UIPress.PressType>) -> Self {
        self.uiGesture.allowedPressTypes = pressTypes.map { NSNumber(value: $0.rawValue) }
        return self
    }

    func allowedTouch(types touchTypes: Set<UITouch.TouchType>) -> Self {
        self.uiGesture.allowedTouchTypes = touchTypes.map { NSNumber(value: $0.rawValue) }
        return self
    }

    func cancelsTouches(inView flag: Bool) -> Self {
        self.uiGesture.cancelsTouchesInView = flag
        return self
    }

    func delaysTouches(atBegan flag: Bool) -> Self {
        self.uiGesture.delaysTouchesEnded = flag
        return self
    }

    func delaysTouches(atEnded flag: Bool) -> Self {
        self.uiGesture.delaysTouchesEnded = flag
        return self
    }

    func isEnabled(_ flag: Bool) -> Self {
        self.uiGesture.isEnabled = flag
        return self
    }

    @available(iOS 11, tvOS 11.0, *)
    func name(_ string: String?) -> Self {
        self.uiGesture.name = string
        return self
    }

    func requiredExclusive(touchType flag: Bool) -> Self {
        self.uiGesture.requiresExclusiveTouchType = flag
        return self
    }
}

public extension UIGesture {
    func onBegan(_ handler: @escaping (Gesture) -> Void) -> Self {
        let old = self.gestureWrapper.value.began
        self.gestureWrapper.update {
            $0.began = .init {
                guard let gesture = $0 as? Gesture else {
                    return
                }

                old?.commit(in: $0)
                handler(gesture)
            }
        }
        return self
    }

    func onCancelled(_ handler: @escaping (Gesture) -> Void) -> Self {
        let old = self.gestureWrapper.value.cancelled
        self.gestureWrapper.update {
            $0.cancelled = .init {
                guard let gesture = $0 as? Gesture else {
                    return
                }

                old?.commit(in: $0)
                handler(gesture)
            }
        }
        return self
    }

    func onChanged(_ handler: @escaping (Gesture) -> Void) -> Self {
        let old = self.gestureWrapper.value.changed
        self.gestureWrapper.update {
            $0.changed = .init {
                guard let gesture = $0 as? Gesture else {
                    return
                }

                old?.commit(in: $0)
                handler(gesture)
            }
        }
        return self
    }

    func onFailed(_ handler: @escaping (Gesture) -> Void) -> Self {
        let old = self.gestureWrapper.value.failed
        self.gestureWrapper.update {
            $0.failed = .init {
                guard let gesture = $0 as? Gesture else {
                    return
                }

                old?.commit(in: $0)
                handler(gesture)
            }
        }
        return self
    }

    func onRecognized(_ handler: @escaping (Gesture) -> Void) -> Self {
        let old = self.gestureWrapper.value.recognized
        self.gestureWrapper.update {
            $0.recognized = .init {
                guard let gesture = $0 as? Gesture else {
                    return
                }

                old?.commit(in: $0)
                handler(gesture)
            }
        }
        return self
    }

    func onPossible(_ handler: @escaping (Gesture) -> Void) -> Self {
        let old = self.gestureWrapper.value.possible
        self.gestureWrapper.update {
            $0.possible = .init {
                guard let gesture = $0 as? Gesture else {
                    return
                }

                old?.commit(in: $0)
                handler(gesture)
            }
        }
        return self
    }

    func onEnded(_ handler: @escaping (Gesture) -> Void) -> Self {
        let old = self.gestureWrapper.value.ended
        self.gestureWrapper.update {
            $0.ended = .init {
                guard let gesture = $0 as? Gesture else {
                    return
                }

                old?.commit(in: $0)
                handler(gesture)
            }
        }
        return self
    }

    func onAnyOther(_ handler: @escaping (Gesture) -> Void) -> Self {
        let old = self.gestureWrapper.value.anyOther
        self.gestureWrapper.update {
            $0.anyOther = .init {
                guard let gesture = $0 as? Gesture else {
                    return
                }

                old?.commit(in: $0)
                handler(gesture)
            }
        }
        return self
    }
}

internal extension Gesture {
    func commit(_ sender: UIGestureRecognizer) {
        let payload = self.gestureWrapper.value
        switch sender.state {
        case .possible:
            (payload.possible ?? payload.recognized)?.commit(in: sender)
        case .began:
            (payload.began ?? payload.recognized)?.commit(in: sender)
        case .changed:
            (payload.changed ?? payload.recognized)?.commit(in: sender)
        case .ended:
            (payload.ended ?? payload.recognized)?.commit(in: sender)
        case .cancelled:
            (payload.cancelled ?? payload.recognized)?.commit(in: sender)
        case .failed:
            (payload.failed ?? payload.recognized)?.commit(in: sender)
        @unknown default:
            payload.anyOther?.commit(in: sender)
        }
    }
}

public extension UIGesture {
    func onShouldBegin(_ handler: @escaping (Gesture) -> Bool) -> Self {
        self.gestureDelegate.onShouldBegin(handler)
        return self
    }

    func onShouldRecognizeSimultaneouslyOtherGesture(
        _ handler: @escaping (Gesture, UIGestureRecognizer) -> Bool) -> Self {

        self.gestureDelegate.onShouldRecognizeSimultaneouslyOtherGesture(handler)
        return self
    }

    func onShouldRequireFailureOfOtherGesture(
        _ handler: @escaping (Gesture, UIGestureRecognizer) -> Bool) -> Self {

        self.gestureDelegate.onShouldRequireFailureOfOtherGesture(handler)
        return self
    }

    func onShouldBeRequiredToFailByOtherGesture(
        _ handler: @escaping (Gesture, UIGestureRecognizer) -> Bool) -> Self {

        self.gestureDelegate.onShouldBeRequiredToFailByOtherGesture(handler)
        return self
    }

    func onShouldReceiveTouch(_ handler: @escaping (Gesture, UITouch) -> Bool) -> Self {
        self.gestureDelegate.onShouldReceiveTouch(handler)
        return self
    }

    func onShouldReceivePress(_ handler: @escaping (Gesture, UIPress) -> Bool) -> Self {
        self.gestureDelegate.onShouldReceivePress(handler)
        return self
    }

    func onShouldReceiveEvent(_ handler: @escaping (Gesture, UIEvent) -> Bool) -> Self {
        self.gestureDelegate.onShouldReceiveEvent(handler)
        return self
    }
}
