//
//  Control.swift
//  Pods
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public protocol Control: ViewCreator {
    func onEvent(_ event: UIControl.Event, _ handler: @escaping (UIView) -> Void) -> Self
}

public extension UIViewCreator where Self: Control, View: UIControl {
    func isEnabled(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? UIControl)?.isEnabled = flag
        }
    }

    func contentHorizontal(alignment: UIControl.ContentHorizontalAlignment) -> Self {
        self.onNotRendered {
            ($0 as? UIControl)?.contentHorizontalAlignment = alignment
        }
    }

    func contentVertical(alignment: UIControl.ContentVerticalAlignment) -> Self {
        self.onNotRendered {
            ($0 as? UIControl)?.contentVerticalAlignment = alignment
        }
    }
}
