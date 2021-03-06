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

public class Button: UIButton {

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
}

public class UICButton: UIViewCreator, Control {
    public typealias View = Button

    public init(_ title: String?, type: UIButton.ButtonType? = nil) {
        self.loadView { [unowned self] in
            if let type = type {
                let view = View.init(type: type)
                view.updateBuilder(self)
                return view
            }

            return View.init(builder: self)
        }
        .onNotRendered {
            ($0 as? View)?.setTitle(title, for: .normal)
        }
    }

    public init(content: @escaping () -> ViewCreator) {
        let content = content()
        self.tree.append(content)

        self.loadView {
            View(builder: self)
        }.onNotRendered {
            $0.add(content.releaseUIView())
        }
    }
}

public extension UIViewCreator where View: UIButton {

    func title(_ string: String?, for state: UIControl.State = .normal) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.setTitle(string, for: state)
        }
    }

    func title(_ attributedText: NSAttributedString?, for state: UIControl.State = .normal) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.setTitle(attributedText?.string, for: state)
            ($0 as? View)?.titleLabel?.attributedText = attributedText
        }
    }

    func title(color: UIColor?, for state: UIControl.State = .normal) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.setTitleColor(color, for: state)
        }
    }

    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> Self {
        return self.onRendered {
            ($0 as? View)?.titleLabel?.font = font
            ($0 as? View)?.titleLabel?.adjustsFontForContentSizeCategory = isDynamicTextSize
        }
    }
}

public extension UIViewCreator where View: UIButton, Self: Control {
    func onTouchInside(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onEvent(.touchUpInside, handler)
    }
}
