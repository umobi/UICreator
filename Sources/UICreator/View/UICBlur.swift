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

private var kVibrancyEffectStyle: UInt = 0

#if os(iOS)
@available(iOS 13, *)
public extension UICBlurView {
    fileprivate(set) var vibrancyEffect: UIVibrancyEffectStyle {
        get { return objc_getAssociatedObject(self, &kVibrancyEffectStyle) as! UIVibrancyEffectStyle }
        set { objc_setAssociatedObject(self, &kVibrancyEffectStyle, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}
#endif

public class UICBlurView: UIView {

    private(set) var blurEffect: UIBlurEffect.Style
    weak var blurView: UIVisualEffectView!

    public init(blur: UIBlurEffect.Style) {
        self.blurEffect = blur
        super.init(frame: .zero)

        #if os(iOS)
        if #available(iOS 13, *) {
            self.vibrancyEffect = .fill
        }
        #endif

        self.blurView = self.createEffect()
    }

    #if os(iOS)
    @available(iOS 13, *)
    public init(blur: UIBlurEffect.Style, vibrancy: UIVibrancyEffectStyle) {
        self.blurEffect = blur
        super.init(frame: .zero)
        self.vibrancyEffect = vibrancy

        self.blurView = self.createEffect()
    }
    #endif

    private func createEffect() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: self.blurEffect)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        let vibrancyEffect: UIVibrancyEffect = {
            #if os(iOS)
            guard #available(iOS 13, *) else {
                return UIVibrancyEffect(blurEffect: blurEffect)
            }

            return .init(blurEffect: blurEffect, style: self.vibrancyEffect)
            #else
            return UIVibrancyEffect(blurEffect: blurEffect)
            #endif
        }()
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)

        CBSubview(blurEffectView.contentView).addSubview(vibrancyEffectView)
        vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = false

        Constraintable.activate(
            vibrancyEffectView.cbuild
                .edges
        )

        CBSubview(self).addSubview(blurEffectView)

        Constraintable.activate(
            blurEffectView.cbuild
                .edges
        )

        return blurEffectView
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func reload() {
        self.subviews.forEach { $0.removeFromSuperview() }
        self.blurView = self.createEffect()
    }

    private func reload(_ blurEffect: UIBlurEffect.Style) {
        self.blurEffect = blurEffect
        self.reload()
    }

    #if os(iOS)
    @available(iOS 13, *)
    private func reload(_ vibrancyEffect: UIVibrancyEffectStyle) {
        self.vibrancyEffect = vibrancyEffect
        self.reload()
    }
    #endif

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

public extension UICBlurView {
    func apply(blurEffect: UIBlurEffect.Style) {
        self.reload(blurEffect)
    }
}

#if os(iOS)
@available(iOS 13, *)
public extension UICBlurView {
    func apply(vibrancyEffect: UIVibrancyEffectStyle) {
        self.reload(vibrancyEffect)
    }
}
#endif

public class UICBlur: UIViewCreator {
    public typealias View = UICBlurView

    public init(blur: UIBlurEffect.Style = .regular) {
        self.blur(style: blur)
            .loadView { [unowned self] in
                let view = View.init(blur: blur)
                view.updateBuilder(self)
                return view
            }
    }
}

public extension UIViewCreator where View: UICBlurView {
    func blur(style: UIBlurEffect.Style) -> Self {
        return self.onRendered {
            ($0 as? View)?.apply(blurEffect: style)
        }
    }
}

#if os(iOS)
@available(iOS 13, *)
public extension UIViewCreator where View: UICBlurView {
    func vibrancy(effect: UIVibrancyEffectStyle) -> Self {
        return self.onRendered {
            ($0 as? View)?.apply(vibrancyEffect: effect)
        }
    }
}
#endif
