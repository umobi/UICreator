//
//  Gradient+ViewCreator.swift
//  Pods-UICreator_Example
//
//  Created by brennobemoura on 22/12/19.
//

import Foundation
import UIKit
import UIContainer

public class _GradientView: GradientView {
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

public class Gradient: UIViewCreator {
    public typealias View = _GradientView

    public init(_ colors: [UIColor], direction: View.Direction = .right) {
        self.uiView = View.init(builder: self)
        (self.uiView as? View)?.colors = colors
        (self.uiView as? View)?.direction = direction
    }

    public convenience init(_ colors: UIColor..., direction: View.Direction = .right) {
        self.init(colors, direction: direction)
    }
}

public extension UIViewCreator where View: GradientView {

    func colors(_ colors: UIColor...) -> Self {
        self.onNotRendered {
            ($0 as? View)?.colors = colors
        }
    }

    func colors(_ colors: [UIColor]) -> Self {
        self.onNotRendered {
            ($0 as? View)?.colors = colors
        }
    }

    func direction(_ direction: View.Direction) -> Self {
        self.onNotRendered {
            ($0 as? View)?.direction = direction
        }
    }

    func animation(_ layerHandler: @escaping (CAGradientLayer) -> Void) -> Self {
        self.onRendered {
            ($0 as? View)?.animates {
                layerHandler($0)
            }
        }
    }
}
