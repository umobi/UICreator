//
//  ActivityIndicator.swift
//  UICreator
//
//  Created by brennobemoura on 26/12/19.
//

import Foundation
import UIKit

public class Activity: UIActivityIndicatorView, ViewBuilder {
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

public extension ViewBuilder where Self: UIActivityIndicatorView {
    init(style: Style) {
        self.init(frame: .zero)
        self.style = style
    }

    func color(_ color: UIColor) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.color = color
        }
    }

    func hidesWhenStopped(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.hidesWhenStopped = flag
        }
    }
}
