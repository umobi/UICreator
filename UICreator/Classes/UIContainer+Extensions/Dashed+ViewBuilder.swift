//
//  Dashed+ViewBuilder.swift
//  Pods-UICreator_Example
//
//  Created by brennobemoura on 22/12/19.
//

import Foundation
import UIKit
import UIContainer

extension Dashed {
    public convenience init(color: UIColor, pattern: [NSNumber] = [2, 3], _ content: () -> UIView) {
        self.init(content(), dash: pattern)
        _ = self.dash(color: color)
            .dash(lineWidth: 1)
    }

    public func dash(color: UIColor) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.apply(strokeColor: color)
                .refresh()
        }
    }

    public func dash(lineWidth width: CGFloat) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.apply(lineWidth: width)
                .refresh()
        }
    }

    public func dash(pattern: [NSNumber]) -> Self {
        self.appendBeforeRendering {
            _ = ($0 as? Self)?.apply(dashPattern: pattern)
                .refresh()
        }
    }
}
