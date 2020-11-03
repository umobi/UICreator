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
public struct UICButton: UIViewCreator {
    public typealias View = UIButton

    @usableFromInline
    enum Content {
        case `dynamic`(ViewCreator)
        case title(String)
        case style(UIButton.ButtonType)
    }

    @usableFromInline
    let content: Content

    public init(_ title: String) {
        self.content = .title(title)
    }

    public init(_ style: UIButton.ButtonType) {
        self.content = .style(style)
    }

    public init(content: () -> ViewCreator) {
        self.content = .dynamic(content())
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        switch _self.content {
        case .dynamic(let content):
            return Views.Button()
                .onNotRendered {
                    $0.add(content.releaseUIView())
                }

        case .style(let style):
            return Views.Button(type: style)
                .makeSelfImplemented()

        case .title(let title):
            return Views.Button()
                .onNotRendered {
                    ($0 as? View)?.setTitle(title, for: .normal)
                }
        }
    }
}

public extension UIViewCreator where View: UIButton {

    @inlinable
    func title(_ string: String?, for state: UIControl.State = .normal) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.setTitle(string, for: state)
        }
    }

    @inlinable
    func title(_ attributedText: NSAttributedString?, for state: UIControl.State = .normal) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.setTitle(attributedText?.string, for: state)
            ($0 as? View)?.titleLabel?.attributedText = attributedText
        }
    }

    @inlinable
    func titleColor(_ color: UIColor?, for state: UIControl.State = .normal) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.setTitleColor(color, for: state)
        }
    }

    @inlinable
    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.titleLabel?.font = font
            ($0 as? View)?.titleLabel?.adjustsFontForContentSizeCategory = isDynamicTextSize
        }
    }
}

public extension UIViewCreator where View: UIButton {

    @inlinable
    func onTouchInside(_ handler: @escaping (CBView) -> Void) -> UICNotRenderedModifier<View> {
        self.onEvent(.touchUpInside, handler)
    }
}
