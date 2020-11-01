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

@frozen
public struct UICScroll: UIViewCreator {
    public typealias View = UIScrollView

    @Relay var axis: Axis
    let content: () -> ViewCreator

    public init(
        axis: Relay<Axis>,
        content: @escaping () -> ViewCreator) {

        self.content = content
        self._axis = axis
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return Views.ScrollView(_self.axis)
            .onNotRendered {
                ($0 as? Views.ScrollView)?.addContent(_self.content().releaseUIView())
            }
            .onNotRendered {
                weak var view = $0 as? Views.ScrollView

                _self.$axis.sync {
                    view?.axis = $0
                }
            }
    }
}

public extension UIViewCreator where View: UIScrollView {
    @available(iOS 11.0, tvOS 11.0, *)
    @inlinable
    func insetsBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.contentInsetAdjustmentBehavior = behavior
        }
    }

    @inlinable
    func alwaysBounceVertical(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.alwaysBounceVertical = flag
        }
    }

    @inlinable
    func alwaysBounceHorizontal(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.alwaysBounceHorizontal = flag
        }
    }

    @available(iOS 13, tvOS 13.0, *)
    @inlinable
    func automaticallyAdjustsScroll(indicatorInsets flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.automaticallyAdjustsScrollIndicatorInsets = flag
        }
    }

    @inlinable
    func bounces(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.bounces = flag
        }
    }

    @inlinable
    func canCancelContentTouches(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.canCancelContentTouches = flag
        }
    }

    @inlinable
    func contentInsets(_ insets: UIEdgeInsets) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            ($0 as? View)?.contentInset = insets
        }
    }

    @inlinable
    func contentSize(_ size: CGSize) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            ($0 as? View)?.contentSize = size
        }
    }

    #if os(iOS)
    @inlinable
    func isPagingEnabled(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.isPagingEnabled = flag
        }
    }
    #endif

    @inlinable
    func isDirectionalLockEnabled(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.isDirectionalLockEnabled = flag
        }
    }

    @inlinable
    func isScrollEnabled(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.isScrollEnabled = flag
        }
    }

    @inlinable
    func showsVerticalScrollIndicator(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.showsVerticalScrollIndicator = flag
        }
    }

    @inlinable
    func showsHorizontalScrollIndicator(_ flag: Bool) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.showsHorizontalScrollIndicator = flag
        }
    }

    @inlinable
    func indicator(style: View.IndicatorStyle) -> UICNotRenderedModifier<View> {
        self.onNotRendered {
            ($0 as? View)?.indicatorStyle = style
        }
    }

    @available(iOS 11.1, tvOS 11.1, *)
    @inlinable
    func verticalScroll(indicatorInsets: UIEdgeInsets) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            ($0 as? View)?.verticalScrollIndicatorInsets = indicatorInsets
        }
    }

    @available(iOS 11.1, tvOS 11.1, *)
    @inlinable
    func horizontalScroll(indicatorInsets: UIEdgeInsets) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            ($0 as? View)?.horizontalScrollIndicatorInsets = indicatorInsets
        }
    }

    @available(*, deprecated, message: "use verticalScroll(indicatorInsets:) and horizontalScroll(indicatorInsets:)")
    @inlinable
    func scroll(indicatorInsets: UIEdgeInsets) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            ($0 as? View)?.scrollIndicatorInsets = indicatorInsets
        }
    }
}

public extension UIViewCreator where View: UIScrollView {
    @inlinable
    func contentInsets(_ relay: Relay<UIEdgeInsets>) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            weak var view = $0 as? View

            relay.sync {
                view?.contentInset = $0
            }
        }
    }

    @available(iOS 11.1, tvOS 11.1, *)
    @inlinable
    func verticalScrollIndicatorInsets(_ relay: Relay<UIEdgeInsets>) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            weak var view = $0 as? View

            relay.sync {
                view?.verticalScrollIndicatorInsets = $0
            }
        }
    }

    @available(iOS 11.1, tvOS 11.1, *)
    @inlinable
    func horizontalScrollIndicatorInsets(_ relay: Relay<UIEdgeInsets>) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            weak var view = $0 as? View

            relay.sync {
                view?.horizontalScrollIndicatorInsets = $0
            }
        }
    }
}
