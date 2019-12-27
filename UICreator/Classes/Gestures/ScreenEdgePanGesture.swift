//
//  UIView+Gesture.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

#if os(iOS)
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

    @objc func screenEdgePan(_ sender: ScreenEdgePanGesture!) {
        sender.commit(sender)
    }
}

public extension UIViewCreator {
    func onScreenEdgePanMaker(_ screenEdgePanConfigurator: (ScreenEdgePanGesture) -> ScreenEdgePanGesture) -> Self {
        self.uiView.addGestureRecognizer(screenEdgePanConfigurator(ScreenEdgePanGesture(target: self.uiView)))
        return self
    }

    func onScreenEdgePan(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onScreenEdgePanMaker {
            $0.onRecognized { _ in
                handler(self.uiView)
            }
        }
    }
}
#endif
