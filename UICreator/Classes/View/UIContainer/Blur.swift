//
//  Blur+ViewBuilder.swift
//  Pods
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public class Blur: BlurView, ViewBuilder {
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

extension ViewBuilder where Self: BlurView  {
    func blur(style: UIBlurEffect.Style) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.apply(blurEffect: style)
        }
    }

    func blur(dynamic dynamicStyle: TraitObject<UIBlurEffect.Style>) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.apply(dynamicBlur: dynamicStyle)
        }
    }
}

@available(iOS 13, *)
extension ViewBuilder where Self: BlurView {
    func vibrancy(effect: UIVibrancyEffectStyle) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.apply(vibrancyEffect: effect)
        }
    }

    func vibrancy(dynamic dynamicEffect: TraitObject<UIVibrancyEffectStyle>) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.apply(dynamicVibrancy: dynamicEffect)
        }
    }
}
