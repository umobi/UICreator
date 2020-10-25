//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import UIKit

/// `TextKeyboard` has the same problem as *TextElement* and may be removed in the next released versions.
public protocol TextKeyboard: UIViewCreator {
    func autocapitalizationType(_ type: UITextAutocapitalizationType) -> Self
    func autocorrectionType(_ type: UITextAutocorrectionType) -> Self

    func keyboardType(_ type: UIKeyboardType) -> Self
    func keyboardAppearance(_ appearance: UIKeyboardAppearance) -> Self
    func returnKeyType(_ type: UIReturnKeyType) -> Self

    func isSecureTextEntry(_ flag: Bool) -> Self
    @available(iOS 12, tvOS 12, *)
    func passwordRules(_ passwordRules: UITextInputPasswordRules?) -> Self

    @available(iOS 11, tvOS 11, *)
    func smartDashesType(_ type: UITextSmartDashesType) -> Self
    @available(iOS 11, tvOS 11, *)
    func smartQuotesType(_ type: UITextSmartQuotesType) -> Self
    @available(iOS 11, tvOS 11, *)
    func smartInsertDeleteType(_ type: UITextSmartInsertDeleteType) -> Self

    func textContentType(_ type: UITextContentType) -> Self
    func inputAccessoryView(content: @escaping () -> _ViewCreator) -> Self
    func inputView(content: @escaping () -> _ViewCreator) -> Self
    func inputDelegate(_ delegate: UITextInputDelegate) -> Self

    func typingAttributes(_ attributes: [NSAttributedString.Key: Any]?) -> Self
}
