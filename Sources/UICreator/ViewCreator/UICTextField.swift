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

@frozen
public struct UICTextField: UIViewCreator {
    public typealias View = UITextField

    @usableFromInline
    enum Content {
        case text(String, Relay<String?>)
        case attributedText(NSAttributedString, Relay<NSAttributedString?>)
    }

    private let content: Content

    public init(placeholder: String, _ dynamicText: Relay<String?>) {
        self.content = .text(placeholder, dynamicText)
    }

    public init(placeholder: NSAttributedString, _ dynamicAttributedText: Relay<NSAttributedString?>) {
        self.content = .attributedText(placeholder, dynamicAttributedText)
    }

    @inline(__always)
    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        switch _self.content {
        case .text(let placeholder, let dynamicText):
            return Views.TextField()
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
            return Views.TextField()
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

    @inlinable
    func textColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.textColor = color
        }
    }

    @inlinable
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

    @inlinable
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

    @inlinable
    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.font = font
            ($0 as? View)?.adjustsFontForContentSizeCategory = isDynamicTextSize
        }
    }

    @inlinable
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

    @inlinable
    func textAlignment(_ alignment: NSTextAlignment) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.textAlignment = alignment
        }
    }
}

public extension UIViewCreator where View: UITextField {

    @inlinable
    func adjustsFontForContentSizeCategory(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontForContentSizeCategory = flag
        }
    }

    @inlinable
    func adjustsFontSizeToFitWidth(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontSizeToFitWidth = flag
        }
    }

    @inlinable
    func allowsEditingTextAttributes(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.allowsEditingTextAttributes = flag
        }
    }
}

public extension UIViewCreator where View: UITextField {

    @inlinable
    func borderStyle(_ style: UITextField.BorderStyle) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.borderStyle = style
        }
    }
}

public extension UIViewCreator where View: UITextField {

    @inlinable
    func clearButtonMode(_ mode: UITextField.ViewMode) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.clearButtonMode = mode
        }
    }

    @inlinable
    func clearsOnBegin(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.clearsOnBeginEditing = flag
        }
    }

    @inlinable
    func clearsOnInsertion(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.clearsOnInsertion = flag
        }
    }
}

public extension UIViewCreator where View: UITextField {

    @inlinable
    func onEditingDidBegin(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onEvent(.editingDidBegin, handler)
    }

    @inlinable
    func onEditingChanged(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onEvent(.editingChanged, handler)
    }

    @inlinable
    func onEditingDidEnd(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onEvent(.editingDidEnd, handler)
    }

    @inlinable
    func onEditingDidEndOnExit(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onEvent(.editingDidEndOnExit, handler)
    }

    @inlinable
    func onAllEditingEvents(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onEvent(.allEditingEvents, handler)
    }
}

public extension UIViewCreator where View: UITextField {

    @inlinable
    func leftView(
        _ mode: UITextField.ViewMode = .always,
        content: @escaping () -> ViewCreator) -> UICModifiedView<View> {

        self.onRendered { view in
            var needsToAddConstraints = true

            (view as? View)?.leftViewMode = mode
            (view as? View)?.leftView = UICAnyView(content).releaseUIView()
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

    @inlinable
    func rightView(
        _ mode: UITextField.ViewMode = .always,
        content: @escaping () -> ViewCreator) -> UICModifiedView<View> {

        self.onRendered { view in
            var needsToAddConstraints = true

            (view as? View)?.rightViewMode = mode
            (view as? View)?.rightView = UICAnyView(content).releaseUIView()
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
    @inlinable
    func autocapitalizationType(_ type: UITextAutocapitalizationType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.autocapitalizationType = type
        }
    }

    @inlinable
    func autocorrectionType(_ type: UITextAutocorrectionType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.autocorrectionType = type
        }
    }

    @inlinable
    func keyboardType(_ type: UIKeyboardType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.keyboardType = type
        }
    }

    @inlinable
    func keyboardAppearance(_ appearance: UIKeyboardAppearance) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.keyboardAppearance = appearance
        }
    }
}

public extension UIViewCreator where View: UITextField {

    @inlinable
    func returnKeyType(_ type: UIReturnKeyType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.returnKeyType = type
        }
    }

    @inlinable
    func isSecureTextEntry(_ flag: Bool = true) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.isSecureTextEntry = flag
        }
    }

    @available(iOS 12, tvOS 12, *)
    @inlinable
    func passwordRules(_ passwordRules: UITextInputPasswordRules?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.passwordRules = passwordRules
        }
    }
}

@available(iOS 11, tvOS 11, *)
public extension UIViewCreator where View: UITextField {

    @inlinable
    func smartDashesType(_ type: UITextSmartDashesType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.smartDashesType = type
        }
    }

    @inlinable
    func smartQuotesType(_ type: UITextSmartQuotesType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.smartQuotesType = type
        }
    }

    @inlinable
    func smartInsertDeleteType(_ type: UITextSmartInsertDeleteType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.smartInsertDeleteType = type
        }
    }
}

public extension UIViewCreator where View: UITextField {

    @inlinable
    func textContentType(_ type: UITextContentType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.textContentType = type
        }
    }

    @inlinable
    func inputView(content: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.inputView = UICAnyView(content).releaseUIView()
            ($0 as? View)?.inputView?.sizeToFit()
        }
    }

    @inlinable
    func inputAccessoryView(content: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.inputAccessoryView = UICAnyView(content).releaseUIView()
            ($0 as? View)?.inputAccessoryView?.sizeToFit()
        }
    }

    @inlinable
    func inputDelegate(_ delegate: UITextInputDelegate) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?.inputDelegate = delegate
        }
    }

    @inlinable
    func typingAttributes(_ attributes: [NSAttributedString.Key: Any]?) -> UICModifiedView<View> {
       self.onNotRendered {
           ($0 as? View)?.typingAttributes = attributes
       }
   }
}
