//
//  UITextView+Text.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public extension Text where Self: UITextView {

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
            ($0 as? Self)?.adjustsFontForContentSizeCategory = isDynamicTextSize
        }
    }

    func text(alignment: NSTextAlignment) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.textAlignment = alignment
        }
    }
}
