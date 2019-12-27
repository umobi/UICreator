//
//  Spacer+ViewCreator.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public class _SpacerView: SpacerView {
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

public class Spacer: UIViewCreator {
    public typealias View = _SpacerView

    public required init(margin: View.Margin, content: @escaping () -> ViewCreator) {
        self.uiView = View.init(content().uiView, margin: margin)
    }
}

public class Empty: ViewCreator {
    public typealias View = UIView

    public init() {
        self.uiView = .init()
    }
}

public extension Spacer {
    convenience init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(margin: .init(vertical: vertical, horizontal: horizontal)) {
            Empty()
        }
    }

    convenience init(vertical: CGFloat) {
        self.init(margin: .init(vertical: vertical, horizontal: 0)) {
            Empty()
        }
    }

    convenience init(horizontal: CGFloat) {
        self.init(margin: .init(vertical: 0, horizontal: horizontal)) {
           Empty()
       }
    }

    convenience init() {
        self.init(margin: .init(spacing: 0)) {
            Empty()
        }
    }

    convenience init(spacing: CGFloat) {
        self.init(margin: .init(spacing: spacing)) {
            Empty()
        }
    }
}

public extension Spacer {
    convenience init(top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat, content: @escaping () -> Content) {
        self.init(margin: .init(top: top, bottom: bottom, leading: leading, trailing: trailing), content: content)
    }

    convenience init(vertical: CGFloat, horizontal: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(vertical: vertical, horizontal: horizontal), content: content)
    }

    convenience init(vertical: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(vertical: vertical, horizontal: 0), content: content)
    }

    convenience init(horizontal: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(vertical: 0, horizontal: horizontal), content: content)
    }

    convenience init(spacing: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(spacing: spacing), content: content)
    }

    convenience init(content: @escaping () -> ViewCreator) {
        self.init(margin: .init(spacing: 0), content: content)
    }
}
