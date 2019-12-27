//
//  ViewBuild+UIKit.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public extension UIViewCreator {
    func background(color: UIColor?) -> Self {
        return self.onNotRendered {
            $0.backgroundColor = color
        }
    }

    func tintColor(_ color: UIColor?) -> Self {
        self.onNotRendered {
            $0.tintColor = color
        }
    }

    func contentScaleFactor(_ scale: CGFloat) -> Self {
        self.onNotRendered {
            $0.contentScaleFactor = scale
        }
    }

    func zIndex(_ zIndex: CGFloat) -> Self {
        self.onNotRendered {
            $0.layer.zPosition = zIndex
        }
    }

    func border(color: UIColor?) -> Self {
        return self.onNotRendered {
            $0.layer.borderColor = color?.cgColor
        }
    }

    func border(width: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.borderWidth = width
        }
    }

    func corner(radius: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.cornerRadius = radius
        }
    }

    func alpha(_ constant: CGFloat) -> Self {
        return self.onNotRendered {
            $0.alpha = constant
        }
    }

    func `as`<UIElement: UIView>(_ reference: inout UIElement!) -> Self {
        reference = self.uiView as? UIElement
        return self
    }
}

public extension UIViewCreator {
    func shadow(radius: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.shadowRadius = radius
        }
    }

    func shadow(offset: CGSize) -> Self {
        return self.onNotRendered {
            $0.layer.shadowOffset = offset
        }
    }

    func shadow(ocupacity alpha: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.shadowOpacity = Float(alpha)
        }
    }

    func shadow(color: UIColor?) -> Self {
        return self.onNotRendered {
            $0.layer.shadowColor = color?.cgColor
        }
    }

    func clips(toBounds flag: Bool) -> Self {
        return self.onInTheScene {
            $0.clipsToBounds = flag
        }
    }

    func isOpaque(_ flag: Bool) -> Self {
        return self.onInTheScene {
            $0.isOpaque = flag
        }
    }

    func isHidden(_ flag: Bool) -> Self {
        return self.onInTheScene {
            $0.isHidden = flag
        }
    }
}
