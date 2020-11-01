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
public struct UICInput: UIViewCreator {
    public typealias View = UIInputView

    private let frame: CGRect
    private let style: UIInputView.Style
    private let content: () -> ViewCreator

    public init(
        x: CGFloat = .zero,
        y: CGFloat = .zero,
        height: CGFloat = .zero,
        width: CGFloat = .zero,
        style: UIInputView.Style = .keyboard,
        content: @escaping () -> ViewCreator) {

        self.frame = .init(x: x, y: y, width: width, height: height)
        self.style = style
        self.content = content
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        if _self.frame.height == .zero || _self.frame.width == .zero {
            let contentView = _self.content().releaseUIView()

            return Views.InputView(
                frame: {
                    let possibleSize = contentView.sizeThatFits(UIScreen.main.bounds.size)

                    return .init(
                        x: _self.frame.origin.x,
                        y: _self.frame.origin.y,
                        width: _self.frame.width == .zero ? possibleSize.width : _self.frame.width,
                        height: _self.frame.height == .zero ? possibleSize.height : _self.frame.height
                    )
                }(),
                style: _self.style
            ).onNotRendered {
                $0.add(contentView)
            }
        }

        return Views.InputView(frame: _self.frame, style: _self.style)
            .onNotRendered {
                $0.add(_self.content().releaseUIView())
            }
    }
}

public extension UIViewCreator where View: UIInputView {

    @inlinable
    func allowsSelfsSizing(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.allowsSelfSizing = flag
        }
    }
}
