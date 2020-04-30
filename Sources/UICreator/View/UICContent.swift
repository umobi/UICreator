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

public extension UICContentView {
    enum LayoutMode {
        case top
        case topLeft
        case topRight

        case bottom
        case bottomLeft
        case bottomRight

        case left
        case right

        case center
    }
}

public class UICContentView: UIView, UICManagerContentView {
    public var priority: UILayoutPriority {
        didSet {
            self.reloadContentLayout()
        }
    }

    public var layoutMode: LayoutMode {
        didSet {
            self.reloadContentLayout(oldValue)
        }
    }

    weak var view: UIView?
    public required init(_ view: UIView!, contentMode: LayoutMode, priority: UILayoutPriority = .required) {
        self.priority = priority
        self.layoutMode = contentMode
        super.init(frame: .zero)
        self.addContent(view)
    }

    override public init(frame: CGRect) {
        self.priority = .required
        self.layoutMode = .center
        super.init(frame: frame)
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

    public func addContent(_ view: UIView) {
        CBSubview(self).addSubview(view)
        self.view = view

        self.reloadContentLayout()
    }

    public func reloadContentLayout() {
        self.reloadContentLayout(nil)
    }

    private func reloadContentLayout(_ oldLayoutMode: LayoutMode?) {
        guard let view = self.view else {
            return
        }

        self.removeConstraints(oldLayoutMode ?? self.layoutMode)

        switch self.layoutMode {
        case .bottom:
            Constraintable.activate(
                view.cbuild
                    .bottom
                    .priority(priority),

                view.cbuild
                    .centerX
                    .equalTo(self.cbuild.centerX)
                    .priority(priority),

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            )
        case .bottomLeft:
            Constraintable.activate(
                view.cbuild
                    .bottom
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            )

        case .bottomRight:
            Constraintable.activate(
                view.cbuild
                    .bottom
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .trailing
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            )
        case .center:
            Constraintable.activate(
                view.cbuild
                    .center
                    .equalTo(self.cbuild.center)
                    .priority(priority),

                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            )

        case .left:
            Constraintable.activate(
                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .centerY
                    .equalTo(self.cbuild.centerY)
                    .priority(priority)
            )

        case .right:
            Constraintable.activate(
                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .trailing
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .centerY
                    .equalTo(self.cbuild.centerY)
                    .priority(priority)
            )

        case .top:
            Constraintable.activate(
                view.cbuild
                    .top
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .centerX
                    .equalTo(self.cbuild.centerX)
                    .priority(priority)
            )

        case .topLeft:
            Constraintable.activate(
                view.cbuild
                    .top
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            )

        case .topRight:
            Constraintable.activate(
                view.cbuild
                    .top
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .trailing
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            )
        }
    }

    private func removeConstraints(_ oldValue: LayoutMode) {
        guard let view = self.view else {
            return
        }

        switch oldValue {
        case .bottom:
            Constraintable.deactivate(
                view.cbuild
                    .bottom,

                view.cbuild
                    .centerX
                    .equalTo(self.cbuild.centerX),

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .trailing
                    .leading
                    .greaterThanOrEqualTo(0)
            )

        case .bottomLeft:
            Constraintable.deactivate(
                view.cbuild
                    .bottom
                    .equalTo(0),

                view.cbuild
                    .leading
                    .equalTo(0),

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
            )

        case .bottomRight:
            Constraintable.deactivate(
                view.cbuild
                    .bottom
                    .equalTo(0),

                view.cbuild
                    .trailing
                    .equalTo(0),

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
            )

        case .center:
            Constraintable.deactivate(
                view.cbuild
                    .center
                    .equalTo(self.cbuild.center),

                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .trailing
                    .leading
                    .greaterThanOrEqualTo(0)
            )

        case .left:
            Constraintable.deactivate(
                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .leading
                    .equalTo(0),

                view.cbuild
                    .centerY
                    .equalTo(self.cbuild.centerY)
            )

        case .right:
            Constraintable.deactivate(
                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .trailing
                    .equalTo(0),

                view.cbuild
                    .centerY
                    .equalTo(self.cbuild.centerY)
            )

        case .top:
            Constraintable.deactivate(
                view.cbuild
                    .top
                    .bottom
                    .equalTo(0),

                view.cbuild
                    .leading
                    .trailing
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .centerX
                    .equalTo(self.cbuild.centerX)
            )

        case .topLeft:
            Constraintable.deactivate(
                view.cbuild
                    .top
                    .equalTo(0),

                view.cbuild
                    .leading
                    .equalTo(0),

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
            )

        case .topRight:
            Constraintable.deactivate(
                view.cbuild
                    .top
                    .equalTo(0),

                view.cbuild
                    .trailing
                    .equalTo(0),

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
            )
        }
    }
}

public class UICContent: UIViewCreator {
    public typealias View = UICContentView

    public init(mode: View.LayoutMode = .center, priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) {
        let content = content()
        self.tree.append(content)

        self.loadView { [unowned self] in
            View(builder: self)
        }
        .onNotRendered {
            ($0 as? View)?.layoutMode = mode
            ($0 as? View)?.priority = priority
        }
        .onNotRendered {
            ($0 as? View)?.addContent(content.releaseUIView())
        }
    }
}

public func UICCenter(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .center, priority: priority, content: content)
}

public func UICTopLeft(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .topLeft, priority: priority, content: content)
}

public func UICTop(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .top, priority: priority, content: content)
}

public func UICTopRight(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .topRight, priority: priority, content: content)
}

public func UICLeft(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .left, priority: priority, content: content)
}

public func UICRight(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .right, priority: priority, content: content)
}

public func UICBottomLeft(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .bottomLeft, priority: priority, content: content)
}

public func UICBottom(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .bottom, priority: priority, content: content)
}

public func UICBottomRight(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .bottomRight, priority: priority, content: content)
}

public extension UIViewCreator where View: UICContentView {

    func content(mode: UICContentView.LayoutMode) -> Self {
        self.onNotRendered {
            ($0 as? View)?.layoutMode = mode
        }
    }

    func fitting(priority: UILayoutPriority) -> Self {
        self.onNotRendered {
            ($0 as? View)?.priority = priority
        }
    }
}
