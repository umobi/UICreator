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

// swiftlint:disable file_length
public class TextField: UITextField {

    init() {
        super.init(frame: .zero)
        self.makeSelfImplemented()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.renderManager.willMove(toSuperview: newSuperview)
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

public struct UICTextField: UIViewCreator {
    public typealias View = TextField

    enum Init {
        case text(String, Relay<String?>)
        case attributedText(NSAttributedString, Relay<NSAttributedString?>)
    }

    let `init`: Init

    public init(placeholder: String, _ dynamicText: Relay<String?>) {
        self.`init` = .text(placeholder, dynamicText)
    }

    public init(placeholder: NSAttributedString, _ dynamicAttributedText: Relay<NSAttributedString?>) {
        self.`init` = .attributedText(placeholder, dynamicAttributedText)
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        switch _self.`init` {
        case .text(let placeholder, let dynamicText):
            return View()
                .onNotRendered {
                    weak var view = $0 as? View
                    view?.placeholder = placeholder

                    dynamicText.distinctSync {
                        view?.text = $0
                    }
                }
                .onEvent(.editingChanged) {
                    dynamicText.wrappedValue = ($0 as? View)?.text
                }

        case .attributedText(let placeholder, let dynamicAttributedText):
            return View()
                .onNotRendered {
                    weak var view = $0 as? View
                    view?.attributedPlaceholder = placeholder

                    dynamicAttributedText.distinctSync {
                        view?.attributedText = $0
                    }
                }
                .onEvent(.editingChanged) {
                    dynamicAttributedText.wrappedValue = ($0 as? View)?.attributedText
                }
        }
    }
}

public extension UIViewCreator where View: UITextField {

    func textColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.textColor = color
        }
    }

    func placeholderColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onRendered {
            guard let label = $0 as? View else {
                return
            }

            let muttable = NSMutableAttributedString(attributedString:
                label.attributedPlaceholder ??
                    .init(string: label.placeholder ?? "")
            )
            muttable.addAttribute(
                .foregroundColor,
                value: color ?? .clear,
                range: (muttable.string as NSString).range(of: muttable.string)
            )
            label.attributedPlaceholder = muttable
        }
    }

    func placeholderFont(_ font: UIFont) -> UICModifiedView<View> {
        self.onRendered {
            guard let label = $0 as? View else {
                return
            }

            let muttable = NSMutableAttributedString(attributedString:
                label.attributedPlaceholder ??
                    .init(string: label.placeholder ?? "")
            )
            muttable.addAttribute(
                .font,
                value: font,
                range: (muttable.string as NSString).range(of: muttable.string)
            )
            label.attributedPlaceholder = muttable
        }
    }

    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.font = font
            ($0 as? View)?.adjustsFontForContentSizeCategory = isDynamicTextSize
        }
    }

    func textScale(_ scale: CGFloat) -> UICModifiedView<View> {
        self.onRendered {
            guard let font = ($0 as? View)?.font else {
                print("[warning] text scale cannot be applied without font")
                return
            }

            ($0 as? View)?.minimumFontSize = font.pointSize
            ($0 as? View)?.adjustsFontSizeToFitWidth = scale != 1
        }
    }

    func textAlignment(_ alignment: NSTextAlignment) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.textAlignment = alignment
        }
    }
}

public extension UIViewCreator where View: UITextField {
    func adjustsFontForContentSizeCategory(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontForContentSizeCategory = flag
        }
    }

    func adjustsFontSizeToFitWidth(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontSizeToFitWidth = flag
        }
    }

    func allowsEditingTextAttributes(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.allowsEditingTextAttributes = flag
        }
    }
}

public extension UIViewCreator where View: UITextField {

    func borderStyle(_ style: UITextField.BorderStyle) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.borderStyle = style
        }
    }
}

public extension UIViewCreator where View: UITextField {

    func clearButtonMode(_ mode: UITextField.ViewMode) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.clearButtonMode = mode
        }
    }

    func clearsOnBegin(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.clearsOnBeginEditing = flag
        }
    }

    func clearsOnInsertion(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.clearsOnInsertion = flag
        }
    }
}

public extension UIViewCreator where View: UITextField {
    func onEditingDidBegin(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onEvent(.editingDidBegin, handler)
    }

    func onEditingChanged(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onEvent(.editingChanged, handler)
    }

    func onEditingDidEnd(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onEvent(.editingDidEnd, handler)
    }

    func onEditingDidEndOnExit(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onEvent(.editingDidEndOnExit, handler)
    }

    func onAllEditingEvents(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onEvent(.allEditingEvents, handler)
    }
}

public extension UIViewCreator where View: UITextField {
    func leftView(
        _ mode: UITextField.ViewMode = .always,
        content: @escaping () -> ViewCreator
    ) -> UICModifiedView<View> {

        self.onRendered { view in
            var needsToAddConstraints = true

            (view as? View)?.leftViewMode = mode
            (view as? View)?.leftView = ViewAdaptor(content().releaseUIView())
                .onAppear { viewAdaptor in
                    guard needsToAddConstraints else {
                        return
                    }

                    let viewAdaptor = viewAdaptor as! ViewAdaptor

                    Constraintable.activate {
                        viewAdaptor.cbuild
                            .centerY
                            .equalTo(view.cbuild.centerY)

                        viewAdaptor.cbuild
                            .leading
                    }

                    needsToAddConstraints = false
                }
                .onDisappear {
                    needsToAddConstraints = $0.window == nil
                }
        }
    }

    func rightView(
        _ mode: UITextField.ViewMode = .always,
        content: @escaping () -> ViewCreator
    ) -> UICModifiedView<View> {

        self.onRendered { view in
            var needsToAddConstraints = true

            (view as? View)?.rightViewMode = mode
            (view as? View)?.rightView = ViewAdaptor(content().releaseUIView())
                .onAppear { viewAdaptor in
                    guard needsToAddConstraints else {
                        return
                    }

                    let viewAdaptor = viewAdaptor as! ViewAdaptor

                    Constraintable.activate {
                        viewAdaptor.cbuild
                            .centerY
                            .equalTo(view.cbuild.centerY)

                        viewAdaptor.cbuild
                            .trailing
                    }

                    needsToAddConstraints = false
                }
                .onDisappear {
                    needsToAddConstraints = $0.window == nil
                }
        }
    }
}

public extension UIViewCreator where View: UITextField {
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

public extension UIViewCreator where View: UITextField {

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
public extension UIViewCreator where View: UITextField {

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

public extension UIViewCreator where View: UITextField {
    func textContentType(_ type: UITextContentType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.textContentType = type
        }
    }

    func inputView(content: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.inputView = ViewAdaptor(content().releaseUIView())
            ($0 as? View)?.inputView?.sizeToFit()
        }
    }

    func inputAccessoryView(content: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.inputAccessoryView = ViewAdaptor(content().releaseUIView())
            ($0 as? View)?.inputAccessoryView?.sizeToFit()
        }
    }

    func inputDelegate(_ delegate: UITextInputDelegate) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?.inputDelegate = delegate
        }
    }

    func typingAttributes(_ attributes: [NSAttributedString.Key: Any]?) -> UICModifiedView<View> {
       self.onNotRendered {
           ($0 as? View)?.typingAttributes = attributes
       }
   }
}
