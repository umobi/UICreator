//
//  UIView+Gesture.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public protocol Gesture: UIGestureRecognizer {
    init(target: UIView!)
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

private var kOnBegan: UInt = 0
private var kOnCancelled: UInt = 0
private var kOnChanged: UInt = 0
private var kOnFailed: UInt = 0
private var kOnRecognized: UInt = 0
private var kOnPossible: UInt = 0
private var kOnEnded: UInt = 0
private var kOnAnyOther: UInt = 0

private class Handler<G: Gesture> {
    let handler: (G) -> Void

    init(_ handler: @escaping (G) -> Void) {
        self.handler = handler
    }
}

private extension Gesture {
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

private extension Gesture {
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

extension Gesture where Self: UITapGestureRecognizer {
    func number(ofTapsRequired number: Int) -> Self {
        self.numberOfTapsRequired = number
        return self
    }

    func number(ofTouchesRequired number: Int) -> Self {
        self.numberOfTouchesRequired = number
        return self
    }
}

extension Gesture where Self: UIPanGestureRecognizer {
    func maximumNumber(ofTouches number: Int) -> Self {
        self.maximumNumberOfTouches = number
        return self
    }

    func minimumNumber(ofTouches number: Int) -> Self {
        self.minimumNumberOfTouches = number
        return self
    }
}

extension Gesture where Self: UILongPressGestureRecognizer {
    func maximumMovement(_ value: CGFloat) -> Self {
        self.allowableMovement = value
        return self
    }

    func minimumPressDuration(_ duration: TimeInterval) -> Self {
        self.minimumPressDuration = duration
        return self
    }
}

extension Gesture where Self: UISwipeGestureRecognizer {
    func direction(_ direction: Direction) -> Self {
        self.direction = direction
        return self
    }

    func number(ofTouchesRequired number: Int) -> Self {
        self.numberOfTouchesRequired = number
        return self
    }
}

extension Gesture where Self: UIScreenEdgePanGestureRecognizer {

    func maximumNumber(ofTouches number: Int) -> Self {
        self.maximumNumberOfTouches = number
        return self
    }

    func minimumNumber(ofTouches number: Int) -> Self {
        self.minimumNumberOfTouches = number
        return self
    }

    func edges(_ edges: UIRectEdge) -> Self {
        self.edges = edges
        return self
    }
}


public class TapGesture: UITapGestureRecognizer, Gesture, HasViewDelegate {

