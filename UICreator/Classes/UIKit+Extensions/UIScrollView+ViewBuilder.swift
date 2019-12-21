//
//  UIScrollView+ViewBuilder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public extension ViewBuilder where Self: UIScrollView {
    @available(iOS 11.0, *)
    func insets(behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.contentInsetAdjustmentBehavior = behavior
        }
    }

    func alwaysBounce(vertical flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.alwaysBounceVertical = flag
        }
    }

    func alwaysBounce(horizontal flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.alwaysBounceHorizontal = flag
        }
    }

    @available(iOS 13, *)
    func automaticallyAdjustsScroll(indicatorInsets flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.automaticallyAdjustsScrollIndicatorInsets = flag
        }
    }

    func bounces(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.bounces = flag
        }
    }

    func canCancelContentTouches(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.canCancelContentTouches = flag
        }
    }

    func content(insets: UIEdgeInsets) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.contentInset = insets
        }
    }

    func content(size: CGSize) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.contentSize = size
        }
    }

    func isPagingEnabled(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.isPagingEnabled = flag
        }
    }

    func isDirectionalLockEnabled(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.isDirectionalLockEnabled = flag
        }
    }

    func isScrollEnabled(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.isScrollEnabled = flag
        }
    }

    func showsVerticalScrollIndicator(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.showsVerticalScrollIndicator = flag
        }
    }

    func showsHorizontalScrollIndicator(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.showsHorizontalScrollIndicator = flag
        }
    }

    func indicator(style: IndicatorStyle) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.indicatorStyle = style
        }
    }

    @available(iOS 11.1, *)
    func verticalScroll(indicatorInsets: UIEdgeInsets) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.verticalScrollIndicatorInsets = indicatorInsets
        }
    }

    @available(iOS 11.1, *)
    func horizontalScroll(indicatorInsets: UIEdgeInsets) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.horizontalScrollIndicatorInsets = indicatorInsets
        }
    }

    @available(*, deprecated, message: "use verticalScroll(indicatorInsets:) and horizontalScroll(indicatorInsets:)")
    func scroll(indicatorInsets: UIEdgeInsets) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.scrollIndicatorInsets = indicatorInsets
        }
    }
}
