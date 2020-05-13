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

public class UICSpacerView: UIView, UICManagerContentView {
    private weak var view: UIView?
    let margin: Edges

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
        fatalError("init(frame:) has not been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    private func layout() {
        guard let view = self.view else {
            return
        }

        Constraintable.update(
            view.cbuild
                .top
                .equalTo(self)
                .update()
                .constant(self.margin.top),

            view.cbuild
                .bottom
                .equalTo(self)
                .update()
                .constant(self.margin.bottom),

            view.cbuild
                .trailing
                .equalTo(self)
                .update()
                .constant(self.margin.trailing),

            view.cbuild
                .leading
                .equalTo(self)
                .update()
                .constant(self.margin.leading)
        )
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

public extension UICSpacerView {
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
    }
}

public class UICSpacer: UIViewCreator {
    public typealias View = UICSpacerView

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
    public typealias View = UIView

    public init() {
        self.loadView { [unowned self] in
            View(builder: self)
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
    convenience init(top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat, content: @escaping () -> ViewCreator) {
        self.init(margin: .init(top: top, bottom: bottom, leading: leading, trailing: trailing), content: content)
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
