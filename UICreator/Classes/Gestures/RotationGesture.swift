//
//  UIView+Gesture.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

#if os(iOS)
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

fileprivate extension UIView {

    @objc func rotation(_ sender: RotationGesture!) {
        sender.commit(sender)
    }

}

public extension UIViewCreator {

    func onRotationMaker(_ rotationConfigurator: (RotationGesture) -> RotationGesture) -> Self {
        self.uiView.addGestureRecognizer(rotationConfigurator(RotationGesture(target: self.uiView)))
        return self
    }

    func onRotation(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onRotationMaker {
            $0.onRecognized { _ in
                handler(self.uiView)
            }
        }
    }
}
#endif
