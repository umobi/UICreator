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

public class _TextField: UITextField {
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self)?.willMove(toSuperview: newSuperview)
    }

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

public class UICText: UIViewCreator, TextElement, TextKeyboard, Control {
    public typealias View = _TextField

    required public init(_ text: String?) {
        self.text(text)
            .loadView { [unowned self] in
                View.init(builder: self)
            }
    }

    required public init(_ attributedText: NSAttributedString?) {
        self.text(attributedText)
            .loadView { [unowned self] in
                View.init(builder: self)
            }

    }

    required public init(placeholder text: String?) {
        self.placeholder(text)
            .loadView { [unowned self] in
                View.init(builder: self)
            }
    }

    required public init(placeholder attributed: NSAttributedString?) {
        self.placeholder(attributed)
            .loadView { [unowned self] in
                View.init(builder: self)
            }
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

    func textColor(_ color: UIColor?) -> Self {
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

    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.textAlignment = alignment
        }
    }
}

public extension UIViewCreator where View: UITextField {
    func adjustsFontForContentSizeCategory(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontForContentSizeCategory = flag
        }
    }

    func adjustsFontSizeToFitWidth(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontSizeToFitWidth = flag
        }
    }

    func allowsEditingTextAttributes(_ flag: Bool) -> Self {
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

    func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.borderStyle = style
        }
    }
}

public extension UIViewCreator where View: UITextField {

    func clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.clearButtonMode = mode
        }
    }

    func clearsOnBegin(_ flag: Bool) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.clearsOnBeginEditing = flag
        }
    }

    func clearsOnInsertion(_ flag: Bool) -> Self {
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
        let host = UICHost(content: content)
        self.tree.append(host)

        return self.onRendered { view in
            (view as? View)?.leftView = host.releaseUIView()
            (view as? View)?.leftViewMode = mode

            var needsToAddConstraints = true
            host.onAppear { [weak view] in
                guard needsToAddConstraints, let view = view else {
                    return
                }

                Constraintable.activate(
                    $0.cbuild
                        .centerY
                        .equalTo(view.cbuild.centerY),

                    $0.cbuild
                        .leading
                )

                needsToAddConstraints = false
            }

            host.onDisappear {
                needsToAddConstraints = $0.window == nil
            }
        }
    }

    func rightView(_ mode: UITextField.ViewMode = .always, content: @escaping () -> ViewCreator) -> Self {
        let host = UICHost(content: content)
        self.tree.append(host)

        return self.onRendered { view in
            (view as? View)?.rightView = host.releaseUIView()
            (view as? View)?.rightViewMode = mode

            var needsToAddConstraints = true
            host.onAppear { [weak view] in
                guard needsToAddConstraints, let view = view else {
                    return
                }

                Constraintable.activate(
                    $0.cbuild
                        .centerY
                        .equalTo(view.cbuild.centerY),

                    $0.cbuild
                        .trailing
                )

                needsToAddConstraints = false
            }

            host.onDisappear {
                needsToAddConstraints = $0.window == nil
            }
        }
    }
}

public extension TextKeyboard where View: UITextField {
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

public extension TextKeyboard where View: UITextField {

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
public extension TextKeyboard where View: UITextField {

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

public extension TextKeyboard where View: UITextField {
    func textContentType(_ type: UITextContentType) -> Self {
        self.onNotRendered {
            ($0 as? View)?.textContentType = type
        }
    }

    func inputView(content: @escaping () -> ViewCreator) -> Self {
        let content = content()
        self.tree.append(content)

        return self.onRendered {
           ($0 as? View)?.inputView = content.releaseUIView()
        }
    }

    func inputAccessoryView(content: @escaping () -> ViewCreator) -> Self {
        let content = content()
        self.tree.append(content)

        return self.onRendered {
            ($0 as? View)?.inputAccessoryView = content.releaseUIView()
        }
    }

    func inputDelegate(_ delegate: UITextInputDelegate) -> Self {
        self.onInTheScene {
            ($0 as? View)?.inputDelegate = delegate
        }
    }

    func typingAttributes(_ attributes: [NSAttributedString.Key : Any]?) -> Self {
       self.onNotRendered {
           ($0 as? View)?.typingAttributes = attributes
       }
   }
}

public extension UIViewCreator where Self: Control & TextElement, View: UITextField {
    init(_ value: Relay<String?>) {
        self.init(value.wrappedValue)

        _ = self.onInTheScene { [weak self] in
            weak var view = $0 as? View
            var isLocked = false

            _ = self?.onEvent(.editingChanged) { _ in
                guard !isLocked else {
                    return
                }

                isLocked = true
                value.wrappedValue = view?.text
                isLocked = false
            }

            value.sync {
                guard !isLocked else {
                    return
                }

                isLocked = true
                view?.text = $0
                isLocked = false
            }
        }
    }
}

public extension UIViewCreator where Self: TextElement & Control, View: UITextField {
    func text(_ value: Relay<String?>) -> Self {
        self.onNotRendered { view in
            weak var view = view
            var isLocked: Bool = false

            _ = self.onEditingChanged {
                guard !isLocked else {
                    return
                }

                isLocked = true
                value.wrappedValue = ($0 as? View)?.text
                isLocked = false
            }

            value.sync {
                guard !isLocked else {
                    return
                }


                isLocked = true
                (view as? View)?.text = $0
                isLocked = false
            }
        }
    }
}
