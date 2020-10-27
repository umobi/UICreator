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
public struct UICGradient: UIViewCreator {
    public typealias View = Views.GradientView

    private let colors: [UIColor]
    private let direction: View.Direction

    public init(_ colors: [UIColor], direction: View.Direction = .right) {
        self.colors = colors
        self.direction = direction
    }

    public init(_ colors: UIColor..., direction: View.Direction = .right) {
        self.colors = colors
        self.direction = direction
    }

    @inline(__always)
    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return View()
            .onNotRendered {
                ($0 as? View)?.direction = _self.direction
                ($0 as? View)?.colors = _self.colors
            }
    }
}

public extension UIViewCreator where View: Views.GradientView {

    @inlinable
    func animation(_ layerHandler: @escaping (CAGradientLayer) -> Void) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.animates(animator: layerHandler)
        }
    }
}
