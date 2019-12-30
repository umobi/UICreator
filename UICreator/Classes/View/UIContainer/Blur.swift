//
//  Blur+ViewCreator.swift
//  Pods
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public class _BlurView: BlurView {
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.commitNotRendered()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }
}

public class Blur: ViewCreator {
    public typealias View = _BlurView

    public init(blur: UIBlurEffect.Style = .regular) {
        self.uiView = View.init(blur: blur)
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
