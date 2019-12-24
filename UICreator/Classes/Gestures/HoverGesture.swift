//
//  UIView+Gesture.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

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

fileprivate extension UIView {

    @available(iOS 13.0, *)
    @objc func hover(_ sender: HoverGesture!) {
        sender.commit(sender)
    }
}

public extension ViewBuilder {

    @available(iOS 13.0, *)
    func onHoverMaker(_ hoverConfigurator: (HoverGesture) -> HoverGesture) -> Self {
        self.addGestureRecognizer(hoverConfigurator(HoverGesture(target: self)))
        return self
    }

    @available(iOS 13.0, *)
    func onHover(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onHoverMaker { [unowned self] in
            $0.onRecognized { _ in
                handler(self)
            }
        }
    }
}
