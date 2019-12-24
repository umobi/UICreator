//
//  UIView+Gesture.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

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

fileprivate extension UIView {

    @objc func pinch(_ sender: PinchGesture!) {
        sender.commit(sender)
    }

}

public extension ViewBuilder {

    func onPinchMaker(_ pinchConfigurator: (PinchGesture) -> PinchGesture) -> Self {
        self.addGestureRecognizer(pinchConfigurator(PinchGesture(target: self)))
        return self
    }

    func onPinch(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onPinchMaker { [unowned self] in
            $0.onRecognized { _ in
                handler(self)
            }
        }
    }
    
}
