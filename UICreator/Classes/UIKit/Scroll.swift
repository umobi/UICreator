//
//  Scroll.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public extension Scroll: ViewBuilder, HasViewDelegate {
    func delegate(_ delegate: UIScrollViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }

    convenience init(axis: Axis = .vertical, content: @escaping () -> UIView) {
        self.init(content(), axis: axis)
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
