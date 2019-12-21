//
//  Rounder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public extension Rounder: ViewBuilder {
    convenience init(radius: CGFloat, content: @escaping () -> UIView) {
        self.init(content(), radius: radius)
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.commitNotRendered()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }
}
