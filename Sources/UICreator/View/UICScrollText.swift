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

public class TextView: UITextView {

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            RenderManager(self)?.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            RenderManager(self)?.frame(newValue)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self)?.willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self)?.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self)?.didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self)?.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        RenderManager(self)?.traitDidChange()
    }
}

public class UICScrollText: UIViewCreator, TextElement, TextKeyboard {
    public typealias View = TextView

    required public init(_ text: String?) {
        self.loadView { [unowned self] in
            View.init(builder: self)
        }
        .onNotRendered {
            ($0 as? View)?.text = text
        }
    }

    required public init(_ attributedText: NSAttributedString?) {
        self.loadView { [unowned self] in
            View.init(builder: self)
        }
        .onNotRendered {
            ($0 as? View)?.attributedText = attributedText
        }
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

    func textColor(_ color: UIColor?) -> Self {
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

    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.textAlignment = alignment
        }
    }

    func textContainerInsets(_ insets: UIEdgeInsets) -> Self {
        self.onNotRendered {
            ($0 as? View)?.textContainerInset = insets
        }
    }
}

public extension TextElement where View: UITextView {
    func adjustsFontForContentSizeCategory(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontForContentSizeCategory = flag
        }
    }
}

public extension TextKeyboard where View: UITextView {
    func autocapitalizationType(_ type: UITextAutocapitalizationType) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.autocapitalizationType = type
        }
    }

    func autocorrectionType(_ type: UITextAutocorrectionType) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.autocorrectionType = type
        }
    }

    func keyboardType(_ type: UIKeyboardType) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.keyboardType = type
        }
    }

    func keyboardAppearance(_ appearance: UIKeyboardAppearance) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.keyboardAppearance = appearance
        }
    }
}

public extension TextKeyboard where View: UITextView {

    func returnKeyType(_ type: UIReturnKeyType) -> Self {
        self.onNotRendered {
            ($0 as? View)?.returnKeyType = type
        }
    }

    func isSecureTextEntry(_ flag: Bool = true) -> Self {
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

    func smartDashesType(_ type: UITextSmartDashesType) -> Self {
        self.onNotRendered {
            ($0 as? View)?.smartDashesType = type
        }
    }

    func smartQuotesType(_ type: UITextSmartQuotesType) -> Self {
        self.onNotRendered {
            ($0 as? View)?.smartQuotesType = type
        }
    }

    func smartInsertDeleteType(_ type: UITextSmartInsertDeleteType) -> Self {
        self.onNotRendered {
            ($0 as? View)?.smartInsertDeleteType = type
        }
    }
}

public extension TextKeyboard where View: UITextView {
    func textContentType(_ type: UITextContentType) -> Self {
        self.onNotRendered {
            ($0 as? View)?.textContentType = type
        }
    }

    func inputView(content: @escaping () -> ViewCreator) -> Self {
        let content = content()
        self.tree.append(content)

        return self.onRendered {
            ($0 as? View)?.inputView = UICHostingView(view: content)
        }
    }

    func inputAccessoryView(content: @escaping () -> ViewCreator) -> Self {
        let content = content()
        self.tree.append(content)

        return self.onRendered {
            ($0 as? View)?.inputAccessoryView = UICHostingView(view: content)
        }
    }

    func inputDelegate(_ delegate: UITextInputDelegate) -> Self {
        self.onInTheScene {
            ($0 as? View)?.inputDelegate = delegate
        }
    }

    func typingAttributes(_ attributes: [NSAttributedString.Key: Any]?) -> Self {
       self.onNotRendered {
            ($0 as? View)?.typingAttributes = attributes ?? [:]
       }
   }
}
