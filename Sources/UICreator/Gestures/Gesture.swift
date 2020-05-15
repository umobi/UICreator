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

struct UIGesturePayload {
    let gestureObject: Mutable<MemorySwitch> = .init(value: .nil)
    let targetViewObject: Mutable<MemorySwitch> = .init(value: .nil)
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
            self.mutable.gestureObject.value.object as? Gesture
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
        get { self.mutable.targetViewObject.value.castedObject() ?? self.view }
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
public extension Gesture {
    private var gestureMutable: Mutable<MemorySwitch> {
        OBJCSet(self, &kGestureMutable) {
            .init(value: .nil)
        }
    }

    private(set) var uiGesture: UIGestureRecognizer! {
        get { self.gestureMutable.value.castedObject() }
        set { setGesture(newValue, storeType: newValue?.view?.superview != nil ? .weak : .strong) }
    }

    internal func setGesture(_ uiGesture: UIGestureRecognizer, storeType: MemoryStoreType = .strong) {
        switch storeType {
        case .weak:
            self.gestureMutable.value = .weak(uiGesture)
        case .strong:
            self.gestureMutable.value = .strong(uiGesture)
        }
    }

    internal func releaseGesture() -> UIGestureRecognizer! {
        let gesture: UIGestureRecognizer! = self.uiGesture
        self.setGesture(gesture, storeType: .weak)
        gesture.releaseParent()
        return gesture
    }
}

struct GestureMemory: MutableEditable {
    typealias Handler = UIHandler<UIGestureRecognizer>

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

    init(_ original: GestureMemory, editable: Editable) {
        self.began = editable.began
        self.cancelled = editable.cancelled
        self.changed = editable.changed
        self.failed = editable.failed
        self.recognized = editable.recognized
        self.possible = editable.possible
        self.ended = editable.ended
        self.anyOther = editable.anyOther
    }

    func edit(_ edit: @escaping (Editable) -> Void) -> GestureMemory {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

extension GestureMemory {
    class Editable {
        var began: Handler?
        var cancelled: Handler?
        var changed: Handler?
        var failed: Handler?
        var recognized: Handler?
        var possible: Handler?
        var ended: Handler?
        var anyOther: Handler?

        init(_ payload: GestureMemory) {
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
private var kGestureDelegate: UInt = 0
internal extension Gesture {
    var gestureWrapper: Mutable<GestureMemory> {
        OBJCSet(self, &kGestureWrapper) {
            .init(value: .init())
        }
    }
}

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

    func onShouldRecognizeSimultaneouslyOtherGesture(_ handler: @escaping (Gesture, UIGestureRecognizer) -> Bool) -> Self {
        self.gestureDelegate.onShouldRecognizeSimultaneouslyOtherGesture(handler)
        return self
    }

    func onShouldRequireFailureOfOtherGesture(_ handler: @escaping (Gesture, UIGestureRecognizer) -> Bool) -> Self {
        self.gestureDelegate.onShouldRequireFailureOfOtherGesture(handler)
        return self
    }

    func onShouldBeRequiredToFailByOtherGesture(_ handler: @escaping (Gesture, UIGestureRecognizer) -> Bool) -> Self {
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

public class GestureDelegate<Gesture>: NSObject, UIGestureRecognizerDelegate where Gesture: UIGestureRecognizer {

    private var shouldBeginHandler: ((Gesture) -> Bool)? = nil
    func onShouldBegin(_ handler: @escaping (Gesture) -> Bool) {
        let old = self.shouldBeginHandler
        self.shouldBeginHandler = {
            if old?($0) ?? false {
                return true
            }

            return handler($0)
        }
    }

    private var shouldRecognizeSimultaneouslyOtherGestureHandler: ((Gesture, UIGestureRecognizer) -> Bool)? = nil
    func onShouldRecognizeSimultaneouslyOtherGesture(_ handler: @escaping (Gesture, UIGestureRecognizer) -> Bool) {
        let old = self.shouldRecognizeSimultaneouslyOtherGestureHandler
        self.shouldRecognizeSimultaneouslyOtherGestureHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldRequireFailureOfOtherGestureHandler: ((Gesture, UIGestureRecognizer) -> Bool)? = nil
    func onShouldRequireFailureOfOtherGesture(_ handler: @escaping (Gesture, UIGestureRecognizer) -> Bool) {
        let old = self.shouldRequireFailureOfOtherGestureHandler
        self.shouldRequireFailureOfOtherGestureHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldBeRequiredToFailByOtherGesture: ((Gesture, UIGestureRecognizer) -> Bool)? = nil
    func onShouldBeRequiredToFailByOtherGesture(_ handler: @escaping (Gesture, UIGestureRecognizer) -> Bool) {
        let old = self.shouldBeRequiredToFailByOtherGesture
        self.shouldBeRequiredToFailByOtherGesture = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldReceiveTouchHandler: ((Gesture, UITouch) -> Bool)? = nil
    func onShouldReceiveTouch(_ handler: @escaping (Gesture, UITouch) -> Bool) {
        let old = self.shouldReceiveTouchHandler
        self.shouldReceiveTouchHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldReceivePressHandler: ((Gesture, UIPress) -> Bool)? = nil
    func onShouldReceivePress(_ handler: @escaping (Gesture, UIPress) -> Bool) {
        let old = self.shouldReceivePressHandler
        self.shouldReceivePressHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldReceiveEventHandler: ((Gesture, UIEvent) -> Bool)? = nil
    func onShouldReceiveEvent(_ handler: @escaping (Gesture, UIEvent) -> Bool) {
        let old = self.shouldReceiveEventHandler
        self.shouldReceiveEventHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        return self.shouldBeginHandler?(gestureRecognizer) ?? true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        return self.shouldRecognizeSimultaneouslyOtherGestureHandler?(gestureRecognizer, otherGestureRecognizer) ?? false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        return self.shouldRecognizeSimultaneouslyOtherGestureHandler?(gestureRecognizer, otherGestureRecognizer) ?? gestureRecognizer.shouldRequireFailure(of: otherGestureRecognizer)
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        return self.shouldRequireFailureOfOtherGestureHandler?(gestureRecognizer, otherGestureRecognizer) ?? gestureRecognizer.shouldBeRequiredToFail(by: otherGestureRecognizer)
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        return self.shouldReceiveTouchHandler?(gestureRecognizer, touch) ?? true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        return self.shouldReceivePressHandler?(gestureRecognizer, press) ?? true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        if #available(iOS 13.4, tvOS 13.4, *) {
            return self.shouldReceiveEventHandler?(gestureRecognizer, event) ?? gestureRecognizer.shouldReceive(event)
        }

        return self.shouldReceiveEventHandler?(gestureRecognizer, event) ?? true
    }
}
