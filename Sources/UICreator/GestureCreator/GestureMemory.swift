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

private var kGestureMemory = 0
extension UIGestureRecognizer {
    struct Memory {
        @MutableBox var began: ((UIGestureRecognizer) -> Void)?
        @MutableBox var cancelled: ((UIGestureRecognizer) -> Void)?
        @MutableBox var changed: ((UIGestureRecognizer) -> Void)?
        @MutableBox var failed: ((UIGestureRecognizer) -> Void)?
        @MutableBox var recognized: ((UIGestureRecognizer) -> Void)?
        @MutableBox var possible: ((UIGestureRecognizer) -> Void)?
        @MutableBox var ended: ((UIGestureRecognizer) -> Void)?
        @MutableBox var anyOther: ((UIGestureRecognizer) -> Void)?

        @MutableBox var shouldBegin: ((UIGestureRecognizer) -> Bool)?
        @MutableBox var shouldRecognizeSimultaneouslyGesture: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)?
        @MutableBox var shouldRequireFailureOfGesture: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)?
        @MutableBox var shouldBeRequiredToFailByOther: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)?
        @MutableBox var shouldReceiveTouch: ((UIGestureRecognizer, UITouch) -> Bool)?
        @MutableBox var shouldReceivePress: ((UIGestureRecognizer, UIPress) -> Bool)?
        @MutableBox var shouldReceiveEvent: ((UIGestureRecognizer, UIEvent) -> Bool)?

        @MutableBox var delegate: UICGestureDelegate?
    }

    var memory: Memory {
        OBJCSet(
            self,
            &kGestureMemory,
            policity: .OBJC_ASSOCIATION_COPY,
            orLoad: Memory.init
        )
    }
}

extension UIGestureRecognizer {

    @inline(__always)
    func commit<P1, Return>(
        _ keyPath: KeyPath<Memory, ((P1) -> Return)?>,
        _ p1: P1) -> Return? {
        self.memory[keyPath: keyPath]?(p1)
    }

    @inline(__always)
    func commit<P1, P2, Return>(
        _ keyPath: KeyPath<Memory, ((P1, P2) -> Return)?>,
        _ p1: P1,
        _ p2: P2) -> Return? {
        self.memory[keyPath: keyPath]?(p1, p2)
    }
}

private extension UIGestureRecognizer {

    func onHandler<P1, Return>(
        _ keyPath: ReferenceWritableKeyPath<Memory, ((P1) -> Return)?>,
        handler: @escaping (P1) -> Return,
        returning: @escaping (Return?, Return) -> Return,
        delegate checkDelegate: Bool = true) -> Self {

        if checkDelegate {
            self.setDelegateIfNeeded()
        }

        let old = self.memory[keyPath: keyPath]
        self.memory[keyPath: keyPath] = {
            returning(old?($0), handler($0))
        }

        return self
    }

    func onHandler<P1, P2, Return>(
        _ keyPath: ReferenceWritableKeyPath<Memory, ((P1, P2) -> Return)?>,
        handler: @escaping (P1, P2) -> Return,
        returning: @escaping (Return?, Return) -> Return,
        delegate checkDelegate: Bool = true) -> Self {

        if checkDelegate {
            self.setDelegateIfNeeded()
        }

        let old = self.memory[keyPath: keyPath]
        self.memory[keyPath: keyPath] = {
            returning(old?($0, $1), handler($0, $1))
        }

        return self
    }
}

extension UIGestureRecognizer {
    @usableFromInline
    func setDelegateIfNeeded() {
        guard self.memory.delegate == nil else {
            return
        }

        let delegate = UICGestureDelegate()
        self.memory.delegate = delegate
        self.delegate = delegate
    }
}

public extension UIGestureRecognizer {

    @discardableResult @inline(__always)
    func onShouldBegin(_ handler: @escaping (UIGestureRecognizer) -> Bool) -> Self {
        self.onHandler(
            \.shouldBegin,
            handler: handler,
            returning: { ($0 ?? false) || $1 }
        )
    }

    @discardableResult @inline(__always)
    func onShouldRecognizeSimultaneouslyGesture(
        _ handler: @escaping (UIGestureRecognizer, UIGestureRecognizer) -> Bool) -> Self {
        self.onHandler(
            \.shouldRecognizeSimultaneouslyGesture,
            handler: handler,
            returning: { ($0 ?? false) || $1 }
        )
    }

