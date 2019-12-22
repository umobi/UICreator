//
//  Spacer+ViewBuilder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

extension Spacer: ViewBuilder {

    public convenience init(top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat, content: @escaping () -> UIView) {
        self.init(content(), top: top, bottom: bottom, leading: leading, trailing: trailing)
    }

    public convenience init(vertical: CGFloat, horizontal: CGFloat, content: @escaping () -> UIView) {
        self.init(content(), vertical: vertical, horizontal: horizontal)
    }

    public convenience init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(UIView(), vertical: vertical, horizontal: horizontal)
    }

    public convenience init(vertical: CGFloat) {
        self.init(vertical: vertical, horizontal: 0)
    }

    public convenience init(horizontal: CGFloat) {
        self.init(vertical: 0, horizontal: horizontal)
    }

    public convenience init(spacing: CGFloat, content: @escaping () -> UIView) {
        self.init(content(), spacing: spacing)
    }

    public convenience init(spacing: CGFloat) {
        self.init(UIView(), spacing: spacing)
    }

    public convenience init(content: @escaping () -> UIView) {
        self.init(content(), spacing: 0)
    }

    public convenience init() {
        self.init(UIView(), spacing: 0)
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
