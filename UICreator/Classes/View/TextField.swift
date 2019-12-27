//
//  TextField.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public class TextField: UITextField {
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

public class Field: UIViewCreator, TextElement, TextKeyboard, Control, HasViewDelegate {
    public typealias View = TextField
    
    public func delegate(_ delegate: UITextFieldDelegate?) -> Self {
        (self.uiView as? View)?.delegate = delegate
        return self
    }

    required public init(_ text: String?) {
        self.uiView = View.init(builder: self)
        (self.uiView as? View)?.text = text
    }

    required public init(_ attributedText: NSAttributedString?) {
        self.uiView = View.init(builder: self)
        (self.uiView as? View)?.attributedText = attributedText
    }

    required public init(placeholder text: String?) {
        self.uiView = View.init(builder: self)
        _ = self.placeholder(text)
    }

    required public init(placeholder attributed: NSAttributedString?) {
        self.uiView = View.init(builder: self)
        _ = self.placeholder(attributed)
    }
}

public extension TextElement where View: UITextField {
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

    func placeholder(color: UIColor?) -> Self {
        self.onRendered {
            guard let label = $0 as? View else {
                return
            }

            let muttable = NSMutableAttributedString(attributedString: label.attributedPlaceholder ?? .init(string: label.placeholder ?? ""))
            muttable.addAttribute(.foregroundColor, value: color ?? .clear, range: (muttable.string as NSString).range(of: muttable.string))
            label.attributedPlaceholder = muttable
        }
    }

    func placeholder(font: UIFont) -> Self {
        self.onRendered {
            guard let label = $0 as? View else {
                return
            }

            let muttable = NSMutableAttributedString(attributedString: label.attributedPlaceholder ?? .init(string: label.placeholder ?? ""))
            muttable.addAttribute(.font, value: font, range: (muttable.string as NSString).range(of: muttable.string))
            label.attributedPlaceholder = muttable
        }
    }

    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.font = font
            ($0 as? View)?.adjustsFontForContentSizeCategory = isDynamicTextSize
        }
    }

    func text(scale: CGFloat) -> Self {
        return self.onRendered {
            guard let font = ($0 as? View)?.font else {
                print("[warning] text scale cannot be applied without font")
                return
            }

            ($0 as? View)?.minimumFontSize = font.pointSize
            ($0 as? View)?.adjustsFontSizeToFitWidth = scale != 1
        }
    }

    func text(alignment: NSTextAlignment) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.textAlignment = alignment
        }
    }
}

public extension UIViewCreator where View: UITextField {
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

    func allowsEditing(textAttributes flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.allowsEditingTextAttributes = flag
        }
    }
}

public extension UIViewCreator where View: UITextField {

    func placeholder(_ string: String?) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.placeholder = string
        }
    }

    func placeholder(_ attributedText: NSAttributedString?) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.attributedPlaceholder = attributedText
        }
    }

    func border(style: UITextField.BorderStyle) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.borderStyle = style
        }
    }
}

public extension UIViewCreator where View: UITextField {

    func clearButton(mode: TextField.ViewMode) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.clearButtonMode = mode
        }
    }

    func clears(onBegin flag: Bool) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.clearsOnBeginEditing = flag
        }
    }

    func clears(onInsertion flag: Bool) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.clearsOnInsertion = flag
        }
    }
}

public extension UIViewCreator where Self: Control, View: UITextField {
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

public extension UIViewCreator where View: UITextField {
    func leftView(_ mode: UITextField.ViewMode = .always, content: @escaping () -> ViewCreator) -> Self {
        return self.onRendered {
            ($0 as? View)?.leftView = Host(content: content).uiView
            ($0 as? View)?.leftViewMode = mode
        }
    }

    func rightView(_ mode: UITextField.ViewMode = .always, content: @escaping () -> ViewCreator) -> Self {
        return self.onRendered {
            ($0 as? View)?.rightView = Host(content: content).uiView
            ($0 as? View)?.rightViewMode = mode
        }
    }
}

public extension TextKeyboard where View: UITextField {
    func autocapitalization(type: UITextAutocapitalizationType) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.autocapitalizationType = type
        }
    }

    func autocorrection(type: UITextAutocorrectionType) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.autocorrectionType = type
        }
    }


    func keyboard(type: UIKeyboardType) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.keyboardType = type
        }
    }

    func keyboard(appearance: UIKeyboardAppearance) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.keyboardAppearance = appearance
        }
    }
}

public extension TextKeyboard where View: UITextField {

    func returnKey(type: UIReturnKeyType) -> Self {
        self.onNotRendered {
            ($0 as? View)?.returnKeyType = type
        }
    }

    func secureText(_ flag: Bool = true) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.isSecureTextEntry = flag
        }
    }

    @available(iOS 12, tvOS 12, *)
    func passwordRules(_ passwordRules: UITextInputPasswordRules?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.passwordRules = passwordRules
        }
    }
}

@available(iOS 11, tvOS 11, *)
public extension TextKeyboard where View: UITextField {

    func smartDashes(type: UITextSmartDashesType) -> Self {
        self.onNotRendered {
            ($0 as? View)?.smartDashesType = type
        }
    }

    func smartQuotes(type: UITextSmartQuotesType) -> Self {
        self.onNotRendered {
            ($0 as? View)?.smartQuotesType = type
        }
    }

    func smartInsertDelete(type: UITextSmartInsertDeleteType) -> Self {
        self.onNotRendered {
            ($0 as? View)?.smartInsertDeleteType = type
        }
    }
}

public extension TextKeyboard where View: UITextField {
    func textContent(type: UITextContentType) -> Self {
        self.onNotRendered {
            ($0 as? View)?.textContentType = type
        }
    }

    func inputView(content: @escaping () -> ViewCreator) -> Self {
        self.onRendered {
           ($0 as? View)?.inputView = content().uiView
        }
    }

    func inputAccessoryView(content: @escaping () -> ViewCreator) -> Self {
        self.onRendered {
            ($0 as? View)?.inputAccessoryView = content().uiView
        }
    }

    func input(delegate: UITextInputDelegate) -> Self {
        self.onInTheScene {
            ($0 as? View)?.inputDelegate = delegate
        }
    }

    func typing(attributes: [NSAttributedString.Key : Any]?) -> Self {
       self.onNotRendered {
           ($0 as? View)?.typingAttributes = attributes
       }
   }
}
