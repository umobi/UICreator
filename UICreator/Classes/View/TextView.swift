//
//  TextView.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

class TextView: UITextView, Text, TextKeyboard, HasViewDelegate {
    func delegate(_ delegate: UITextViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }

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

public extension ViewBuilder where Self: UITextView {
    func isSelectable(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.isSelectable = flag
        }
    }

    #if os(iOS)
    func isEditable(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.isEditable = flag
        }
    }
    #endif
}

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

    func textContainer(insets: UIEdgeInsets) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.textContainerInset = insets
        }
    }
}

public extension Text where Self: UITextView {
    func adjustsFont(forContentSizeCategory flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.adjustsFontForContentSizeCategory = flag
        }
    }
}

public extension TextKeyboard where Self: UITextView {
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


    func keyboard(type: UIKeyboardType) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.keyboardType = type
        }
    }

    func keyboard(appearance: UIKeyboardAppearance) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.keyboardAppearance = appearance
        }
    }
}

public extension TextKeyboard where Self: UITextView {

    func returnKey(type: UIReturnKeyType) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.returnKeyType = type
        }
    }

    func secureText(_ flag: Bool = true) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.isSecureTextEntry = flag
        }
    }

    @available(iOS 12, tvOS 12, *)
    func passwordRules(_ passwordRules: UITextInputPasswordRules?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.passwordRules = passwordRules
        }
    }
}

@available(iOS 11, tvOS 11, *)
public extension TextKeyboard where Self: UITextView {

    func smartDashes(type: UITextSmartDashesType) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.smartDashesType = type
        }
    }

    func smartQuotes(type: UITextSmartQuotesType) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.smartQuotesType = type
        }
    }

    func smartInsertDelete(type: UITextSmartInsertDeleteType) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.smartInsertDeleteType = type
        }
    }
}

public extension TextKeyboard where Self: UITextView {
    func textContent(type: UITextContentType) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.textContentType = type
        }
    }

    func inputView(content: @escaping () -> UIInputView) -> Self {
       self.appendRendered {
           ($0 as? Self)?.inputView = content()
       }
    }

    func input(delegate: UITextInputDelegate) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.inputDelegate = delegate
        }
    }

    func typing(attributes: [NSAttributedString.Key : Any]?) -> Self {
       self.appendBeforeRendering {
            ($0 as? Self)?.typingAttributes = attributes ?? [:]
       }
   }
}

