//
//  UIButton+ViewBuilder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public extension ViewBuilder where Self: UIButton {
    convenience init(_ title: String?, type: UIButton.ButtonType? = nil) {
        if let type = type {
            self.init(type: type)
            _ = self.title(title)
            return
        }

        self.init(frame: .zero)
        _ = self.title(title)
    }

    func title(_ string: String?, for state: UIControl.State = .normal) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.setTitle(string, for: state)
        }
    }

    func title(_ attributedText: NSAttributedString?, for state: UIControl.State = .normal) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.setTitle(attributedText?.string, for: state)
            ($0 as? Self)?.titleLabel?.attributedText = attributedText
        }
    }

    func title(color: UIColor?, for state: UIControl.State = .normal) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.setTitleColor(color, for: state)
        }
    }

    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.titleLabel?.font = font
            ($0 as? Self)?.titleLabel?.isDynamicTextSize = isDynamicTextSize
        }
    }

    func onTouchInside(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.appendRendered {
            _ = ($0 as? Self)?.onEvent(.touchUpInside, handler)
        }
    }
}

