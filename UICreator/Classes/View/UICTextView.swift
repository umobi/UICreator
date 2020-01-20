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

public class _TextView: UITextView {
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

public class UICTextView: UIViewCreator, TextElement, TextKeyboard, HasViewDelegate {
    public typealias View = _TextView

    public func delegate(_ delegate: UITextViewDelegate?) -> Self {
        (self.uiView as? View)?.delegate = delegate
        return self
    }

    required public init(_ text: String?) {
        self.uiView = View.init(builder: self)
        (self.uiView as? View)?.text = text
    }

    required public init(_ attributedText: NSAttributedString?) {
        self.uiView = .init()
        (self.uiView as? View)?.attributedText = attributedText
    }
}

public extension UIViewCreator where View: UITextView {
    func isSelectable(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.isSelectable = flag
        }
    }

    #if os(iOS)
    func isEditable(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.isEditable = flag
        }
    }
    #endif
}

public extension TextElement where View: UITextView {

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

    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.font = font
            ($0 as? View)?.adjustsFontForContentSizeCategory = isDynamicTextSize
        }
    }

    func text(alignment: NSTextAlignment) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.textAlignment = alignment
        }
    }

    func textContainer(insets: UIEdgeInsets) -> Self {
        self.onNotRendered {
            ($0 as? View)?.textContainerInset = insets
        }
    }
}

public extension TextElement where View: UITextView {
    func adjustsFont(forContentSizeCategory flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontForContentSizeCategory = flag
        }
    }
}

public extension TextKeyboard where View: UITextView {
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

public extension TextKeyboard where View: UITextView {

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
public extension TextKeyboard where View: UITextView {

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

public extension TextKeyboard where View: UITextView {
    func textContent(type: UITextContentType) -> Self {
        self.onNotRendered {
            ($0 as? View)?.textContentType = type
        }
    }

    func inputView(content: @escaping () -> ViewCreator) -> Self {
        self.onRendered {
            ($0 as? View)?.inputView = content().releaseUIView()
        }
    }

    func inputAccessoryView(content: @escaping () -> ViewCreator) -> Self {
        self.onRendered {
            ($0 as? View)?.inputAccessoryView = content().releaseUIView()
        }
    }

    func input(delegate: UITextInputDelegate) -> Self {
        self.onInTheScene {
            ($0 as? View)?.inputDelegate = delegate
        }
    }

    func typing(attributes: [NSAttributedString.Key : Any]?) -> Self {
       self.onNotRendered {
            ($0 as? View)?.typingAttributes = attributes ?? [:]
       }
   }
}

