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

//swiftlint:disable file_length
public extension ScrollView {
    enum Axis: Equatable {
        case vertical
        case horizontal
        case auto(vertical: UILayoutPriority, horizontal: UILayoutPriority)

        public static func ==(lhs: Axis, rhs: Axis) -> Bool {
            switch lhs {
            case .vertical:
                if case .vertical = rhs {
                    return true
                }

            case .horizontal:
                if case .horizontal = rhs {
                    return true
                }

            case .auto(let lhsVerticalPriority, let lhsHorizontalPriority):
                if case .auto(let rhsVerticalPriority, let rhsHorizontalPriority) = rhs {
                    return lhsVerticalPriority == rhsVerticalPriority
                        && lhsHorizontalPriority == rhsHorizontalPriority
                }
            }

            return false
        }
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
            if self.axis != oldValue {
                self.reloadContentLayout()
            }
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

    init(_ axis: Axis) {
        self.axis = axis
        super.init(frame: .zero)
        self.makeSelfImplemented()
    }

    public func addContent(_ view: UIView) {
        let contentView = ContentView(view)
        CBSubview(self).addSubview(contentView)
        self.contentView = contentView

        Constraintable.activate {
            contentView.cbuild
                .edges
        }

        self.reloadContentLayout()
    }

    public func reloadContentLayout() {
        Constraintable.deactivate {
            self.contentView.cbuild.width.equalTo(self.cbuild.width)
            self.contentView.cbuild.height.equalTo(self.cbuild.height)
        }

        switch axis {
        case .vertical:
            Constraintable.activate {
                contentView.cbuild
                    .width
                    .equalTo(self.widthMarginAnchor)
                    .priority(.required)
                    .constant(-self.horizontalOffset)

                contentView.cbuild
                    .height
                    .equalTo(self.heightMarginAnchor)
                    .priority(.fittingSizeLevel)
                    .constant(-self.verticalOffset)
            }
        case .horizontal:
            Constraintable.activate {
                contentView.cbuild
                    .width
                    .equalTo(self.widthMarginAnchor)
                    .priority(.fittingSizeLevel)
                    .constant(-self.horizontalOffset)

                contentView.cbuild
                    .height
                    .equalTo(self.heightMarginAnchor)
                    .priority(.required)
                    .constant(-self.verticalOffset)
            }

        case .auto(let vertical, let horizontal):
            Constraintable.activate {
                contentView.cbuild
                    .width
                    .equalTo(self.widthMarginAnchor)
                    .priority(horizontal)
                    .constant(-self.horizontalOffset)

                contentView.cbuild
                    .height
                    .equalTo(self.heightMarginAnchor)
                    .priority(vertical)
                    .constant(-self.verticalOffset)
            }
        }
    }

    public required init?(coder: NSCoder) {
        Fatal.Builder("init(coder:) has not been implemented").die()
    }

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

            Constraintable.activate {
                view.cbuild
                    .edges
            }
        }
    }
}

public struct UICScroll: UIViewCreator {
    public typealias View = ScrollView

    @Relay var axis: View.Axis
    let content: () -> ViewCreator

    public init(
        axis: Relay<View.Axis>,
        content: @escaping () -> ViewCreator) {

        self.content = content
        self._axis = axis
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return ScrollView(_self.axis)
            .onNotRendered {
                ($0 as? View)?.addContent(_self.content().releaseUIView())
            }
            .onNotRendered {
                weak var view = $0 as? View

                _self.$axis.sync {
                    view?.axis = $0
                }
            }
    }
}

public extension UIViewCreator where View: UIScrollView {
    @available(iOS 11.0, tvOS 11.0, *)
    func insetsBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.contentInsetAdjustmentBehavior = behavior
        }
    }

    func alwaysBounceVertical(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.alwaysBounceVertical = flag
        }
    }

    func alwaysBounceHorizontal(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.alwaysBounceHorizontal = flag
        }
    }

    @available(iOS 13, tvOS 13.0, *)
    func automaticallyAdjustsScroll(indicatorInsets flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.automaticallyAdjustsScrollIndicatorInsets = flag
        }
    }

    func bounces(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.bounces = flag
        }
    }

    func canCancelContentTouches(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.canCancelContentTouches = flag
        }
    }

    func contentInsets(_ insets: UIEdgeInsets) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?.contentInset = insets
        }
    }

    func contentSize(_ size: CGSize) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?.contentSize = size
        }
    }

    #if os(iOS)
    func isPagingEnabled(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.isPagingEnabled = flag
        }
    }
    #endif

    func isDirectionalLockEnabled(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.isDirectionalLockEnabled = flag
        }
    }

    func isScrollEnabled(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.isScrollEnabled = flag
        }
    }

    func showsVerticalScrollIndicator(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.showsVerticalScrollIndicator = flag
        }
    }

    func showsHorizontalScrollIndicator(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.showsHorizontalScrollIndicator = flag
        }
    }

    func indicator(style: View.IndicatorStyle) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.indicatorStyle = style
        }
    }

    @available(iOS 11.1, tvOS 11.1, *)
    func verticalScroll(indicatorInsets: UIEdgeInsets) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?.verticalScrollIndicatorInsets = indicatorInsets
        }
    }

    @available(iOS 11.1, tvOS 11.1, *)
    func horizontalScroll(indicatorInsets: UIEdgeInsets) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?.horizontalScrollIndicatorInsets = indicatorInsets
        }
    }

    @available(*, deprecated, message: "use verticalScroll(indicatorInsets:) and horizontalScroll(indicatorInsets:)")
    func scroll(indicatorInsets: UIEdgeInsets) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?.scrollIndicatorInsets = indicatorInsets
        }
    }
}

public extension UIViewCreator where View: UIScrollView {
    func contentInsets(_ relay: Relay<UIEdgeInsets>) -> UICModifiedView<View> {
        self.onInTheScene {
            weak var view = $0 as? View

            relay.sync {
                view?.contentInset = $0
            }
        }
    }

    @available(iOS 11.1, tvOS 11.1, *)
    func verticalScrollIndicatorInsets(_ relay: Relay<UIEdgeInsets>) -> UICModifiedView<View> {
        self.onInTheScene {
            weak var view = $0 as? View

            relay.sync {
                view?.verticalScrollIndicatorInsets = $0
            }
        }
    }

    @available(iOS 11.1, tvOS 11.1, *)
    func horizontalScrollIndicatorInsets(_ relay: Relay<UIEdgeInsets>) -> UICModifiedView<View> {
        self.onInTheScene {
            weak var view = $0 as? View

            relay.sync {
                view?.horizontalScrollIndicatorInsets = $0
            }
        }
    }
}
