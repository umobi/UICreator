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
public struct UICActivity: UIViewCreator {
    public typealias View = UIActivityIndicatorView

    @Relay var isAnimating: Bool
    private let style: View.Style

    public init(_ style: View.Style, isAnimating: Relay<Bool>) {
        self.style = style
        self._isAnimating = isAnimating
    }

    @inline(__always)
    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return Views.ActivityIndicatorView()
            .onNotRendered {
                ($0 as? View)?.style = _self.style
            }
            .onNotRendered {
                weak var view = $0 as? View

                _self.$isAnimating.distinctSync {
                    if $0 {
                        view?.startAnimating()
                        return
                    }

                    view?.stopAnimating()
                }
            }
    }
}

public extension UIViewCreator where View: UIActivityIndicatorView {

    @inlinable
    func color(_ color: UIColor) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.color = color
        }
    }

    @inlinable
    func hidesWhenStopped(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.hidesWhenStopped = flag
        }
    }
}

public extension UIViewCreator where View: UIActivityIndicatorView {

    @inlinable
    func color(_ color: Relay<UIColor>) -> UICModifiedView<View> {
        self.onNotRendered { view in
            weak var view = view
            color.sync {
                (view as? View)?.color = $0
            }
        }
    }
}
