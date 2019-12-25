//
//  Rounder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public extension ViewBuilder where Self: RounderView {
    init(radius: CGFloat, content: @escaping () -> UIView) {
        self.init(content(), radius: radius)
    }
}

public class Rounder: RounderView, ViewBuilder {
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

public func Circle(content: @escaping () -> UIView) -> Rounder {
    return .init(radius: 0.5, content: content)
}
