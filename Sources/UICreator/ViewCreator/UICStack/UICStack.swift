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
public struct UICStack: UIViewCreator {
    public typealias View = UIStackView

    @Relay private var axis: Axis
    @Relay private var spacing: CGFloat
    private let content: () -> ViewCreator

    public init(
        axis: Relay<Axis>,
        spacing: CGFloat = .zero,
        @UICViewBuilder _ content: @escaping () -> ViewCreator) {

        self._axis = axis
        self.content = content
        self._spacing = .constant(spacing)
    }

    public init(
        axis: Relay<Axis>,
        spacing: Relay<CGFloat>,
        @UICViewBuilder _ content: @escaping () -> ViewCreator) {

        self._axis = axis
        self.content = content
        self._spacing = spacing
    }

    @inline(__always)
    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return Views.StackView()
            .onNotRendered {
                weak var view = $0 as? View

                _self.$axis.sync {
                    view?.axis = $0.uiAxis
                }
            }
            .onNotRendered {
                weak var view = $0 as? View

                _self.$spacing.sync {
                    view?.spacing = $0
                }
            }
            .onNotRendered {
                weak var view: Views.StackView! = $0 as? Views.StackView

                _self.content().zip.forEach {
                    if let forEachShared = $0 as? ForEachEnviromentShared {
                        let stackManager = Views.StackView.Manager(view)
                        view.strongStackManager(stackManager)
                        forEachShared.enviroment.setManager(stackManager)
                    }

                    UIView.CBSubview(view).addArrangedSubview($0.releaseUIView())
                }
            }
    }
}

public extension UIViewCreator where View: UIStackView {

    @inlinable
    func distribution(_ distribution: View.Distribution) -> UICModifiedView<View> {
        return self.onNotRendered {
            ($0 as? View)?.distribution = distribution
        }
    }

    @inlinable
    func alignment(_ alignment: View.Alignment) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.alignment = alignment
        }
    }
}
