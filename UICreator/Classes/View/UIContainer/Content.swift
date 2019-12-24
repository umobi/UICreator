//
//  Content+ViewBuilder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer
import SnapKit

public class Content: ContentView, ViewBuilder {
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

public func Center(priority: ConstraintPriority = .required, content: @escaping () -> UIView) -> Content {
    return .init(mode: .center, priority: priority, content: content)
}

public func TopLeft(priority: ConstraintPriority = .required, content: @escaping () -> UIView) -> Content {
    return .init(mode: .topLeft, priority: priority, content: content)
}

public func Top(priority: ConstraintPriority = .required, content: @escaping () -> UIView) -> Content {
    return .init(mode: .top, priority: priority, content: content)
}

public func TopRight(priority: ConstraintPriority = .required, content: @escaping () -> UIView) -> Content {
    return .init(mode: .topRight, priority: priority, content: content)
}

public func Left(priority: ConstraintPriority = .required, content: @escaping () -> UIView) -> Content {
    return .init(mode: .left, priority: priority, content: content)
}

public func Right(priority: ConstraintPriority = .required, content: @escaping () -> UIView) -> Content {
    return .init(mode: .right, priority: priority, content: content)
}

public func BottomLeft(priority: ConstraintPriority = .required, content: @escaping () -> UIView) -> Content {
    return .init(mode: .bottomLeft, priority: priority, content: content)
}

public func Bottom(priority: ConstraintPriority = .required, content: @escaping () -> UIView) -> Content {
    return .init(mode: .bottom, priority: priority, content: content)
}

public func BottomRight(priority: ConstraintPriority = .required, content: @escaping () -> UIView) -> Content {
    return .init(mode: .bottomRight, priority: priority, content: content)
}

public extension ViewBuilder where Self: ContentView {

    init(mode: ContentMode = .center, content: @escaping () -> UIView) {
        self.init(content(), contentMode: mode)
    }

    init(mode: ContentMode = .center, priority: ConstraintPriority = .required, content: @escaping () -> UIView) {
        self.init(content(), contentMode: mode, priority: priority)
    }

    func content(mode: UIView.ContentMode) -> Self {
        self.apply(contentMode: mode)
        return self
    }

    func fitting(priority: ConstraintPriority) -> Self {
        self.apply(priority: priority)
        return self
    }
}
