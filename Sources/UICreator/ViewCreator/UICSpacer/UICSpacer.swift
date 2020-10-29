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
public struct UICSpacer: UIViewCreator {
    public typealias View = CBView

    @MutableBox var margin: Edges
    let content: () -> ViewCreator

    public init(margin: Edges, content: @escaping () -> ViewCreator) {
        self._margin = .init(wrappedValue: margin)
        self.content = content
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        if _self.margin == .zero {
            return _self.content().releaseUIView()
        }

        return Views.SpacerView()
            .addContent(_self.content().releaseUIView())
            .setMargin(_self.margin)
    }
}

public extension UICSpacer {

    @inline(__always)
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(margin: .init(vertical: vertical, horizontal: horizontal)) {
            UICAnyView(Views.SpacerView())
        }
    }

    @inline(__always)
    init(vertical: CGFloat) {
        self.init(margin: .init(vertical: vertical, horizontal: 0)) {
            UICAnyView(Views.SpacerView())
        }
    }

    @inline(__always)
    init(horizontal: CGFloat) {
        self.init(margin: .init(vertical: 0, horizontal: horizontal)) {
            UICAnyView(Views.SpacerView())
        }
    }

    @inline(__always)
    init() {
        self.init(margin: .zero) {
            UICAnyView(Views.SpacerView())
        }
    }

    @inline(__always)
    init(spacing: CGFloat) {
        self.init(margin: .init(spacing: spacing)) {
            UICAnyView(Views.SpacerView())
        }
    }
}

public extension UICSpacer {

    @inline(__always)
    init(
        top: CGFloat,
        bottom: CGFloat,
        leading: CGFloat,
        trailing: CGFloat,
        content: @escaping () -> ViewCreator) {

        self.init(
            margin: .init(
                top: top,
                bottom: bottom,
                leading: leading,
                trailing: trailing
            ),
            content: content
        )
    }

    @inline(__always)
    init(vertical: CGFloat, horizontal: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(vertical: vertical, horizontal: horizontal), content: content)
    }

    @inline(__always)
    init(vertical: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(vertical: vertical, horizontal: 0), content: content)
    }

    @inline(__always)
    init(horizontal: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(vertical: 0, horizontal: horizontal), content: content)
    }

    @inline(__always)
    init(spacing: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(spacing: spacing), content: content)
    }

    @inline(__always)
    init(content: @escaping () -> ViewCreator) {
        self.init(margin: .init(spacing: 0), content: content)
    }
}

public extension UIViewCreator {

    @inline(__always)
    func padding(_ constant: CGFloat) -> UICModifiedView<CBView> {
        self.padding(constant, .all)
    }

    @inlinable
    func padding(_ constant: CGFloat, _ edges: PaddingEdges) -> UICModifiedView<CBView> {
        UICModifiedView {
            let view = self.releaseUIView()

            if let spacerView = view as? Views.SpacerView {
                spacerView.updatePaddingEdges(constant, edges)
                return spacerView
            }

            switch edges {
            case .all:
                return UICSpacer(spacing: constant) {
                    UICAnyView {
                        view
                    }
                }.releaseOperationCastedView()

            case .vertical:
                return UICSpacer(vertical: constant) {
                    UICAnyView {
                        view
                    }
                }.releaseOperationCastedView()

            case .horizontal:
                return UICSpacer(horizontal: constant) {
                    UICAnyView {
                        view
                    }
                }.releaseOperationCastedView()

            case .top:
                return UICSpacer(
                    top: constant,
                    bottom: .zero,
                    leading: .zero,
                    trailing: .zero,
                    content: {
                        UICAnyView {
                            view
                        }
                    }
                ).releaseOperationCastedView()

            case .bottom:
                return UICSpacer(
                    top: .zero,
                    bottom: constant,
                    leading: .zero,
                    trailing: .zero,
                    content: {
                        UICAnyView {
                            view
                        }
                    }
                ).releaseOperationCastedView()

            case .left:
                return UICSpacer(
                    top: .zero,
                    bottom: .zero,
                    leading: constant,
                    trailing: .zero,
                    content: {
                        UICAnyView {
                            view
                        }
                    }
                ).releaseOperationCastedView()

            case .right:
                return UICSpacer(
                    top: .zero,
                    bottom: .zero,
                    leading: .zero,
                    trailing: constant,
                    content: {
                        UICAnyView {
                            view
                        }
                    }
                ).releaseOperationCastedView()
            }
        }
    }
}
