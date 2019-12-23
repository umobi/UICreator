//
//  Content+ViewBuilder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer
import SnapKit

extension Content {

    public convenience init(mode: ContentMode = .center, content: @escaping () -> UIView) {
        self.init(content(), contentMode: mode)
    }

    public func content(mode: UIView.ContentMode) -> Content {
        self.apply(contentMode: mode)
        return self
    }

    public func fitting(priority: ConstraintPriority) -> Content {
        self.apply(priority: priority)
        return self
    }
}
