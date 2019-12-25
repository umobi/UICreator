//
//  UIView+Gesture.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

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

#if os(iOS)
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
#endif

fileprivate extension UIView {

    @objc func pan(_ sender: PanGesture!) {
        sender.commit(sender)
    }

}

public extension ViewBuilder {

    func onPanMaker(_ panConfigurator: (PanGesture) -> PanGesture) -> Self {
        self.addGestureRecognizer(panConfigurator(PanGesture(target: self)))
        return self
    }

    func onPan(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onPanMaker { [unowned self] in
            $0.onRecognized { _ in
                handler(self)
            }
        }
    }
}
