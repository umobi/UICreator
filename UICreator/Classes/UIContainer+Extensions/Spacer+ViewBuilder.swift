//
//  Spacer+ViewBuilder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public extension Spacer {

    convenience init(top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat, content: @escaping () -> UIView) {
        self.init(content(), top: top, bottom: bottom, leading: leading, trailing: trailing)
    }

    convenience init(vertical: CGFloat, horizontal: CGFloat, content: @escaping () -> UIView) {
        self.init(content(), vertical: vertical, horizontal: horizontal)
    }

    convenience init(vertical: CGFloat, content: @escaping () -> UIView) {
        self.init(vertical: vertical, horizontal: 0, content: content)
    }

    convenience init(horizontal: CGFloat, content: @escaping () -> UIView) {
        self.init(vertical: 0, horizontal: horizontal, content: content)
    }

    convenience init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(UIView(), vertical: vertical, horizontal: horizontal)
    }

    convenience init(vertical: CGFloat) {
        self.init(vertical: vertical, horizontal: 0)
    }

    convenience init(horizontal: CGFloat) {
        self.init(vertical: 0, horizontal: horizontal)
    }

    convenience init(spacing: CGFloat, content: @escaping () -> UIView) {
        self.init(content(), spacing: spacing)
    }

    convenience init(spacing: CGFloat) {
        self.init(UIView(), spacing: spacing)
    }

    convenience init(content: @escaping () -> UIView) {
        self.init(content(), spacing: 0)
    }

    convenience init() {
        self.init(UIView(), spacing: 0)
    }
}
