//
//  Label.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public class Label: UILabel & Text {

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

public extension Text where Self: UILabel {
    func text(_ string: String?) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.text = string
        }
    }

    func text(_ attributedText: NSAttributedString?) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.attributedText = attributedText
        }
    }

    func text(color: UIColor?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.textColor = color
        }
    }

    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.font = font
            ($0 as? Self)?.isDynamicTextSize = isDynamicTextSize
        }
    }

    func text(scale: CGFloat) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.minimumScaleFactor = scale
            ($0 as? Self)?.adjustsFontSizeToFitWidth = scale != 1
        }
    }

    func text(alignment: NSTextAlignment) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.textAlignment = alignment
        }
    }

    func number(ofLines number: Int) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.numberOfLines = number
        }
    }
}

