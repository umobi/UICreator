//
//  Spacer+ViewBuilder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public class Spacer: SpacerView, ViewBuilder {

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

public extension ViewBuilder where Self: SpacerView {

    init(top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat, content: @escaping () -> UIView) {
        self.init(content(), margin: .init(top: top, bottom: bottom, leading: leading, trailing: trailing))
    }

    init(vertical: CGFloat, horizontal: CGFloat, content: @escaping () -> UIView) {
        self.init(content(), margin: .init(vertical: vertical, horizontal: horizontal))
    }

    init(vertical: CGFloat, content: @escaping () -> UIView) {
        self.init(vertical: vertical, horizontal: 0, content: content)
    }

    init(horizontal: CGFloat, content: @escaping () -> UIView) {
        self.init(vertical: 0, horizontal: horizontal, content: content)
    }

    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(UIView(), margin: .init(vertical: vertical, horizontal: horizontal))
    }

    init(vertical: CGFloat) {
        self.init(vertical: vertical, horizontal: 0)
    }

    init(horizontal: CGFloat) {
        self.init(vertical: 0, horizontal: horizontal)
    }

    init(spacing: CGFloat, content: @escaping () -> UIView) {
        self.init(content(), margin: .init(spacing: spacing))
    }

    init(spacing: CGFloat) {
        self.init(UIView(), margin: .init(spacing: spacing))
    }

    init(content: @escaping () -> UIView) {
        self.init(content(), margin: .init(spacing: 0))
    }

    init() {
        self.init(UIView(), margin: .init(spacing: 0))
    }
}
