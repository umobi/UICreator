//
//  Content+ViewCreator.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer
import SnapKit

public class _ContentView: ContentView {
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

public class Content: UIViewCreator {
    public typealias View = _ContentView

    public init(mode: View.ContentMode = .center, priority: ConstraintPriority = .required, content: @escaping () -> ViewCreator) {
        self.uiView = View(content().uiView, contentMode: mode, priority: priority)
    }
}

public func Center(priority: ConstraintPriority = .required, content: @escaping () -> ViewCreator) -> Content {
    return .init(mode: .center, priority: priority, content: content)
}

public func TopLeft(priority: ConstraintPriority = .required, content: @escaping () -> ViewCreator) -> Content {
    return .init(mode: .topLeft, priority: priority, content: content)
}

public func Top(priority: ConstraintPriority = .required, content: @escaping () -> ViewCreator) -> Content {
    return .init(mode: .top, priority: priority, content: content)
}

public func TopRight(priority: ConstraintPriority = .required, content: @escaping () -> ViewCreator) -> Content {
    return .init(mode: .topRight, priority: priority, content: content)
}

public func Left(priority: ConstraintPriority = .required, content: @escaping () -> ViewCreator) -> Content {
    return .init(mode: .left, priority: priority, content: content)
}

public func Right(priority: ConstraintPriority = .required, content: @escaping () -> ViewCreator) -> Content {
    return .init(mode: .right, priority: priority, content: content)
}

public func BottomLeft(priority: ConstraintPriority = .required, content: @escaping () -> ViewCreator) -> Content {
    return .init(mode: .bottomLeft, priority: priority, content: content)
}

public func Bottom(priority: ConstraintPriority = .required, content: @escaping () -> ViewCreator) -> Content {
    return .init(mode: .bottom, priority: priority, content: content)
}

public func BottomRight(priority: ConstraintPriority = .required, content: @escaping () -> ViewCreator) -> Content {
    return .init(mode: .bottomRight, priority: priority, content: content)
}

public extension UIViewCreator where View: ContentView {

    func content(mode: UIView.ContentMode) -> Self {
        (self.uiView as? View)?.apply(contentMode: mode)
        return self
    }

    func fitting(priority: ConstraintPriority) -> Self {
        (self.uiView as? View)?.apply(priority: priority)
        return self
    }
}
