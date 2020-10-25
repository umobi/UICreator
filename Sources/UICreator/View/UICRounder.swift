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

public protocol UICManagerContentView {
    func addContent(_ view: UIView)
    func reloadContentLayout()
}

public class RounderView: UIView, UICManagerContentView {
    public var radius: CGFloat {
        didSet {
            self.reloadContentLayout()
        }
    }

    public required init(radius: CGFloat) {
        self.radius = radius
        super.init(frame: .zero)
    }

    public required init(_ view: UIView, radius: CGFloat) {
        self.radius = radius
        super.init(frame: .zero)
        self.addContent(view)
    }

    public override init(frame: CGRect) {
        Fatal.Builder("init(frame:) has not been implemented").die()
    }

    required public init?(coder aDecoder: NSCoder) {
        Fatal.Builder("init(coder:) has not been implemented").die()
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
        self.reloadContentLayout()
        self.renderManager.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.renderManager.traitDidChange()
    }
}

public extension RounderView {

    func addContent(_ view: UIView) {
        CBSubview(self).addSubview(view)

        Constraintable.activate {
            view.cbuild
                .edges
        }
        self.clipsToBounds = true
        self.reloadContentLayout()
    }

    func reloadContentLayout() {
        if self.radius < 1 {
            self.layer.cornerRadius = self.frame.height * self.radius
        } else {
            self.layer.cornerRadius = self.radius
        }
    }

    func border(width: CGFloat, color: UIColor?) {
        self.layer.borderWidth = width
        self.layer.borderColor = color?.cgColor
    }

    @discardableResult
    func border(width: CGFloat) -> Self {
        guard let color = self.layer.borderColor else {
            self.border(width: width, color: UIColor.clear)
            return self
        }

        self.border(width: width, color: UIColor(cgColor: color))
        return self
    }

    @discardableResult
    func border(color: UIColor?) -> Self {
        self.border(width: self.layer.borderWidth, color: color)
        return self
    }
}

public class UICRounder: UIViewCreator {
    public typealias View = RounderView

    public init(radius: CGFloat, content: @escaping () -> ViewCreator) {
        let content = content()
        self.tree.append(content)

        self.loadView { [unowned self] in
            let view = View.init(radius: radius)
            view.updateBuilder(self)
            return view
        }
        .onNotRendered {
            ($0 as? View)?.addContent(content.releaseUIView())
        }
    }
}

public extension UIViewCreator where View: RounderView {
    func borderColor(_ color: UIColor) -> Self {
        self.onNotRendered {
            ($0 as? View)?.border(color: color)
        }
    }

    func borderColor(_ dynamicColor: Relay<UIColor>) -> Self {
        self.onNotRendered {
            weak var view = $0 as? View

            dynamicColor.sync {
                view?.border(color: $0)
            }
        }
    }
}

public extension UIViewCreator where View: RounderView {
    func borderWidth(_ width: CGFloat) -> Self {
        self.onNotRendered {
            ($0 as? View)?.border(width: width)
        }
    }

    func borderWidth(_ dynamicWidth: Relay<CGFloat>) -> Self {
        self.onNotRendered {
            weak var view = $0 as? View

            dynamicWidth.sync {
                view?.border(width: $0)
            }
        }
    }
}

public func UICCircle(content: @escaping () -> ViewCreator) -> UICRounder {
    return .init(radius: 0.5, content: content)
}
