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

public func HStack(spacing: CGFloat = 0, _ subviews: Subview) -> Stack {
    return .init(axis: .horizontal, spacing: spacing, subviews)
}

public func VStack(spacing: CGFloat = 0, _ subviews: Subview) -> Stack {
    return .init(axis: .vertical, spacing: spacing, subviews)
}

public func HStack(spacing: CGFloat = 0, _ subviews: UIView...) -> Stack {
    return .init(axis: .horizontal, spacing: spacing, subviews)
}

public func VStack(spacing: CGFloat = 0, _ subviews: UIView...) -> Stack {
    return .init(axis: .vertical, spacing: spacing, subviews)
}

public func HStack(spacing: CGFloat = 0, _ subviews: [UIView]) -> Stack {
    return .init(axis: .horizontal, spacing: spacing, subviews)
}

public func VStack(spacing: CGFloat = 0, _ subviews: [UIView]) -> Stack {
    return .init(axis: .vertical, spacing: spacing, subviews)
}

public extension ViewBuilder where Self: UIStackView {
    init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, _ subview: Subview) {
        self.init(arrangedSubviews: subview.views)
        self.axis = axis
        self.spacing = spacing
    }

    init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, _ views: UIView...) {
        self.init(arrangedSubviews: views)
        self.axis = axis
        self.spacing = spacing
    }

    init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, _ views: [UIView]) {
        self.init(arrangedSubviews: views)
        self.axis = axis
        self.spacing = spacing
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

    func alignment(_ alignment: Alignment) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.alignment = alignment
        }
    }
}
