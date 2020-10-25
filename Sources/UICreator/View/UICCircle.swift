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

public struct UICCircle: UIViewCreator {
    public typealias View = UIView

    @MutableBox var borderWidth: Relay<CGFloat> = .constant(.zero)
    @MutableBox var borderColor: Relay<UIColor> = .constant(.clear)

    let content: () -> ViewCreator

    public init(_ content: @escaping () -> ViewCreator) {
        self.content = content
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return RounderView()
            .onNotRendered {
                ($0 as? RounderView)?.radius = 0.5
                ($0 as? RounderView)?.addContent(_self.content().releaseUIView())
            }
            .onNotRendered {
                weak var view = $0 as? RounderView

                _self.borderColor.sync {
                    view?.border(color: $0)
                }

                _self.borderWidth.sync {
                    view?.border(width: $0)
                }
            }
    }
}

public extension UICCircle {
    func borderColor(_ color: UIColor) -> Self {
        self.borderColor = .constant(color)
        return self
    }

    func borderColor(_ dynamicColor: Relay<UIColor>) -> Self {
        self.borderColor = dynamicColor
        return self
    }
}

public extension UICCircle {
    func borderWidth(_ width: CGFloat) -> Self {
        self.borderWidth = .constant(width)
        return self
    }

    func borderWidth(_ dynamicWidth: Relay<CGFloat>) -> Self {
        self.borderWidth = dynamicWidth
        return self
    }
}
