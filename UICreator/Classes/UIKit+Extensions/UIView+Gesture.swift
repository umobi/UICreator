//
//  UIView+Gesture.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

private var kTapGesture: UInt = 0

public extension UIView {

    private var tapGesture: Handler? {
        get { objc_getAssociatedObject(self, &kTapGesture) as? Handler }
        set { objc_setAssociatedObject(self, &kTapGesture, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    @objc private func tap() {
        self.tapGesture?.commit(in: self)
    }

    func onTap(tapConfigurator: ((UITapGestureRecognizer) -> Void)? = nil, _ handler: @escaping (UIView) -> Void) -> Self {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        tapConfigurator?(tap)
        self.addGestureRecognizer(tap)

        let oldTap = self.tapGesture
        self.tapGesture = .init({
            handler($0)
            oldTap?.commit(in: $0)
        })

        return self
    }
}
