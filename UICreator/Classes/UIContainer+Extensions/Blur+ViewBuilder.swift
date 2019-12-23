//
//  Blur+ViewBuilder.swift
//  Pods
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

extension Blur: ViewBuilder {
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
extension Blur {
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

