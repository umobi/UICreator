//
//  UIView+Gesture.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

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

fileprivate extension UIView {

    @objc func swipe(_ sender: SwipeGesture!) {
        sender.commit(sender)
    }
}

public extension ViewBuilder {

    func onSwipeMaker(_ swipeConfigurator: (SwipeGesture) -> SwipeGesture) -> Self {
        self.addGestureRecognizer(swipeConfigurator(SwipeGesture(target: self)))
        return self
    }

    func onSwipe(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onSwipeMaker { [unowned self] in
            $0.onRecognized { _ in
                handler(self)
            }
        }
    }
}
