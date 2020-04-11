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

public class _ScrollView: ScrollView {

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

public class UICScroll: UIViewCreator {
    public typealias View = _ScrollView

    public init(axis: View.Axis = .vertical, content: @escaping () -> ViewCreator) {
        let content = content()
        self.tree.append(content)

        self.loadView { [unowned self] in
            let view = View.init(axis: axis)
            view.updateBuilder(self)
            return view
        }
        .onNotRendered {
            ($0 as? View)?.addContent(content.releaseUIView())
        }
    }
}

public func UICVScroll(_ content: @escaping () -> ViewCreator) -> UICScroll {
    return .init(axis: .vertical, content: content)
}

public func UICHScroll(_ content: @escaping () -> ViewCreator) -> UICScroll {
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