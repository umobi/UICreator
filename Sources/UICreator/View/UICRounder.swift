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

internal class RounderView: UIView, UICManagerContentView {

    init() {
        self.radius = .zero
        super.init(frame: .zero)
        self.makeSelfImplemented()
    }

    public var radius: CGFloat {
        didSet {
            if self.radius != oldValue {
                self.reloadContentLayout()
            }
        }
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

extension RounderView {

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

public struct UICRounder: UIViewCreator {
    public typealias View = UIView

    @MutableBox var borderWidth: Relay<CGFloat> = .constant(.zero)
    @MutableBox var borderColor: Relay<UIColor> = .constant(.clear)

    let radius: CGFloat
    let content: () -> ViewCreator

    public init(radius: CGFloat, content: @escaping () -> ViewCreator) {
        self.radius = radius
        self.content = content
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        guard
            _self.radius != .zero
                && _self.borderColor.wrappedValue != .clear
                && _self.borderWidth.wrappedValue != .zero
        else { return _self.content().releaseUIView() }

        return RounderView()
            .onNotRendered {
                ($0 as? RounderView)?.radius = _self.radius
            }
            .onNotRendered {
                ($0 as? RounderView)?.addContent(_self.content().releaseUIView())
            }
            .onNotRendered {
                weak var view = $0 as? RounderView

                _self.borderColor.sync {
                    view?.border(color: $0)
                }

                _self.borderWidth.sync {
                    view?.border(width: $0)
                }
            }
    }
}

public extension UICRounder {
    func borderColor(_ color: UIColor) -> Self {
        self.borderColor = .constant(color)
        return self
    }

    func borderColor(_ dynamicColor: Relay<UIColor>) -> Self {
        self.borderColor = dynamicColor
        return self
    }
}

public extension UICRounder {
    func borderWidth(_ width: CGFloat) -> Self {
        self.borderWidth = .constant(width)
        return self
    }

    func borderWidth(_ dynamicWidth: Relay<CGFloat>) -> Self {
        self.borderWidth = dynamicWidth
        return self
    }
}
