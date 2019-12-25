//
//  ViewBuild+UIKit.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public extension ViewBuilder {
    func background(color: UIColor?) -> Self {
        return self.appendBeforeRendering {
            $0.backgroundColor = color
        }
    }

    func tintColor(_ color: UIColor?) -> Self {
        self.appendBeforeRendering {
            $0.tintColor = color
        }
    }

    func zIndex(_ zIndex: CGFloat) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.layer.zPosition = zIndex
        }
    }

    func border(color: UIColor?) -> Self {
        return self.appendBeforeRendering {
            $0.layer.borderColor = color?.cgColor
        }
    }

    func border(width: CGFloat) -> Self {
        return self.appendBeforeRendering {
            $0.layer.borderWidth = width
        }
    }

    func corner(radius: CGFloat) -> Self {
        return self.appendBeforeRendering {
            $0.layer.cornerRadius = radius
        }
    }

    func alpha(_ constant: CGFloat) -> Self {
        return self.appendBeforeRendering {
            $0.alpha = constant
        }
    }

    func `as`<UI: UIView>(_ reference: inout UI!) -> Self {
        reference = self as? UI
        return self
    }
}

public extension ViewBuilder {
    func shadow(radius: CGFloat) -> Self {
        return self.appendBeforeRendering {
            $0.layer.shadowRadius = radius
        }
    }

    func shadow(offset: CGSize) -> Self {
        return self.appendBeforeRendering {
            $0.layer.shadowOffset = offset
        }
    }

    func shadow(ocupacity alpha: CGFloat) -> Self {
        return self.appendBeforeRendering {
            $0.layer.shadowOpacity = Float(alpha)
        }
    }

    func shadow(color: UIColor?) -> Self {
        return self.appendBeforeRendering {
            $0.layer.shadowColor = color?.cgColor
        }
    }

    func clips(toBounds flag: Bool) -> Self {
        return self.appendInTheScene {
            $0.clipsToBounds = flag
        }
    }

    func isOpaque(_ flag: Bool) -> Self {
        return self.appendInTheScene {
            $0.isOpaque = flag
        }
    }

    func isHidden(_ flag: Bool) -> Self {
        return self.appendInTheScene {
            $0.isHidden = flag
        }
    }
}
