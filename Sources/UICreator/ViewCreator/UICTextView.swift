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
public struct UICTextView: UIViewCreator {
    public typealias View = UITextView

    @usableFromInline
    enum Content {
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

    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        switch _self.content {
        case .string(let dynamicValue):
            return Views.TextView()
                .onDidChanged {
                    dynamicValue.wrappedValue = $0.text
                }
                .onNotRendered {
                    weak var view = $0 as? View

                    dynamicValue.distinctSync {
                        view?.text = $0
                    }
                }

        case .attributedText(let dynamicValue):
            return Views.TextView()
                .onDidChanged {
                    dynamicValue.wrappedValue = $0.attributedText
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
    @inlinable
    func isSelectable(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.isSelectable = flag
        }
    }

    #if os(iOS)
    @inlinable
    func isEditable(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.isEditable = flag
        }
    }
    #endif
}

public extension UIViewCreator where View: UITextView {

    @inlinable
    func text(_ string: String?) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.text = string
        }
    }

    @inlinable
    func text(_ attributedText: NSAttributedString?) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.attributedText = attributedText
        }
    }

    @inlinable
    func textColor(_ color: UIColor?) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.textColor = color
        }
    }

    @inlinable
    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.font = font
            ($0 as? View)?.adjustsFontForContentSizeCategory = isDynamicTextSize
        }
    }

    @inlinable
    func textAlignment(_ alignment: NSTextAlignment) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.textAlignment = alignment
        }
    }

    @inlinable
    func textContainerInsets(_ insets: UIEdgeInsets) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.textContainerInset = insets
        }
    }
}

public extension UIViewCreator where View: UITextView {
    @inlinable
    func adjustsFontForContentSizeCategory(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontForContentSizeCategory = flag
        }
    }
}

public extension UIViewCreator where View: UITextView {
    @inlinable
    func autocapitalizationType(_ type: UITextAutocapitalizationType) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.autocapitalizationType = type
        }
    }

    @inlinable
    func autocorrectionType(_ type: UITextAutocorrectionType) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.autocorrectionType = type
        }
    }

    @inlinable
    func keyboardType(_ type: UIKeyboardType) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.keyboardType = type
        }
    }

    @inlinable
    func keyboardAppearance(_ appearance: UIKeyboardAppearance) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.keyboardAppearance = appearance
        }
    }
}

public extension UIViewCreator where View: UITextView {

    @inlinable
    func returnKeyType(_ type: UIReturnKeyType) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.returnKeyType = type
        }
    }

    @inlinable
    func isSecureTextEntry(_ flag: Bool = true) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.isSecureTextEntry = flag
        }
    }

    @available(iOS 12, tvOS 12, *)
    @inlinable
    func passwordRules(_ passwordRules: UITextInputPasswordRules?) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.passwordRules = passwordRules
        }
    }
}

@available(iOS 11, tvOS 11, *)
public extension UIViewCreator where View: UITextView {

    @inlinable
    func smartDashesType(_ type: UITextSmartDashesType) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.smartDashesType = type
        }
    }

    @inlinable
    func smartQuotesType(_ type: UITextSmartQuotesType) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.smartQuotesType = type
        }
    }

    @inlinable
    func smartInsertDeleteType(_ type: UITextSmartInsertDeleteType) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.smartInsertDeleteType = type
        }
    }
}

public extension UIViewCreator where View: UITextView {

    @inlinable
    func textContentType(_ type: UITextContentType) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.textContentType = type
        }
    }

    @inlinable
    func inputView(content: () -> ViewCreator) -> UICRenderedModifier<View> {
        let content = content()

        return self.onRendered {
            ($0 as? View)?.inputView = UICAnyView(content).releaseUIView()
        }
    }

    @inlinable
    func inputAccessoryView(content: () -> ViewCreator) -> UICRenderedModifier<View> {
        let content = content()

        return self.onRendered {
            ($0 as? View)?.inputAccessoryView = UICAnyView(content).releaseUIView()
        }
    }

    @inlinable
    func inputDelegate(_ delegate: UITextInputDelegate) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            ($0 as? View)?.inputDelegate = delegate
        }
    }

    @inlinable
    func typingAttributes(_ attributes: [NSAttributedString.Key: Any]?) -> UICNotRenderedModifier<View> {
       self.onNotRendered {
            ($0 as? View)?.typingAttributes = attributes ?? [:]
       }
   }
}
