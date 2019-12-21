//
//  UITextField+Text.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public extension Text where Self: UITextField {
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

    func placeholder(color: UIColor?) -> Self {
        self.appendRendered {
            guard let label = $0 as? Self else {
                return
            }

            let muttable = NSMutableAttributedString(attributedString: label.attributedPlaceholder ?? .init(string: label.placeholder ?? ""))
            muttable.addAttribute(.foregroundColor, value: color ?? .clear, range: (muttable.string as NSString).range(of: muttable.string))
            label.attributedPlaceholder = muttable
        }
    }

    func placeholder(font: UIFont) -> Self {
        self.appendRendered {
            guard let label = $0 as? Self else {
                return
            }

            let muttable = NSMutableAttributedString(attributedString: label.attributedPlaceholder ?? .init(string: label.placeholder ?? ""))
            muttable.addAttribute(.font, value: font, range: (muttable.string as NSString).range(of: muttable.string))
            label.attributedPlaceholder = muttable
        }
    }

    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.font = font
            ($0 as? Self)?.adjustsFontForContentSizeCategory = isDynamicTextSize
        }
    }

    func text(scale: CGFloat) -> Self {
        return self.appendRendered {
            guard let font = ($0 as? Self)?.font else {
                print("[warning] text scale cannot be applied without font")
                return
            }

            ($0 as? Self)?.minimumFontSize = font.pointSize
            ($0 as? Self)?.adjustsFontSizeToFitWidth = scale != 1
        }
    }

    func text(alignment: NSTextAlignment) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.textAlignment = alignment
        }
    }
}

public extension Text where Self: UITextField {

    init(placeholder text: String?) {
        self.init()
        _ = self.placeholder(text)
    }

    init(placeholder attributed: NSAttributedString?) {
        self.init()
        _ = self.placeholder(attributed)
    }

    func placeholder(_ string: String?) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.placeholder = string
        }
    }

    func placeholder(_ attributedText: NSAttributedString?) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.attributedPlaceholder = attributedText
        }
    }

    func border(style: UITextField.BorderStyle) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.borderStyle = style
        }
    }
}

public extension Text where Self: UITextField {
    func autocapitalization(type: UITextAutocapitalizationType) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.autocapitalizationType = type
        }
    }

    func autocorrection(type: UITextAutocorrectionType) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.autocorrectionType = type
        }
    }

    func clearButton(mode: ViewMode) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.clearButtonMode = mode
        }
    }

    func clears(onBegin flag: Bool) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.clearsOnBeginEditing = flag
        }
    }

    func clears(onInsertion flag: Bool) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.clearsOnInsertion = flag
        }
    }

    func keyboard(_ type: UIKeyboardType) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.keyboardType = type
        }
    }

    func keyboard(appearance: UIKeyboardAppearance) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.keyboardAppearance = appearance
        }
    }

    func secureText(_ flag: Bool = true) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.isSecureTextEntry = flag
        }
    }
}

public extension Text where Self: UITextField {
    func onEditingDidBegin(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onEvent(.editingDidBegin, handler)
    }

    func onEditingChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onEvent(.editingChanged, handler)
    }

    func onEditingDidEnd(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onEvent(.editingDidEnd, handler)
    }

    func onEditingDidEndOnExit(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onEvent(.editingDidEndOnExit, handler)
    }

    func onAllEditingEvents(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onEvent(.allEditingEvents, handler)
    }
}

public extension Text where Self: UITextField {
    func leftView(_ mode: ViewMode = .always, content: @escaping () -> UIView) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.leftView = Host(content)
            ($0 as? Self)?.leftViewMode = mode
        }
    }

    func rightView(_ mode: ViewMode = .always, content: @escaping () -> UIView) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.rightView = Host(content)
            ($0 as? Self)?.rightViewMode = mode
        }
    }
}
