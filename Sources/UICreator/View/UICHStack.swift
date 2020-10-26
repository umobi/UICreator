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

import UIKit
import ConstraintBuilder

public struct UICHStack: UIViewCreator {
    public typealias View = StackView

    @Relay var spacing: CGFloat
    let content: () -> ViewCreator

    init(
        spacing: CGFloat,
        @UICViewBuilder _ content: @escaping () -> ViewCreator) {

        self.content = content
        self._spacing = .constant(spacing)
    }

    init(
        spacing: Relay<CGFloat>,
        @UICViewBuilder _ content: @escaping () -> ViewCreator) {

        self.content = content
        self._spacing = spacing
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return StackView()
            .onNotRendered {
                ($0 as? View)?.axis = .horizontal
            }
            .onNotRendered {
                weak var view = $0 as? View

                _self.$spacing.sync {
                    view?.spacing = $0
                }
            }
            .onNotRendered {
                weak var view: View! = $0 as? View

                _self.content().zip.forEach {
                    if let forEachCreator = $0 as? ForEachCreator {
                        forEachCreator.manager = StackManager(view)
                    }

                    UIView.CBSubview(view).addArrangedSubview($0.releaseUIView())
                }
            }
    }
}