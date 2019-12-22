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

extension Content: ViewBuilder {

    public convenience init(mode: ContentMode = .center, content: @escaping () -> UIView) {
        self.init(content(), contentMode: mode)
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

    public func content(mode: UIView.ContentMode) -> Content {
        self.apply(contentMode: mode)
        return self
    }

    public func fitting(priority: ConstraintPriority) -> Content {
        self.apply(priority: priority)
        return self
    }
}
