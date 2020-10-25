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
import ConstraintBuilder

public class TextView: UITextView {

    fileprivate var textDidChangeHandler: ((UIView) -> Void)?

    init() {
        super.init(frame: .zero, textContainer: nil)
        self.makeSelfImplemented()
        self.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        fatalError("init(frame:, textContainer:) has not been implemented")
    }

    @discardableResult
    func onTextChange(_ handler: @escaping (UIView) -> Void) -> Self {
        let old = self.textDidChangeHandler
        self.textDidChangeHandler = {
            old?($0)
            handler($0)
        }

        return self
    }

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            self.renderManager.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            self.renderManager.frame(newValue)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.renderManager.willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.renderManager.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.renderManager.didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.renderManager.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.renderManager.traitDidChange()
    }
}

extension TextView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        self.textDidChangeHandler?(textView)
    }
}

public struct UICTextView: UIViewCreator {
    public typealias View = TextView

    private enum Content {
        case string(Relay<String?>)
        case attributedText(Relay<NSAttributedString?>)
    }

    private let content: Content

    public init(_ value: Relay<String?>) {
        self.content = .string(value)
    }

    public init(_ value: Relay<NSAttributedString?>) {
        self.content = .attributedText(value)
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        switch _self.content {
        case .string(let dynamicValue):
            return TextView()
                .onTextChange {
                    dynamicValue.wrappedValue = ($0 as? View)?.text
                }
                .onNotRendered {
                    weak var view = $0 as? View

                    dynamicValue.distinctSync {
                        view?.text = $0
                    }
                }

        case .attributedText(let dynamicValue):
            return View()
                .onTextChange {
                    dynamicValue.wrappedValue = ($0 as? View)?.attributedText
                }
                .onNotRendered {
                    weak var view = $0 as? View

                    dynamicValue.distinctSync {
                        view?.attributedText = $0
                    }
                }
        }
    }
}

public extension UIViewCreator where View: UITextView {
    func isSelectable(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.isSelectable = flag
        }
    }

    #if os(iOS)
    func isEditable(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.isEditable = flag
        }
    }
    #endif
}

public extension UIViewCreator where View: UITextView {

    func text(_ string: String?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.text = string
        }
    }

    func text(_ attributedText: NSAttributedString?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.attributedText = attributedText
        }
    }

    func textColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.textColor = color
        }
    }

    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.font = font
            ($0 as? View)?.adjustsFontForContentSizeCategory = isDynamicTextSize
        }
    }

    func textAlignment(_ alignment: NSTextAlignment) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.textAlignment = alignment
        }
    }

    func textContainerInsets(_ insets: UIEdgeInsets) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.textContainerInset = insets
        }
    }
}

public extension UIViewCreator where View: UITextView {
    func adjustsFontForContentSizeCategory(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontForContentSizeCategory = flag
        }
    }
}

public extension UIViewCreator where View: UITextView {
    func autocapitalizationType(_ type: UITextAutocapitalizationType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.autocapitalizationType = type
        }
    }

    func autocorrectionType(_ type: UITextAutocorrectionType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.autocorrectionType = type
        }
    }

    func keyboardType(_ type: UIKeyboardType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.keyboardType = type
        }
    }

    func keyboardAppearance(_ appearance: UIKeyboardAppearance) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.keyboardAppearance = appearance
        }
    }
}

public extension UIViewCreator where View: UITextView {

    func returnKeyType(_ type: UIReturnKeyType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.returnKeyType = type
        }
    }

    func isSecureTextEntry(_ flag: Bool = true) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.isSecureTextEntry = flag
        }
    }

    @available(iOS 12, tvOS 12, *)
    func passwordRules(_ passwordRules: UITextInputPasswordRules?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.passwordRules = passwordRules
        }
    }
}

@available(iOS 11, tvOS 11, *)
public extension UIViewCreator where View: UITextView {

    func smartDashesType(_ type: UITextSmartDashesType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.smartDashesType = type
        }
    }

    func smartQuotesType(_ type: UITextSmartQuotesType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.smartQuotesType = type
        }
    }

    func smartInsertDeleteType(_ type: UITextSmartInsertDeleteType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.smartInsertDeleteType = type
        }
    }
}

public extension UIViewCreator where View: UITextView {
    func textContentType(_ type: UITextContentType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.textContentType = type
        }
    }

    func inputView(content: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.inputView = ViewAdaptor(content().releaseUIView())
        }
    }

    func inputAccessoryView(content: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.inputAccessoryView = ViewAdaptor(content().releaseUIView())
        }
    }

    func inputDelegate(_ delegate: UITextInputDelegate) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?.inputDelegate = delegate
        }
    }

    func typingAttributes(_ attributes: [NSAttributedString.Key: Any]?) -> UICModifiedView<View> {
       self.onNotRendered {
            ($0 as? View)?.typingAttributes = attributes ?? [:]
       }
   }
}
