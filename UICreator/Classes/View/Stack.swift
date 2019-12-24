//
//  Stack.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public class Stack: UIStackView, ViewBuilder {
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

public extension ViewBuilder where Self: UIStackView {
    init(axis: NSLayoutConstraint.Axis = .vertical, _ subview: Subview) {
        self.init(arrangedSubviews: subview.views)
        _ = self.axis(axis)
    }

    init(axis: NSLayoutConstraint.Axis = .vertical, _ views: UIView...) {
        self.init(arrangedSubviews: views)
        _ = self.axis(axis)
    }

    init(axis: NSLayoutConstraint.Axis = .vertical, _ views: [UIView]) {
        self.init(arrangedSubviews: views)
        _ = self.axis(axis)
    }

    var watchingViews: [UIView] {
        return self.arrangedSubviews
    }

    func spacing(_ constant: CGFloat) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.spacing = constant
        }
    }

    func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.axis = axis
        }
    }

    func distribution(_ distribution: Distribution) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.distribution = distribution
        }
    }
}
