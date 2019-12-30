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

public protocol TextKeyboard: UIViewCreator {
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
    func inputAccessoryView(content: @escaping () -> ViewCreator) -> Self
    func inputView(content: @escaping () -> ViewCreator) -> Self
    func input(delegate: UITextInputDelegate) -> Self

    func typing(attributes: [NSAttributedString.Key : Any]?) -> Self
}
