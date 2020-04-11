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
import UIContainer

public class _BlurView: BlurView {

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

public class UICBlur: UIViewCreator {
    public typealias View = _BlurView

    public init(blur: UIBlurEffect.Style = .regular) {
        self.blur(style: blur)
            .loadView { [unowned self] in
                let view = View.init(blur: blur)
                view.updateBuilder(self)
                return view
            }
    }
}

public extension UIViewCreator where View: BlurView {
    func blur(style: UIBlurEffect.Style) -> Self {
        return self.onRendered {
            ($0 as? View)?.apply(blurEffect: style)
        }
    }

    func blur(dynamic dynamicStyle: TraitObject<UIBlurEffect.Style>) -> Self {
        return self.onRendered {
            ($0 as? View)?.apply(dynamicBlur: dynamicStyle)
        }
    }
}

#if os(iOS)
@available(iOS 13, *)
public extension UIViewCreator where View: BlurView {
    func vibrancy(effect: UIVibrancyEffectStyle) -> Self {
        return self.onRendered {
            ($0 as? View)?.apply(vibrancyEffect: effect)
        }
    }

    func vibrancy(dynamic dynamicEffect: TraitObject<UIVibrancyEffectStyle>) -> Self {
        return self.onRendered {
            ($0 as? View)?.apply(dynamicVibrancy: dynamicEffect)
        }
    }
}
#endif