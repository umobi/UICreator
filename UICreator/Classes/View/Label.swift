//
//  Label.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public class _Label: UILabel {
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

public class Label: UIViewCreator, TextElement {
    public typealias View = _Label

    required public init(_ text: String?) {
        self.uiView = View.init(builder: self)
        (self.uiView as? View)?.text = text
    }

    required public init(_ attributedText: NSAttributedString?) {
        self.uiView = View.init(builder: self)
        (self.uiView as? View)?.attributedText = attributedText
    }
}

public extension TextElement where View: UILabel {
    func text(_ string: String?) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.text = string
        }
    }

    func text(_ attributedText: NSAttributedString?) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.attributedText = attributedText
        }
    }

    func text(color: UIColor?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.textColor = color
        }
    }

    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.font = font
            ($0 as? View)?.isDynamicTextSize = isDynamicTextSize
        }
    }

    func text(scale: CGFloat) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.minimumScaleFactor = scale
            ($0 as? View)?.adjustsFontSizeToFitWidth = scale != 1
        }
    }

    func text(alignment: NSTextAlignment) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.textAlignment = alignment
        }
    }

    func number(ofLines number: Int) -> Self {
        self.onNotRendered {
            ($0 as? View)?.numberOfLines = number
        }
    }
}

public extension TextElement where View: UILabel {
    func adjustsFont(forContentSizeCategory flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontForContentSizeCategory = flag
        }
    }

    func adjustsFontSize(toFitWidth flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontSizeToFitWidth = flag
        }
    }
}