    @discardableResult @inline(__always)
    func onShouldRequireFailureOfGesture(
        _ handler: @escaping (UIGestureRecognizer, UIGestureRecognizer) -> Bool) -> Self {
        self.onHandler(
            \.shouldRequireFailureOfGesture,
            handler: handler,
            returning: { ($0 ?? false) || $1 }
        )
    }

    @discardableResult @inline(__always)
    func onShouldBeRequiredToFailByOther(
        _ handler: @escaping (UIGestureRecognizer, UIGestureRecognizer) -> Bool) -> Self {
        self.onHandler(
            \.shouldBeRequiredToFailByOther,
            handler: handler,
            returning: { ($0 ?? false) || $1 }
        )
    }

    @discardableResult @inline(__always)
    func onShouldReceiveTouch(_ handler: @escaping (UIGestureRecognizer, UITouch) -> Bool) -> Self {
        self.onHandler(
            \.shouldReceiveTouch,
            handler: handler,
            returning: { ($0 ?? false) || $1 }
        )
    }

    @discardableResult @inline(__always)
    func onShouldReceivePress(_ handler: @escaping (UIGestureRecognizer, UIPress) -> Bool) -> Self {
        self.onHandler(
            \.shouldReceivePress,
            handler: handler,
            returning: { ($0 ?? false) || $1 }
        )
    }

    @discardableResult @inline(__always)
    func onShouldReceiveEvent(_ handler: @escaping (UIGestureRecognizer, UIEvent) -> Bool) -> Self {
        self.onHandler(
            \.shouldReceiveEvent,
            handler: handler,
            returning: { ($0 ?? false) || $1 }
        )
    }
}

public extension UIGestureRecognizer {
    @discardableResult @inline(__always)
    func onBegan(_ handler: @escaping (UIGestureRecognizer) -> Void) -> Self {
        self.onHandler(
            \.began,
            handler: handler,
            returning: { _, _ in },
            delegate: false
        )
    }

    @discardableResult @inline(__always)
    func onCancelled(_ handler: @escaping (UIGestureRecognizer) -> Void) -> Self {
        self.onHandler(
            \.cancelled,
            handler: handler,
            returning: { _, _ in },
            delegate: false
        )
    }

    @discardableResult @inline(__always)
    func onChanged(_ handler: @escaping (UIGestureRecognizer) -> Void) -> Self {
        self.onHandler(
            \.changed,
            handler: handler,
            returning: { _, _ in },
            delegate: false
        )
    }

    @discardableResult @inline(__always)
    func onFailed(_ handler: @escaping (UIGestureRecognizer) -> Void) -> Self {
        self.onHandler(
            \.failed,
            handler: handler,
            returning: { _, _ in },
            delegate: false
        )
    }

    @discardableResult @inline(__always)
    func onRecognized(_ handler: @escaping (UIGestureRecognizer) -> Void) -> Self {
        self.onHandler(
            \.recognized,
            handler: handler,
            returning: { _, _ in },
            delegate: false
        )
    }

    @discardableResult @inline(__always)
    func onPossible(_ handler: @escaping (UIGestureRecognizer) -> Void) -> Self {
        self.onHandler(
            \.possible,
            handler: handler,
            returning: { _, _ in },
            delegate: false
        )
    }

    @discardableResult @inline(__always)
    func onEnded(_ handler: @escaping (UIGestureRecognizer) -> Void) -> Self {
        self.onHandler(
            \.ended,
            handler: handler,
            returning: { _, _ in },
            delegate: false
        )
    }

    @discardableResult @inline(__always)
    func onAnyOther(_ handler: @escaping (UIGestureRecognizer) -> Void) -> Self {
        self.onHandler(
            \.anyOther,
            handler: handler,
            returning: { _, _ in },
            delegate: false
        )
    }
}

internal extension UIGestureRecognizer {
    @objc @usableFromInline
    func commit(_ sender: UIGestureRecognizer) {
        let memory = sender.memory
        switch sender.state {
        case .possible:
            (memory.possible ?? memory.recognized)?(sender)
        case .began:
            (memory.began ?? memory.recognized)?(sender)
        case .changed:
            (memory.changed ?? memory.recognized)?(sender)
        case .ended:
            (memory.ended ?? memory.recognized)?(sender)
        case .cancelled:
            (memory.cancelled ?? memory.recognized)?(sender)
        case .failed:
            (memory.failed ?? memory.recognized)?(sender)
        @unknown default:
            memory.anyOther?(sender)
        }
    }
}

