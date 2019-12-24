//
//  UIView+Gesture.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

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

fileprivate extension UIView {
    @objc func tap(_ sender: TapGesture!) {
        sender.commit(sender)
    }
}

public extension ViewBuilder {
    func onTapMaker(_ tapConfigurator: (TapGesture) -> TapGesture) -> Self {
        self.addGestureRecognizer(tapConfigurator(tapConfigurator(TapGesture(target: self))))
        return self
    }

    func onTap(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onTapMaker { [unowned self] in
            $0.onRecognized { _ in
                handler(self)
            }
        }
    }
}
