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
public struct UICLabel: UIViewCreator {
    public typealias View = UILabel

    @usableFromInline
    enum Content {
        case string(String?)
        case attributed(NSAttributedString?)
    }

    @Relay private var text: Content

    public init(_ text: String?) {
        self._text = .constant(.string(text))
    }

    public init(_ attributedText: NSAttributedString?) {
        self._text = .constant(.attributed(attributedText))
    }

    public init(_ text: Relay<String?>) {
        self._text = text.map { .string($0) }
    }

    public init(_ attributedText: Relay<NSAttributedString?>) {
        self._text = attributedText.map { .attributed($0) }
    }

    @inline(__always)
    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return Views.Label()
            .onNotRendered {
                weak var view = $0 as? View

                _self.$text.sync {
                    switch $0 {
                    case .string(let string):
                        view?.text = string
                    case .attributed(let attributed):
                        view?.attributedText = attributed
                    }
                }
            }
    }
}

public extension UIViewCreator where View: UILabel {

    @inlinable
    func textColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.textColor = color
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
        self.onNotRendered {
            ($0 as? View)?.minimumScaleFactor = scale
            ($0 as? View)?.adjustsFontSizeToFitWidth = scale != 1
        }
    }

    @inlinable
    func textAlignment(_ alignment: NSTextAlignment) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.textAlignment = alignment
        }
    }

    @inlinable
    func numberOfLines(_ number: Int) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.numberOfLines = number
        }
    }
}

public extension UIViewCreator where View: UILabel {

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
}

public extension UIViewCreator where View: UILabel {

    @inlinable
    func lineBreakMode(_ mode: NSLineBreakMode) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.lineBreakMode = mode
        }
    }
}

public extension UIViewCreator where View: UILabel {

    @inlinable
    func textColor(_ relay: Relay<UIColor>) -> UICModifiedView<View> {
        self.onNotRendered {
            weak var view = $0 as? View
            relay.sync {
                view?.textColor = $0
            }
        }
    }
}

public extension UIViewCreator where View: UILabel {

    @inlinable
    func font(_ relay: Relay<UIFont>) -> UICModifiedView<View> {
        self.onNotRendered {
            weak var view = $0 as? View
            relay.sync {
                view?.font = $0
            }
        }
    }
}
