//
//  UIView+Gesture.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

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

fileprivate extension UIView {

    @objc func longPress(_ sender: LongPressGesture!) {
        sender.commit(sender)
    }
}

public extension UIViewCreator {

    func onLongPressMaker(_ longPressConfigurator: (LongPressGesture) -> LongPressGesture) -> Self {
        self.uiView.addGestureRecognizer(longPressConfigurator(LongPressGesture(target: self.uiView)))
        return self
    }

    func onLongPress(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onLongPressMaker {
            $0.onRecognized { _ in
                handler(self.uiView)
            }
        }
    }
}
