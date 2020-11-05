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

    let margin: Edges
    let content: ViewCreator

    public init(margin: Edges, content: () -> ViewCreator) {
        self.margin = margin
        self.content = content()
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        if _self.margin == .zero {
            return _self.content.releaseUIView()
        }

        return Views.SpacerView()
            .addContent(_self.content.releaseUIView())
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
        content: () -> ViewCreator) {

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
    init(vertical: CGFloat, horizontal: CGFloat, content: () -> ViewCreator) {
        self.init(margin: .init(vertical: vertical, horizontal: horizontal), content: content)
    }

    @inline(__always)
    init(vertical: CGFloat, content: () -> ViewCreator) {
        self.init(margin: .init(vertical: vertical, horizontal: 0), content: content)
    }

    @inline(__always)
    init(horizontal: CGFloat, content: () -> ViewCreator) {
        self.init(margin: .init(vertical: 0, horizontal: horizontal), content: content)
    }

    @inline(__always)
    init(spacing: CGFloat, content: () -> ViewCreator) {
        self.init(margin: .init(spacing: spacing), content: content)
    }

    @inline(__always)
    init(content: () -> ViewCreator) {
        self.init(margin: .init(spacing: 0), content: content)
    }
}

extension Set where Element == PaddingEdges {
    func `if`(_ actualElement: PaddingEdges, contains element: PaddingEdges, and otherElement: PaddingEdges, return thisElement: PaddingEdges, elseUnionWith unionThisElement: PaddingEdges) -> Set<Element> {
        if self.contains(element) {
            if self.contains(otherElement) {
                return [thisElement]
            }

            return self.filter { $0 == element }.union([unionThisElement])
        }

        return self.union([actualElement])
    }

    @usableFromInline
    func margin(_ constant: CGFloat) -> UICSpacer.Edges {
        self.reduce(.zero) {
            switch $1 {
            case .all:
                return UICSpacer.Edges(spacing: constant)
            case .vertical:
                return UICSpacer.Edges(
                    top: constant,
                    bottom: constant,
                    leading: $0.leading,
                    trailing: $0.trailing
                )
            case .horizontal:
                return UICSpacer.Edges(
                    top: $0.top,
                    bottom: $0.bottom,
                    leading: constant,
                    trailing: constant
                )
            case .top:
                return UICSpacer.Edges(
                    top: constant,
                    bottom: $0.bottom,
                    leading: $0.leading,
                    trailing: $0.trailing
                )
            case .bottom:
                return UICSpacer.Edges(
                    top: $0.top,
                    bottom: constant,
                    leading: $0.leading,
                    trailing: $0.trailing
                )
            case .left:
                return UICSpacer.Edges(
                    top: $0.top,
                    bottom: $0.bottom,
                    leading: constant,
                    trailing: $0.trailing
                )
            case .right:
                return UICSpacer.Edges(
                    top: $0.top,
                    bottom: $0.bottom,
                    leading: $0.leading,
                    trailing: constant
                )
            }
        }
    }
}

extension Array where Element == PaddingEdges {

    @usableFromInline
    var reduced: Set<PaddingEdges> {
        Set(self).reduce(Set<PaddingEdges>()) {
            switch $1 {
            case .all:
                return .init(arrayLiteral: $1)
            case .bottom:
                return $0.if(
                    .bottom,
                    contains: .top,
                    and: .horizontal,
                    return: .all,
                    elseUnionWith: .vertical
                )
            case .top:
                return $0.if(
                    .top,
                    contains: .bottom,
                    and: .horizontal,
                    return: .all,
                    elseUnionWith: .vertical
                )
            case .left:
                return $0.if(
                    .left,
                    contains: .right,
                    and: .vertical,
                    return: .all,
                    elseUnionWith: .horizontal
                )
            case .right:
                return $0.if(
                    .right,
                    contains: .left,
                    and: .vertical,
                    return: .all,
                    elseUnionWith: .horizontal
                )
            case .vertical:
                if $0.contains(.horizontal) {
                    return [.all]
                }

                return $0.filter { $0 == .top || $0 == .bottom }.union([.vertical])
            case .horizontal:
                if $0.contains(.vertical) {
                    return [.all]
                }

                return $0.filter { $0 == .left || $0 == .right }.union([.horizontal])
            }
        }
    }
}

public extension UIViewCreator {

    @inline(__always) @inlinable
    func padding(_ constant: CGFloat) -> UICSpacer {
        UICSpacer(margin: .init(spacing: constant), content: { self })
    }

    @inlinable
    func padding(_ constant: CGFloat, _ edges: PaddingEdges...) -> UICSpacer {
        UICSpacer(margin: edges.reduced.margin(constant), content: { self })
    }
}

public extension UICSpacer {
    @inline(__always)
    func padding(_ constant: CGFloat) -> UICSpacer {
        UICSpacer(margin: .init(spacing: constant), content: { content })
    }
}

public extension UICSpacer {
    @inline(__always)
    func padding(_ constant: CGFloat, _ edges: PaddingEdges...) -> UICSpacer {
        let margin = edges.reduced.margin(constant)

        return UICSpacer(margin: {
            .init(
                top: margin.top == constant ? margin.top : self.margin.top,
                bottom: margin.bottom == constant ? margin.bottom : self.margin.bottom,
                leading: margin.leading == constant ? margin.leading : self.margin.leading,
                trailing: margin.trailing == constant ? margin.trailing : self.margin.trailing
            )
        }(), content: { content })
    }
}
