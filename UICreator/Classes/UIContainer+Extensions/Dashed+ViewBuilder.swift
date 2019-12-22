//
//  Dashed+ViewBuilder.swift
//  Pods-UICreator_Example
//
//  Created by brennobemoura on 22/12/19.
//

import Foundation
import UIKit
import UIContainer

extension Dashed: ViewBuilder {
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

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.commitNotRendered()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }
}
