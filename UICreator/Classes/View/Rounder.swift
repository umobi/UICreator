//
//  Rounder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public class _RounderView: RounderView {
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

public class Rounder: UIViewCreator {
    public typealias View = _RounderView

    public init(radius: CGFloat, content: @escaping () -> ViewCreator) {
        self.uiView = View.init(content().uiView, radius: radius)
    }
}

public func Circle(content: @escaping () -> ViewCreator) -> Rounder {
    return .init(radius: 0.5, content: content)
}
