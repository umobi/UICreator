//
//  Text.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation

public protocol TextElement: UIViewCreator {
    func text(_ string: String?) -> Self
    func text(_ attributedText: NSAttributedString?) -> Self

    func text(color: UIColor?) -> Self
    func font(_ font: UIFont, isDynamicTextSize: Bool) -> Self

    func text(scale: CGFloat) -> Self
    func text(alignment: NSTextAlignment) -> Self

    init(_ text: String?)
    init(_ attributedText: NSAttributedString?)

    func adjustsFont(forContentSizeCategory flag: Bool) -> Self
}

public extension TextElement {
    func text(scale: CGFloat) -> Self {
        print("[warning] text(scale:) not implemented")
        return self
    }
}
