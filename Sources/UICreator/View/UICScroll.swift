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

public extension ScrollView {
    enum Axis {
        case vertical
        case horizontal
        case auto(vertical: UILayoutPriority, horizontal: UILayoutPriority)
    }

    enum Margin {
        case safeArea
        case bounds
    }
}

public class ScrollView: UIScrollView, UICManagerContentView {

    private weak var contentView: UIView!
    public var axis: Axis {
        didSet {
            self.reloadContentLayout()
        }
    }

    public var verticalMargin: Margin = .safeArea {
        didSet {
            self.reloadContentLayout()
        }
    }

    public var horizontalMargin: Margin = .bounds {
        didSet {
            self.reloadContentLayout()
        }
    }

    open override var contentInset: UIEdgeInsets {
        didSet {
            self.reloadContentLayout()
        }
    }

    public required init(_ view: UIView, axis: Axis = .vertical) {
        self.axis = axis
        super.init(frame: .zero)

        self.addContent(view)
    }

    public required init(axis: Axis = .vertical) {
        self.axis = axis
        super.init(frame: .zero)
    }

    public func addContent(_ view: UIView) {
        let contentView = ContentView(view)
        CBSubview(self).addSubview(contentView)
        self.contentView = contentView

        Constraintable.activate(
            contentView.cbuild
                .edges
        )

        self.reloadContentLayout()
    }

    public func reloadContentLayout() {
        Constraintable.deactivate(
            self.contentView.cbuild.width.equalTo(self.cbuild.width),
            self.contentView.cbuild.height.equalTo(self.cbuild.height)
        )

        switch axis {
        case .vertical:
            Constraintable.activate(
                contentView.cbuild
                    .width
                    .equalTo(self.widthMarginAnchor)
                    .priority(.required)
                    .constant(-self.horizontalOffset),

                contentView.cbuild
                    .height
                    .equalTo(self.heightMarginAnchor)
                    .priority(.fittingSizeLevel)
                    .constant(-self.verticalOffset)
            )
        case .horizontal:
            Constraintable.activate(
                contentView.cbuild
                    .width
                    .equalTo(self.widthMarginAnchor)
                    .priority(.fittingSizeLevel)
                    .constant(-self.horizontalOffset),

                contentView.cbuild
                    .height
                    .equalTo(self.heightMarginAnchor)
                    .priority(.required)
                    .constant(-self.verticalOffset)
            )

        case .auto(let vertical, let horizontal):
            Constraintable.activate(
                contentView.cbuild
                    .width
                    .equalTo(self.widthMarginAnchor)
                    .priority(horizontal)
                    .constant(-self.horizontalOffset),

                contentView.cbuild
                    .height
                    .equalTo(self.heightMarginAnchor)
                    .priority(vertical)
                    .constant(-self.verticalOffset)
            )
        }
    }

    public required init?(coder: NSCoder) {
        Fatal.Builder("init(coder:) has not been implemented").die()
    }

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

private extension ScrollView {
    var heightMarginAnchor: ConstraintDimension {
        switch self.verticalMargin {
        case .bounds:
            return self.cbuild.height
        case .safeArea:
            if #available(iOS 11, tvOS 11, *) {
                return self.safeAreaLayoutGuide.cbuild.height
            }

            if case .vertical = self.axis {
                return self.layoutMarginsGuide.cbuild.height
            }

            return self.cbuild.height
        }
    }

    var widthMarginAnchor: ConstraintDimension {
        switch self.verticalMargin {
        case .bounds:
            return self.cbuild.width
        case .safeArea:
            if #available(iOS 11, tvOS 11, *) {
                return self.safeAreaLayoutGuide.cbuild.width
            }

            if case .horizontal = self.axis {
                return self.layoutMarginsGuide.cbuild.width
            }

            return self.cbuild.width
        }
    }
}

private extension ScrollView {
    var verticalOffset: CGFloat {
        return self.contentInset.top + self.contentInset.bottom
    }

    var horizontalOffset: CGFloat {
        return self.contentInset.left + self.contentInset.right
    }
}

private extension ScrollView {
    class ContentView: UIView {
        weak var view: UIView!

        convenience init(_ view: UIView) {
            self.init(frame: .zero)
            self.view = view

            CBSubview(self).addSubview(view)

            Constraintable.activate(
                view.cbuild
                    .edges
            )
        }
    }
}

public class UICScroll: UIViewCreator {
    public typealias View = ScrollView

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
