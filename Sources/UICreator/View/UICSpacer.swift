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

//swiftlint:disable file_length
private class SpacerView: UIView {
    private weak var view: UIView?
    private(set) var margin: UICSpacer.Edges {
        didSet {
            if self.margin != oldValue {
                self.layout()
            }
        }
    }

    init() {
        self.margin = .zero
        super.init(frame: .zero)
        self.makeSelfImplemented()
    }

    public override init(frame: CGRect) {
        Fatal.Builder("init(frame:) has not been implemented").die()
    }

    required init?(coder: NSCoder) {
        Fatal.Builder("init(coder:) has not been implemented").die()
    }

    @discardableResult
    func setMargin(_ margin: UICSpacer.Edges) -> Self {
        self.margin = margin
        return self
    }

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            self.renderManager.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            self.renderManager.frame(newValue)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.renderManager.willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.renderManager.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.renderManager.didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.renderManager.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.renderManager.traitDidChange()
    }

    private func layout() {
        guard let view = self.view else {
            return
        }

        Constraintable.update {
            view.cbuild
                .top
                .equalTo(self)
                .update()
                .constant(self.margin.top)

            view.cbuild
                .bottom
                .equalTo(self)
                .update()
                .constant(self.margin.bottom)

            view.cbuild
                .trailing
                .equalTo(self)
                .update()
                .constant(self.margin.trailing)

            view.cbuild
                .leading
                .equalTo(self)
                .update()
                .constant(self.margin.leading)
        }
    }

    @discardableResult
    public func addContent(_ view: UIView) -> Self {
        self.view = view
        CBSubview(self).addSubview(view)
        self.layout()
        return self
    }

    public func reloadContentLayout() {
        guard self.view != nil else {
            return
        }

        self.layout()
    }
}

public extension UICSpacer {
    struct Edges: Equatable {
        public let top, bottom, leading, trailing: CGFloat

        public init(top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) {
            self.top = top
            self.bottom = bottom
            self.leading = leading
            self.trailing = trailing
        }

        public init(vertical: CGFloat, horizontal: CGFloat) {
            self.init(top: vertical, bottom: vertical, leading: horizontal, trailing: horizontal)
        }

        public init(spacing: CGFloat) {
            self.init(top: spacing, bottom: spacing, leading: spacing, trailing: spacing)
        }

        public static var zero: Edges {
            .init(top: 0, bottom: 0, leading: 0, trailing: 0)
        }

        public static func ==(rhs: Edges, lhs: Edges) -> Bool {
            rhs.top == lhs.top
                && rhs.leading == lhs.leading
                && rhs.trailing == lhs.trailing
                && rhs.bottom == lhs.bottom
        }

        func top(_ constant: CGFloat) -> Self {
            .init(
                top: constant,
                bottom: self.bottom,
                leading: self.leading,
                trailing: self.trailing
            )
        }

        func bottom(_ constant: CGFloat) -> Self {
            .init(
                top: self.top,
                bottom: constant,
                leading: self.leading,
                trailing: self.trailing
            )
        }

        func leading(_ constant: CGFloat) -> Self {
            .init(
                top: self.top,
                bottom: self.bottom,
                leading: constant,
                trailing: self.trailing
            )
        }

        func trailing(_ constant: CGFloat) -> Self {
            .init(
                top: self.top,
                bottom: self.bottom,
                leading: self.leading,
                trailing: constant
            )
        }
    }
}

public struct UICSpacer: UIViewCreator {
    public typealias View = UIView

    @MutableBox var margin: Edges
    let content: () -> ViewCreator

    public init(margin: Edges, content: @escaping () -> ViewCreator) {
        self._margin = .init(wrappedValue: margin)
        self.content = content
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        if _self.margin == .zero {
            return _self.content().releaseUIView()
        }

        return SpacerView()
            .addContent(_self.content().releaseUIView())
            .setMargin(_self.margin)
    }
}

public extension UICSpacer {
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(margin: .init(vertical: vertical, horizontal: horizontal)) {
            EmptyView(SpacerView())
        }
    }

    init(vertical: CGFloat) {
        self.init(margin: .init(vertical: vertical, horizontal: 0)) {
            EmptyView(SpacerView())
        }
    }

    init(horizontal: CGFloat) {
        self.init(margin: .init(vertical: 0, horizontal: horizontal)) {
            EmptyView(SpacerView())
        }
    }

    init() {
        self.init(margin: .init(spacing: 0)) {
            EmptyView(SpacerView())
        }
    }

    init(spacing: CGFloat) {
        self.init(margin: .init(spacing: spacing)) {
            EmptyView(SpacerView())
        }
    }
}

public extension UICSpacer {
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

    init(vertical: CGFloat, horizontal: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(vertical: vertical, horizontal: horizontal), content: content)
    }

    init(vertical: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(vertical: vertical, horizontal: 0), content: content)
    }

    init(horizontal: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(vertical: 0, horizontal: horizontal), content: content)
    }

    init(spacing: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(spacing: spacing), content: content)
    }

    init(content: @escaping () -> ViewCreator) {
        self.init(margin: .init(spacing: 0), content: content)
    }
}

public enum PaddingEdges {
    case top
    case bottom
    case left
    case right
    case all
    case horizontal
    case vertical
}

private extension SpacerView {
    func updatePaddingEdges(_ constant: CGFloat, _ edges: PaddingEdges) {
        self.setMargin({
            switch edges {
            case .all:
                return $0.top(constant)
                    .bottom(constant)
                    .leading(constant)
                    .trailing(constant)

            case .vertical:
                return $0.top(constant)
                    .bottom(constant)

            case .horizontal:
                return $0.leading(constant)
                    .trailing(constant)

            case .top:
                return $0.top(constant)
            case .bottom:
                return $0.bottom(constant)
            case .left:
                return $0.leading(constant)
            case .right:
                return $0.trailing(constant)
            }
        }(self.margin))
    }
}

public extension UIViewCreator {
    func padding(_ constant: CGFloat) -> UICModifiedView<UIView> {
        self.padding(constant, .all)
    }

    //swiftlint:disable function_body_length
    func padding(_ constant: CGFloat, _ edges: PaddingEdges) -> UICModifiedView<UIView> {
        if let spacer = self as? UICSpacer {
            return spacer.onNotRendered {
                ($0 as? SpacerView)?.updatePaddingEdges(constant, edges)
            }
        }

        return UICModifiedView {
            switch edges {
            case .all:
                return UICSpacer(spacing: constant) {
                    self
                }.releaseOperationCastedView()

            case .vertical:
                return UICSpacer(vertical: constant) {
                    self
                }.releaseOperationCastedView()

            case .horizontal:
                return UICSpacer(horizontal: constant) {
                    self
                }.releaseOperationCastedView()

            case .top:
                return UICSpacer(
                    top: constant,
                    bottom: .zero,
                    leading: .zero,
                    trailing: .zero,
                    content: { self }
                ).releaseOperationCastedView()

            case .bottom:
                return UICSpacer(
                    top: .zero,
                    bottom: constant,
                    leading: .zero,
                    trailing: .zero,
                    content: { self }
                ).releaseOperationCastedView()

            case .left:
                return UICSpacer(
                    top: .zero,
                    bottom: .zero,
                    leading: constant,
                    trailing: .zero,
                    content: { self }
                ).releaseOperationCastedView()

            case .right:
                return UICSpacer(
                    top: .zero,
                    bottom: .zero,
                    leading: .zero,
                    trailing: constant,
                    content: { self }
                ).releaseOperationCastedView()
            }
        }
    }
}
