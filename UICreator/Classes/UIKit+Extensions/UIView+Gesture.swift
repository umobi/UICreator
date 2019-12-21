//
//  UIView+Gesture.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

protocol Gesture: UIGestureRecognizer {
    var handler: () -> Void { get }
    init(target: UIView!, action handler: @escaping () -> Void)
}

public class TapGesture: UITapGestureRecognizer, Gesture, HasViewDelegate {

    let handler: () -> Void

    required init(target: UIView!, action handler: @escaping () -> Void) {
        self.handler = handler
        super.init(target: target, action: #selector(target.tap(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public class PanGesture: UIPanGestureRecognizer, Gesture, HasViewDelegate {

    let handler: () -> Void

    required init(target: UIView!, action handler: @escaping () -> Void) {
        self.handler = handler
        super.init(target: target, action: #selector(target.pan(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public class LongPressGesture: UILongPressGestureRecognizer, Gesture, HasViewDelegate {

    let handler: () -> Void

    required init(target: UIView!, action handler: @escaping () -> Void) {
        self.handler = handler
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

    let handler: () -> Void

    required init(target: UIView!, action handler: @escaping () -> Void) {
        self.handler = handler
        super.init(target: target, action: #selector(target.hover(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public class SwipeGesture: UISwipeGestureRecognizer, Gesture, HasViewDelegate {

    let handler: () -> Void

    required init(target: UIView!, action handler: @escaping () -> Void) {
        self.handler = handler
        super.init(target: target, action: #selector(target.swipe(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public class RotationGesture: UIRotationGestureRecognizer, Gesture, HasViewDelegate {

    let handler: () -> Void

    required init(target: UIView!, action handler: @escaping () -> Void) {
        self.handler = handler
        super.init(target: target, action: #selector(target.rotation(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public class PinchGesture: UIPinchGestureRecognizer, Gesture, HasViewDelegate {

    let handler: () -> Void

    required init(target: UIView!, action handler: @escaping () -> Void) {
        self.handler = handler
        super.init(target: target, action: #selector(target.pinch(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public class ScreenEdgePanGesture: UIScreenEdgePanGestureRecognizer, Gesture, HasViewDelegate {

    let handler: () -> Void

    required init(target: UIView!, action handler: @escaping () -> Void) {
        self.handler = handler
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
        sender.handler()
    }

    @objc func pan(_ sender: PanGesture!) {
        sender.handler()
    }

    @objc func longPress(_ sender: LongPressGesture!) {
        sender.handler()
    }

    @available(iOS 13.0, *)
    @objc func hover(_ sender: HoverGesture!) {
        sender.handler()
    }

    @objc func swipe(_ sender: SwipeGesture!) {
        sender.handler()
    }

    @objc func rotation(_ sender: RotationGesture!) {
        sender.handler()
    }

    @objc func pinch(_ sender: PinchGesture!) {
        sender.handler()
    }

    @objc func screenEdgePan(_ sender: ScreenEdgePanGesture!) {
        sender.handler()
    }
}

public extension UIView {
    func onTap(tapConfigurator: ((UITapGestureRecognizer) -> Void)? = nil, _ handler: @escaping (UIView) -> Void) -> Self {
        let tapGesture = TapGesture(target: self, action: { [unowned self] in
            handler(self)
        })

        tapConfigurator?(tapGesture)
        return self
    }

    func onPan(panConfigurator: ((UIPanGestureRecognizer) -> Void)? = nil, _ handler: @escaping (UIView) -> Void) -> Self {
        let panGesture = PanGesture(target: self, action: { [unowned self] in
            handler(self)
        })

        panConfigurator?(panGesture)
        return self
    }

    func onLongPress(longPressConfigurator: ((UILongPressGestureRecognizer) -> Void)? = nil, _ handler: @escaping (UIView) -> Void) -> Self {
        let longPressGesture = LongPressGesture(target: self, action: { [unowned self] in
            handler(self)
        })

        longPressConfigurator?(longPressGesture)
        return self
    }

    @available(iOS 13.0, *)
    func onHover(hoverConfigurator: ((UIHoverGestureRecognizer) -> Void)? = nil, _ handler: @escaping (UIView) -> Void) -> Self {
        let hoverGesture = HoverGesture(target: self, action: { [unowned self] in
            handler(self)
        })

        hoverConfigurator?(hoverGesture)
        return self
    }

    func onSwipe(swipeConfigurator: ((UISwipeGestureRecognizer) -> Void)? = nil, _ handler: @escaping (UIView) -> Void) -> Self {
        let swipeGesture = SwipeGesture(target: self, action: { [unowned self] in
            handler(self)
        })

        swipeConfigurator?(swipeGesture)
        return self
    }

    func onRotation(rotationConfigurator: ((UIRotationGestureRecognizer) -> Void)? = nil, _ handler: @escaping (UIView) -> Void) -> Self {
        let rotationGesture = RotationGesture(target: self, action: { [unowned self] in
            handler(self)
        })

        rotationConfigurator?(rotationGesture)
        return self
    }

    func onPinch(pinchConfigurator: ((UIPinchGestureRecognizer) -> Void)? = nil, _ handler: @escaping (UIView) -> Void) -> Self {
        let pinchGesture = PinchGesture(target: self, action: { [unowned self] in
            handler(self)
        })

        pinchConfigurator?(pinchGesture)
        return self
    }

    func onScreenEdgePan(screenEdgePanConfigurator: ((UIScreenEdgePanGestureRecognizer) -> Void)? = nil, _ handler: @escaping (UIView) -> Void) -> Self {
        let screenEdgePanGesture = ScreenEdgePanGesture(target: self, action: { [unowned self] in
            handler(self)
        })

        screenEdgePanConfigurator?(screenEdgePanGesture)
        return self
    }

}
