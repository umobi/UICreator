//
//  Content+ViewBuilder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public extension Content: ViewBuilder {

    convenience init(mode: ContentMode = .center, content: @escaping () -> UIView) {
        self.init(content(), contentMode: mode)
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

    public var body: UIView {
        return self
    }

    func content(mode: UIView.ContentMode) -> Content {
        self.apply(contentMode: mode)
        return self
    }

    func fitting(priority: ConstraintPriority) -> Content {
        self.apply(priority: priority)
        return self
    }
}
