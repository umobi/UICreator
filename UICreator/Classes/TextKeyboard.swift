//
//  TextKeyboard.swift
//  UICreator
//
//  Created by brennobemoura on 25/12/19.
//

import Foundation
import UIKit

public protocol TextKeyboard: ViewBuilder {
    func autocapitalization(type: UITextAutocapitalizationType) -> Self
    func autocorrection(type: UITextAutocorrectionType) -> Self

    func keyboard(type: UIKeyboardType) -> Self
    func keyboard(appearance: UIKeyboardAppearance) -> Self
    func returnKey(type: UIReturnKeyType) -> Self

    func secureText(_ flag: Bool) -> Self
    @available(iOS 12, tvOS 12, *)
    func passwordRules(_ passwordRules: UITextInputPasswordRules?) -> Self

    @available(iOS 11, tvOS 11, *)
    func smartDashes(type: UITextSmartDashesType) -> Self
    @available(iOS 11, tvOS 11, *)
    func smartQuotes(type: UITextSmartQuotesType) -> Self
    @available(iOS 11, tvOS 11, *)
    func smartInsertDelete(type: UITextSmartInsertDeleteType) -> Self

    func textContent(type: UITextContentType) -> Self
    func inputAccessoryView(content: @escaping () -> UIInputView) -> Self
    func inputView(content: @escaping () -> UIInputView) -> Self
    func input(delegate: UITextInputDelegate) -> Self

    func typing(attributes: [NSAttributedString.Key : Any]?) -> Self
}
