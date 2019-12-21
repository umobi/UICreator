//
//  Text.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation

public protocol Text: ViewBuilder {
    func text(_ string: String?) -> Self
    func text(_ attributedText: NSAttributedString?) -> Self

    func text(color: UIColor?) -> Self
    func font(_ font: UIFont, isDynamicTextSize: Bool) -> Self

    func text(scale: CGFloat) -> Self
    func text(alignment: NSTextAlignment) -> Self

    init(_ text: String?)
    init(_ attributedText: NSAttributedString?)
}

public extension Text {
    init(_ text: String?) {
        self.init()
        _ = self.text(text)
    }

    init(_ attributedText: NSAttributedString?) {
        self.init()
        _ = self.text(attributedText)
    }

    func text(scale: CGFloat) -> Self {
        print("[warning] text(scale:) not implemented")
        return self
    }
}
