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

public class Button: UIButton {

    init() {
        super.init(frame: .zero)
        self.makeSelfImplemented()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
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
}

public class UICButton: UIViewCreator {
    public typealias View = Button

    private enum Inicialization {
        case `dynamic`(() -> ViewCreator)
        case title(String)
        case style(UIButton.ButtonType)
    }

    private let inicialization: Inicialization

    public init(_ title: String) {
        self.inicialization = .title(title)
    }

    public init(_ style: UIButton.ButtonType) {
        self.inicialization = .style(style)
    }

    public init(content: @escaping () -> ViewCreator) {
        self.inicialization = .dynamic(content)
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        switch _self.inicialization {
        case .dynamic(let content):
            return View().onNotRendered {
                $0.add(content().releaseUIView())
            }

        case .style(let style):
            return View(type: style)
                .makeSelfImplemented()

        case .title(let title):
            return View()
                .onNotRendered {
                    ($0 as? View)?.setTitle(title, for: .normal)
                }
        }
    }
}

public extension UIViewCreator where View: UIButton {

    func title(_ string: String?, for state: UIControl.State = .normal) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.setTitle(string, for: state)
        }
    }

    func title(_ attributedText: NSAttributedString?, for state: UIControl.State = .normal) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.setTitle(attributedText?.string, for: state)
            ($0 as? View)?.titleLabel?.attributedText = attributedText
        }
    }

    func title(color: UIColor?, for state: UIControl.State = .normal) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.setTitleColor(color, for: state)
        }
    }

    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.titleLabel?.font = font
            ($0 as? View)?.titleLabel?.adjustsFontForContentSizeCategory = isDynamicTextSize
        }
    }
}

public extension UIViewCreator where View: UIButton {
    func onTouchInside(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onEvent(.touchUpInside, handler)
    }
}
