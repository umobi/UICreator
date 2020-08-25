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

public class SpacerView: UIView, UICManagerContentView {
    private weak var view: UIView?
    private(set) var margin: Edges

    public required init(_ view: UIView!, margin: Edges) {
        self.margin = margin
        super.init(frame: .zero)

        self.addContent(view)
    }

    public required init(margin: Edges) {
        self.margin = margin
        super.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        Fatal.Builder("init(frame:) has not been implemented").die()
    }

    required init?(coder: NSCoder) {
        Fatal.Builder("init(coder:) has not been implemented").die()
    }

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            RenderManager(self)?.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            RenderManager(self)?.frame(newValue)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self)?.willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self)?.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self)?.didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self)?.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        RenderManager(self)?.traitDidChange()
    }

    private func setMargin(_ margin: Edges) {
        guard self.view != nil else {
            return
        }

        self.margin = margin
        self.layout()
    }

    func updateMargin(_ updateHandler: (Edges) -> Edges) {
        self.setMargin(updateHandler(self.margin))
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

    public func addContent(_ view: UIView) {
        self.view = view
        CBSubview(self).addSubview(view)
        self.layout()
    }

    public func reloadContentLayout() {
        guard self.view != nil else {
            return
        }

        self.layout()
    }
}

public extension SpacerView {
    struct Edges {
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
            return .init(top: 0, bottom: 0, leading: 0, trailing: 0)
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

public class UICSpacer: UIViewCreator {
    public typealias View = SpacerView

    public required init(margin: View.Edges, content: @escaping () -> ViewCreator) {
        let content = content()
        self.tree.append(content)

        self.loadView { [unowned self] in
            let view = View(margin: margin)
            view.updateBuilder(self)
            return view
        }
        .onNotRendered {
            ($0 as? View)?.addContent(content.releaseUIView())
        }
    }
}

public class UICEmpty: ViewCreator {
    public init() {
        self.loadView { [unowned self] in
            UIView(builder: self)
        }
    }
}

public extension UICSpacer {
    convenience init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(margin: .init(vertical: vertical, horizontal: horizontal)) {
            UICEmpty()
        }
    }

    convenience init(vertical: CGFloat) {
        self.init(margin: .init(vertical: vertical, horizontal: 0)) {
            UICEmpty()
        }
    }

    convenience init(horizontal: CGFloat) {
        self.init(margin: .init(vertical: 0, horizontal: horizontal)) {
            UICEmpty()
        }
    }

    convenience init() {
        self.init(margin: .init(spacing: 0)) {
            UICEmpty()
        }
    }

    convenience init(spacing: CGFloat) {
        self.init(margin: .init(spacing: spacing)) {
            UICEmpty()
        }
    }
}

public extension UICSpacer {
    convenience init(
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

    convenience init(vertical: CGFloat, horizontal: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(vertical: vertical, horizontal: horizontal), content: content)
    }

    convenience init(vertical: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(vertical: vertical, horizontal: 0), content: content)
    }

    convenience init(horizontal: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(vertical: 0, horizontal: horizontal), content: content)
    }

    convenience init(spacing: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(spacing: spacing), content: content)
    }

    convenience init(content: @escaping () -> ViewCreator) {
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
        self.updateMargin {
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
        }
    }
}

public extension ViewCreator {
    func padding(_ constant: CGFloat) -> UICSpacer {
        self.padding(constant, .all)
    }

    func padding(_ constant: CGFloat,_ edges: PaddingEdges) -> UICSpacer {
        if let spacer = self as? UICSpacer {
            return spacer.onNotRendered {
                ($0 as? SpacerView)?.updatePaddingEdges(constant, edges)
            }
        }

        switch edges {
        case .all:
            return UICSpacer(spacing: constant) {
                self
            }
        case .vertical:
            return UICSpacer(vertical: constant) {
                self
            }
        case .horizontal:
            return UICSpacer(horizontal: constant) {
                self
            }
        case .top:
            return UICSpacer(
                top: constant,
                bottom: .zero,
                leading: .zero,
                trailing: .zero,
                content: { self }
            )
        case .bottom:
            return UICSpacer(
                top: .zero,
                bottom: constant,
                leading: .zero,
                trailing: .zero,
                content: { self }
            )
        case .left:
            return UICSpacer(
                top: .zero,
                bottom: .zero,
                leading: constant,
                trailing: .zero,
                content: { self }
            )
        case .right:
            return UICSpacer(
                top: .zero,
                bottom: .zero,
                leading: .zero,
                trailing: constant,
                content: { self }
            )
        }
    }
}