    required public init(target: UIView!) {
        super.init(target: target, action: #selector(target.tap(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public class PanGesture: UIPanGestureRecognizer, Gesture, HasViewDelegate {

    required public init(target: UIView!) {
        super.init(target: target, action: #selector(target.pan(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public class LongPressGesture: UILongPressGestureRecognizer, Gesture, HasViewDelegate {

    required public init(target: UIView!) {
        super.init(target: target, action: #selector(target.longPress(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

@available(iOS 13.0, *)
public class HoverGesture: UIHoverGestureRecognizer, Gesture, HasViewDelegate {

    required public init(target: UIView!) {
        super.init(target: target, action: #selector(target.hover(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public class SwipeGesture: UISwipeGestureRecognizer, Gesture, HasViewDelegate {

    required public init(target: UIView!) {
        super.init(target: target, action: #selector(target.swipe(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public class RotationGesture: UIRotationGestureRecognizer, Gesture, HasViewDelegate {

    required public init(target: UIView!) {
        super.init(target: target, action: #selector(target.rotation(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public class PinchGesture: UIPinchGestureRecognizer, Gesture, HasViewDelegate {

    required public init(target: UIView!) {
        super.init(target: target, action: #selector(target.pinch(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public class ScreenEdgePanGesture: UIScreenEdgePanGestureRecognizer, Gesture, HasViewDelegate {

    required public init(target: UIView!) {
        super.init(target: target, action: #selector(target.screenEdgePan(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

fileprivate extension UIView {
    @objc func tap(_ sender: TapGesture!) {
        sender.commit(sender)
    }

    @objc func pan(_ sender: PanGesture!) {
        sender.commit(sender)
    }

    @objc func longPress(_ sender: LongPressGesture!) {
        sender.commit(sender)
    }

    @available(iOS 13.0, *)
    @objc func hover(_ sender: HoverGesture!) {
        sender.commit(sender)
    }

    @objc func swipe(_ sender: SwipeGesture!) {
        sender.commit(sender)
    }

    @objc func rotation(_ sender: RotationGesture!) {
        sender.commit(sender)
    }

    @objc func pinch(_ sender: PinchGesture!) {
        sender.commit(sender)
    }

    @objc func screenEdgePan(_ sender: ScreenEdgePanGesture!) {
        sender.commit(sender)
    }
}

public extension UIView {
    func onTapMaker(_ tapConfigurator: (TapGesture) -> TapGesture) -> Self {
        self.addGestureRecognizer(tapConfigurator(tapConfigurator(TapGesture(target: self))))
        return self
    }

    func onPanMaker(_ panConfigurator: (PanGesture) -> PanGesture) -> Self {
        self.addGestureRecognizer(panConfigurator(PanGesture(target: self)))
        return self
    }

    func onLongPressMaker(_ longPressConfigurator: (LongPressGesture) -> LongPressGesture) -> Self {
        self.addGestureRecognizer(longPressConfigurator(LongPressGesture(target: self)))
        return self
    }

    @available(iOS 13.0, *)
    func onHoverMaker(_ hoverConfigurator: (HoverGesture) -> HoverGesture) -> Self {
            self.addGestureRecognizer(hoverConfigurator(HoverGesture(target: self)))
            return self
        }

    func onSwipeMaker(_ swipeConfigurator: (SwipeGesture) -> SwipeGesture) -> Self {
        self.addGestureRecognizer(swipeConfigurator(SwipeGesture(target: self)))
        return self
    }

    func onRotationMaker(_ rotationConfigurator: (RotationGesture) -> RotationGesture) -> Self {
        self.addGestureRecognizer(rotationConfigurator(RotationGesture(target: self)))
        return self
    }

    func onPinchMaker(_ pinchConfigurator: (PinchGesture) -> PinchGesture) -> Self {
        self.addGestureRecognizer(pinchConfigurator(PinchGesture(target: self)))
        return self
    }

    func onScreenEdgePanMaker(_ screenEdgePanConfigurator: (ScreenEdgePanGesture) -> ScreenEdgePanGesture) -> Self {
        self.addGestureRecognizer(screenEdgePanConfigurator(ScreenEdgePanGesture(target: self)))
        return self
    }
}

public extension UIView {

    func onTap(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onTapMaker { [unowned self] in
            $0.onRecognized { _ in
                handler(self)
            }
        }
    }

    func onPan(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onPanMaker { [unowned self] in
            $0.onRecognized { _ in
                handler(self)
            }
        }
    }

    func onLongPress(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onLongPressMaker { [unowned self] in
            $0.onRecognized { _ in
                handler(self)
            }
        }
    }

    @available(iOS 13.0, *)
    func onHover(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onHoverMaker { [unowned self] in
            $0.onRecognized { _ in
                handler(self)
            }
        }
    }

    func onSwipe(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onSwipeMaker { [unowned self] in
            $0.onRecognized { _ in
                handler(self)
            }
        }
    }

    func onRotation(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onRotationMaker { [unowned self] in
            $0.onRecognized { _ in
                handler(self)
            }
        }
    }

    func onPinch(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onPinchMaker { [unowned self] in
            $0.onRecognized { _ in
                handler(self)
            }
        }
    }

    func onScreenEdgePan(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onScreenEdgePanMaker { [unowned self] in
            $0.onRecognized { _ in
                handler(self)
            }
        }
    }
}
