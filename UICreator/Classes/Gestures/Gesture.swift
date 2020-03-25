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

public protocol Gesture: class {
    init(target view: UIView!)
}

public protocol UIGesture: Gesture {
    associatedtype Gesture: UIGestureRecognizer
}

public extension UIGesture {
    func add() {
        self.gesture.targetView?.addGestureRecognizer(self.releaseGesture())
    }
}

struct UIGesturePayload {
    let gestureObject: Mutable<DynamicWeakObject<AnyObject>> = .init(value: .nil)
    let targetViewObject: Mutable<DynamicWeakObject<UIView>> = .init(value: .nil)
}

private var kUIGesturePayload: UInt = 0
internal extension UIGestureRecognizer {
    var mutable: UIGesturePayload {
        OBJCSet(self, &kUIGesturePayload, policity: .OBJC_ASSOCIATION_COPY) {
            .init()
        }
    }

    var parent: Gesture? {
        get {
            self.mutable.gestureObject as? Gesture
        }
        set {
            guard let newValue = newValue else {
                self.mutable.gestureObject.value = .nil
                return
            }

            self.mutable.gestureObject.value = .weak(newValue)
        }
    }

    var targetView: UIView? {
        get { self.mutable.targetViewObject.value.object ?? self.view }
        set {
            if let newValue = newValue {
                self.mutable.targetViewObject.value = .weak(newValue)
                return
            }

            self.mutable.targetViewObject.value = .nil
        }
    }

    func releaseParent() {
        guard let parent = self.parent else {
            return
        }

        self.mutable.gestureObject.value = .strong(parent)
    }

    convenience init(target view: UIView!) {
        self.init(target: view, action: #selector(view.someGestureRecognized(_:)))
        self.targetView = view
    }
}

private var kGestureMutable: UInt = 0
internal extension Gesture {
    private var gestureMutable: Mutable<DynamicWeakObject<UIGestureRecognizer>> {
        OBJCSet(self, &kGestureMutable) {
            .init(value: .nil)
        }
    }

    var gesture: UIGestureRecognizer! {
        get { self.gestureMutable.value.object }
        set { setGesture(newValue, policity: newValue?.view?.superview != nil ? .OBJC_ASSOCIATION_ASSIGN : .OBJC_ASSOCIATION_RETAIN) }
    }

    func setGesture(_ uiGesture: UIGestureRecognizer, policity: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN) {
        if case .OBJC_ASSOCIATION_ASSIGN = policity {
            self.gestureMutable.value = .weak(uiGesture)
            return
        }

        self.gestureMutable.value = .strong(uiGesture)
    }

    func releaseGesture() -> UIGestureRecognizer! {
        let gesture: UIGestureRecognizer! = self.gesture
        self.setGesture(gesture, policity: .OBJC_ASSOCIATION_ASSIGN)
        gesture.releaseParent()
        return gesture
    }
}

internal struct Handler {
    let handler: (UIGestureRecognizer) -> Void

    init(_ handler: @escaping (UIGestureRecognizer) -> Void) {
        self.handler = handler
    }
}

struct GesturePayload: MutableEditable {

    let began: Handler?
    let cancelled: Handler?
    let changed: Handler?
    let failed: Handler?
    let recognized: Handler?
    let possible: Handler?
    let ended: Handler?
    let anyOther: Handler?

    init() {
        self.began = nil
        self.cancelled = nil
        self.changed = nil
        self.failed = nil
        self.recognized = nil
        self.possible = nil
        self.ended = nil
        self.anyOther = nil
    }

    init(_ original: GesturePayload, editable: Editable) {
        self.began = editable.began
        self.cancelled = editable.cancelled
        self.changed = editable.changed
        self.failed = editable.failed
        self.recognized = editable.recognized
        self.possible = editable.possible
        self.ended = editable.ended
        self.anyOther = editable.anyOther
    }

    func edit(_ edit: @escaping (Editable) -> Void) -> GesturePayload {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

extension GesturePayload {
    class Editable {
        var began: Handler?
        var cancelled: Handler?
        var changed: Handler?
        var failed: Handler?
        var recognized: Handler?
        var possible: Handler?
        var ended: Handler?
        var anyOther: Handler?

        init(_ payload: GesturePayload) {
            self.began = payload.began
            self.cancelled = payload.cancelled
            self.changed = payload.changed
            self.failed = payload.failed
            self.recognized = payload.recognized
            self.possible = payload.possible
            self.ended = payload.ended
            self.anyOther = payload.anyOther
        }
    }
}

private var kGestureWrapper: UInt = 0
internal extension Gesture {
    var gestureWrapper: Mutable<GesturePayload> {
        OBJCSet(self, &kGestureWrapper) {
            .init(value: .init())
        }
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

    @available(iOS 11, tvOS 11.0, *)
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
        let old = self.gestureWrapper.value.began
        self.gestureWrapper.update {
            $0.began = .init {
                guard let gesture = $0 as? Gesture else {
                    return
                }

                handler(gesture)
                old?.handler(gesture)
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

                handler(gesture)
                old?.handler(gesture)
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

                handler(gesture)
                old?.handler(gesture)
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

                handler(gesture)
                old?.handler(gesture)
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

                handler(gesture)
                old?.handler(gesture)
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

                handler(gesture)
                old?.handler(gesture)
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

                handler(gesture)
                old?.handler(gesture)
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

                handler(gesture)
                old?.handler(gesture)
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
            (payload.possible ?? payload.recognized)?.handler(sender)
        case .began:
            (payload.began ?? payload.recognized)?.handler(sender)
        case .changed:
            (payload.changed ?? payload.recognized)?.handler(sender)
        case .ended:
            (payload.ended ?? payload.recognized)?.handler(sender)
        case .cancelled:
            (payload.cancelled ?? payload.recognized)?.handler(sender)
        case .failed:
            (payload.failed ?? payload.recognized)?.handler(sender)
        @unknown default:
            payload.anyOther?.handler(sender)
        }
    }
}
