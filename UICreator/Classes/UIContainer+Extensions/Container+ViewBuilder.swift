//
//  Container+ViewBuilder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public class ContainerView<View: UIView & ContainerViewParent>: UIContainer.ContainerView<View>, ViewBuilder {

    convenience init(_ content: @escaping () -> View) {
        self.init()
        _ = self.appendInTheScene {
            ($0 as? Self)?.prepareContainer(inside: ($0 as? Self)?.viewController, loadHandler: content)
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

public class Container<View: UIViewController>: UIContainer.Container<View>, ViewBuilder {
    public var watchingViews: [UIView] {
        return []
    }

    convenience init(_ content: @escaping () -> View) {
        self.init()
        _ = self.appendInTheScene {
            ($0 as? Self)?.prepareContainer(inside: ($0 as? Self)?.viewController, loadHandler: content)
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
