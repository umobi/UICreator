//
//  Control.swift
//  Pods
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public protocol Control: UIControl {
    func onEvent(_ event: UIControl.Event, _ handler: @escaping (UIView) -> Void) -> Self
}

public extension ViewBuilder where Self: Control {
    func isEnabled(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.isEnabled = flag
        }
    }

    func contentHorizontal(alignment: ContentHorizontalAlignment) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.contentHorizontalAlignment = alignment
        }
    }

    func contentVertical(alignment: ContentVerticalAlignment) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.contentVerticalAlignment = alignment
        }
    }
}
