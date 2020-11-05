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

public extension Views {
    class BlurView: CBView {

        private(set) var blurEffect: UIBlurEffect.Style
        private(set) weak var blurView: UIVisualEffectView!

        init() {
            self.blurEffect = .regular
            super.init(frame: .zero)
            self.makeSelfImplemented()

            #if os(iOS)
            if #available(iOS 13, *) {
                self.vibrancyEffect = .fill
            }
            #endif

            self.blurView = self.createEffect()
        }

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

            Constraintable.activate {
                vibrancyEffectView.cbuild
                    .edges
            }

            CBSubview(self).addSubview(blurEffectView)

            Constraintable.activate {
                blurEffectView.cbuild
                    .edges
            }

            return blurEffectView
        }

        public required init?(coder: NSCoder) {
            Fatal.Builder("init(coder:) has not been implemented").die()
        }

        public override init(frame: CGRect) {
            Fatal.Builder("init(frame:) has not been implemented").die()
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
}

#if os(iOS)
private var kVibrancyEffectStyle: UInt = 0

@available(iOS 13, *)
internal extension Views.BlurView {
    fileprivate(set) var vibrancyEffect: UIVibrancyEffectStyle! {
        get { objc_getAssociatedObject(self, &kVibrancyEffectStyle) as? UIVibrancyEffectStyle }
        set { objc_setAssociatedObject(self, &kVibrancyEffectStyle, newValue, .OBJC_ASSOCIATION_COPY) }
    }
}
#endif

internal extension Views.BlurView {
    @usableFromInline
    func apply(blurEffect: UIBlurEffect.Style) {
        self.reload(blurEffect)
    }
}

#if os(iOS)
@available(iOS 13, *)
internal extension Views.BlurView {
    @usableFromInline
    func apply(vibrancyEffect: UIVibrancyEffectStyle) {
        self.reload(vibrancyEffect)
    }
}
#endif