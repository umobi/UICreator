//
//  Stack.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public class StackView: UIStackView {
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

    public override var watchingViews: [UIView] {
        return self.arrangedSubviews
    }
}

public class Stack: UIViewCreator {
    public typealias View = StackView

    public init(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0,_ subviews: Subview) {
        self.uiView = View.init(arrangedSubviews: subviews.views.map {
            $0.uiView
        })
        (self.uiView as? View)?.axis = axis
        (self.uiView as? View)?.spacing = spacing
    }

    public init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, _ views: ViewCreator...) {
        self.uiView = View.init(arrangedSubviews: views.map {
            $0.uiView
        })
        (self.uiView as? View)?.axis = axis
        (self.uiView as? View)?.spacing = spacing
    }

    public init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, _ views: [ViewCreator]) {
        self.uiView = View.init(arrangedSubviews: views.map {
            $0.uiView
        })
        (self.uiView as? View)?.axis = axis
        (self.uiView as? View)?.spacing = spacing
    }
}

public func HStack(spacing: CGFloat = 0, _ subviews: Subview) -> Stack {
    return .init(axis: .horizontal, spacing: spacing, subviews)
}

public func VStack(spacing: CGFloat = 0, _ subviews: Subview) -> Stack {
    return .init(axis: .vertical, spacing: spacing, subviews)
}

public func HStack(spacing: CGFloat = 0, _ subviews: ViewCreator...) -> Stack {
    return .init(axis: .horizontal, spacing: spacing, subviews)
}

public func VStack(spacing: CGFloat = 0, _ subviews: ViewCreator...) -> Stack {
    return .init(axis: .vertical, spacing: spacing, subviews)
}

public func HStack(spacing: CGFloat = 0, _ subviews: [ViewCreator]) -> Stack {
    return .init(axis: .horizontal, spacing: spacing, subviews)
}

public func VStack(spacing: CGFloat = 0, _ subviews: [ViewCreator]) -> Stack {
    return .init(axis: .vertical, spacing: spacing, subviews)
}

public extension UIViewCreator where View: UIStackView {

    func spacing(_ constant: CGFloat) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.spacing = constant
        }
    }

    func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.axis = axis
        }
    }

    func distribution(_ distribution: View.Distribution) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.distribution = distribution
        }
    }

    func alignment(_ alignment: View.Alignment) -> Self {
        self.onNotRendered {
            ($0 as? View)?.alignment = alignment
        }
    }
}
