//
//  Dashed+ViewCreator.swift
//  Pods-UICreator_Example
//
//  Created by brennobemoura on 22/12/19.
//

import Foundation
import UIKit
import UIContainer

public class _DashedView: DashedView {
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

public class Dashed: UIViewCreator {
    public typealias View = _DashedView

    public init(color: UIColor, pattern: [NSNumber] = [2, 3], content: () -> ViewCreator) {
        self.uiView = View.init(content().uiView, dash: pattern)
            .apply(strokeColor: color)
            .apply(lineWidth: 1)
    }
}

extension UIViewCreator where View: DashedView {

    public func dash(color: UIColor) -> Self {
        self.onNotRendered {
            ($0 as? View)?.apply(strokeColor: color)
                .refresh()
        }
    }

    public func dash(lineWidth width: CGFloat) -> Self {
        self.onNotRendered {
            ($0 as? View)?.apply(lineWidth: width)
                .refresh()
        }
    }

    public func dash(pattern: [NSNumber]) -> Self {
        self.onNotRendered {
            _ = ($0 as? View)?.apply(dashPattern: pattern)
                .refresh()
        }
    }
}
