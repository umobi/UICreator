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

public func Center(content: @escaping () -> UIView) -> Content {
    return .init(mode: .top, content: content)
}

public func TopLeft(content: @escaping () -> UIView) -> Content {
    return .init(mode: .top, content: content)
}

public func Top(content: @escaping () -> UIView) -> Content {
    return .init(mode: .top, content: content)
}

public func TopRight(content: @escaping () -> UIView) -> ContentView {
    return .init(mode: .topRight, content: content)
}

public func Left(content: @escaping () -> UIView) -> ContentView {
    return .init(mode: .left, content: content)
}

public func Right(content: @escaping () -> UIView) -> ContentView {
    return .init(mode: .right, content: content)
}

public func BottomLeft(content: @escaping () -> UIView) -> ContentView {
    return .init(mode: .bottomLeft, content: content)
}

public func Bottom(content: @escaping () -> UIView) -> ContentView {
    return .init(mode: .bottom, content: content)
}

public func BottomRight(content: @escaping () -> UIView) -> ContentView {
    return .init(mode: .bottomRight, content: content)
}

public extension ViewBuilder where Self: ContentView {

    init(mode: ContentMode = .center, content: @escaping () -> UIView) {
        self.init(content(), contentMode: mode)
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
