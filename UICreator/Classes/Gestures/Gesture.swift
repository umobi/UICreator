//
//  UIView+Gesture.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
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

public protocol Gesture: UIGestureRecognizer {
    init(target: UIView!)
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
        set { objc_setAssociatedObject(self, &kOnBegan, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var cancelled: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnCancelled) as? Handler<Self> }
        set { objc_setAssociatedObject(self, &kOnCancelled, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var changed: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnChanged) as? Handler<Self> }
        set { objc_setAssociatedObject(self, &kOnChanged, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var failed: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnFailed) as? Handler<Self> }
        set { objc_setAssociatedObject(self, &kOnFailed, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var recognized: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnRecognized) as? Handler<Self> }
        set { objc_setAssociatedObject(self, &kOnRecognized, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var possible: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnPossible) as? Handler<Self> }
        set { objc_setAssociatedObject(self, &kOnPossible, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var ended: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnEnded) as? Handler<Self> }
        set { objc_setAssociatedObject(self, &kOnEnded, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var anyOther: Handler<Self>? {
        get { objc_getAssociatedObject(self, &kOnAnyOther) as? Handler<Self> }
        set { objc_setAssociatedObject(self, &kOnAnyOther, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

public extension Gesture {
    func cancelsTouches(inView flag: Bool) -> Self {
        self.cancelsTouchesInView = flag
        return self
    }

    func delaysTouches(atBegan flag: Bool) -> Self {
        self.delaysTouchesEnded = flag
        return self
    }

    func delaysTouches(atEnded flag: Bool) -> Self {
        self.delaysTouchesEnded = flag
        return self
    }

    func isEnabled(_ flag: Bool) -> Self {
        self.isEnabled = flag
        return self
    }

    @available(iOS 11, *)
    func name(_ string: String?) -> Self {
        self.name = string
        return self
    }

    func requiredExclusive(touchType flag: Bool) -> Self {
        self.requiresExclusiveTouchType = flag
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
    func commit(_ sender: Self) {
        switch self.state {
        case .possible:
            (sender.possible ?? sender.recognized)?.handler(sender)
        case .began:
            (sender.began ?? sender.recognized)?.handler(sender)
        case .changed:
            (sender.changed ?? sender.recognized)?.handler(sender)
        case .ended:
            (sender.ended ?? sender.recognized)?.handler(sender)
        case .cancelled:
            (sender.cancelled ?? sender.recognized)?.handler(sender)
        case .failed:
            (sender.failed ?? sender.recognized)?.handler(sender)
        @unknown default:
            sender.anyOther?.handler(sender)
        }
    }
}
