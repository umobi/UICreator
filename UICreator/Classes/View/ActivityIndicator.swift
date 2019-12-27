//
//  ActivityIndicator.swift
//  UICreator
//
//  Created by brennobemoura on 26/12/19.
//

import Foundation
import UIKit

public class ActivityIndicatorView: UIActivityIndicatorView {
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

public class Activity: UIViewCreator {
    public typealias View = ActivityIndicatorView

    public init(style: View.Style) {
        self.uiView = View.init(builder: self)
        (self.uiView as? View)?.style = style
    }
}

public extension UIViewCreator where View: UIActivityIndicatorView {

    func color(_ color: UIColor) -> Self {
        self.onNotRendered {
            ($0 as? View)?.color = color
        }
    }

    func hidesWhenStopped(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.hidesWhenStopped = flag
        }
    }
}
