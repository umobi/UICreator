//
//  Scroll.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public class _ScrollView: ScrollView {
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

public class Scroll: UIViewCreator, HasViewDelegate {
    public typealias View = _ScrollView

    public init(axis: View.Axis = .vertical, content: @escaping () -> ViewCreator) {
        self.uiView = View.init(content().uiView, axis: axis)
    }

    public func delegate(_ delegate: UIScrollViewDelegate?) -> Self {
        (self.uiView as? View)?.delegate = delegate
        return self
    }
}

public func VScroll(_ content: @escaping () -> ViewCreator) -> Scroll {
    return .init(axis: .vertical, content: content)
}

public func HScroll(_ content: @escaping () -> ViewCreator) -> Scroll {
    return .init(axis: .horizontal, content: content)
}

public extension UIViewCreator where View: UIScrollView {
    @available(iOS 11.0, tvOS 11.0, *)
    func insets(behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        self.onNotRendered {
            ($0 as? View)?.contentInsetAdjustmentBehavior = behavior
        }
    }

    func alwaysBounce(vertical flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.alwaysBounceVertical = flag
        }
    }

    func alwaysBounce(horizontal flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.alwaysBounceHorizontal = flag
        }
    }

    @available(iOS 13, tvOS 13.0, *)
    func automaticallyAdjustsScroll(indicatorInsets flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.automaticallyAdjustsScrollIndicatorInsets = flag
        }
    }

    func bounces(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.bounces = flag
        }
    }

    func canCancelContentTouches(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.canCancelContentTouches = flag
        }
    }

    func content(insets: UIEdgeInsets) -> Self {
        self.onInTheScene {
            ($0 as? View)?.contentInset = insets
        }
    }

    func content(size: CGSize) -> Self {
        self.onInTheScene {
            ($0 as? View)?.contentSize = size
        }
    }

    #if os(iOS)
    func isPagingEnabled(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.isPagingEnabled = flag
        }
    }
    #endif

    func isDirectionalLockEnabled(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.isDirectionalLockEnabled = flag
        }
    }

    func isScrollEnabled(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.isScrollEnabled = flag
        }
    }

    func showsVerticalScrollIndicator(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.showsVerticalScrollIndicator = flag
        }
    }

    func showsHorizontalScrollIndicator(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.showsHorizontalScrollIndicator = flag
        }
    }

    func indicator(style: View.IndicatorStyle) -> Self {
        self.onNotRendered {
            ($0 as? View)?.indicatorStyle = style
        }
    }

    @available(iOS 11.1, tvOS 11.1, *)
    func verticalScroll(indicatorInsets: UIEdgeInsets) -> Self {
        self.onInTheScene {
            ($0 as? View)?.verticalScrollIndicatorInsets = indicatorInsets
        }
    }

    @available(iOS 11.1, tvOS 11.1, *)
    func horizontalScroll(indicatorInsets: UIEdgeInsets) -> Self {
        self.onInTheScene {
            ($0 as? View)?.horizontalScrollIndicatorInsets = indicatorInsets
        }
    }

    @available(*, deprecated, message: "use verticalScroll(indicatorInsets:) and horizontalScroll(indicatorInsets:)")
    func scroll(indicatorInsets: UIEdgeInsets) -> Self {
        self.onInTheScene {
            ($0 as? View)?.scrollIndicatorInsets = indicatorInsets
        }
    }
}
