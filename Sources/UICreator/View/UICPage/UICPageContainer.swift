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

public class UICPageContainer: UIView {
    private(set) weak var container: UICControllerContainerView<UICPageViewController>!
    private var content: (() -> UICPageViewController)?

    private weak var stackView: UIStackView!
    private var indicatorLocation: IndicatorViewPosition?

    var indicatorViews: [UIView] {
        return self.stackView?.arrangedSubviews ?? []
    }

    func setContent(content: @escaping () -> UICPageViewController) {
        self.content = content
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

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self)?.willMove(toSuperview: newSuperview)
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self)?.didMoveToSuperview()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        self.container = self.container ?? {
            let container = UICControllerContainerView<UICPageViewController>()
            container.contain(
                viewController: {
                    let viewController = self.content?()
                    self.content = nil
                    return viewController!
                }(),
                parentView: self.viewController)

            CBSubview(self).addSubview(container)
            Constraintable.activate(container.cbuild.edges)
            return container
        }()
        RenderManager(self)?.didMoveToWindow()
    }

    // swiftlint:disable function_body_length
    override open func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self)?.layoutSubviews()

        if #available(iOS 11, tvOS 11, *), let view = self.container.view {
            if let stackView = self.stackView, let location = indicatorLocation {
                switch location {
                case .topRespectedToSafeArea:
                    view.additionalSafeAreaInsets = .init(
                        top: stackView.frame.height,
                        left: 0,
                        bottom: 0,
                        right: 0
                    )
                case .left:
                    view.additionalSafeAreaInsets = .init(
                        top: 0,
                        left: stackView.frame.width,
                        bottom: 0,
                        right: 0
                    )
                case .right:
                    view.additionalSafeAreaInsets = .init(
                        top: 0,
                        left: 0,
                        bottom: 0,
                        right: stackView.frame.width
                    )
                case .bottomRespectedToSafeArea:
                    view.additionalSafeAreaInsets = .init(
                        top: 0,
                        left: 0,
                        bottom: stackView.frame.height,
                        right: 0
                    )
                case .top:
                    let topSafeArea = view.view.safeAreaInsets.top
                    view.additionalSafeAreaInsets = .init(
                        top: stackView.frame.height - topSafeArea,
                        left: 0,
                        bottom: 0,
                        right: 0
                    )

                case .bottom:
                    let bottomSafeArea = view.view.safeAreaInsets.bottom
                    view.additionalSafeAreaInsets = .init(
                        top: 0,
                        left: 0,
                        bottom: stackView.frame.height - bottomSafeArea,
                        right: 0
                    )
                }

            } else {
                view.additionalSafeAreaInsets = .zero
            }
        }
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        RenderManager(self)?.traitDidChange()
    }

    public enum IndicatorViewPosition {
        case topRespectedToSafeArea
        case left
        case right
        case bottomRespectedToSafeArea
        case bottom
        case top
    }

    // swiftlint:disable function_body_length
    private func positionSV(_ stackView: UIStackView, orientedBy location: IndicatorViewPosition) {
        switch location {
        case .topRespectedToSafeArea:
            stackView.axis = .vertical

            Constraintable.activate(
                stackView.cbuild
                    .leading
                    .trailing,

                stackView.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0)
            )

            if #available(iOS 11.0, tvOS 11, *) {
                Constraintable.activate(
                    stackView.cbuild
                        .top
                        .equalTo(self.safeAreaLayoutGuide.cbuild.topMargin)
                )
            } else {
                Constraintable.activate(
                    stackView.cbuild
                        .top
                        .equalTo(self.cbuild.topMargin)
                )
            }
        case .bottomRespectedToSafeArea:
            stackView.axis = .vertical

            Constraintable.activate(
                stackView.cbuild
                    .leading
                    .trailing,

                stackView.cbuild
                    .top
                    .greaterThanOrEqualTo(0)
            )

            if #available(iOS 11.0, tvOS 11, *) {
                Constraintable.activate(
                    stackView.cbuild
                        .bottom
                        .equalTo(self.safeAreaLayoutGuide.cbuild.bottomMargin)
                )
            } else {
                Constraintable.activate(
                    stackView.cbuild
                        .bottom
                        .equalTo(self.cbuild.bottomMargin)
                )
            }

        case .left:
            stackView.axis = .horizontal

            Constraintable.activate(
                stackView.cbuild
                    .bottom
                    .top,

                stackView.cbuild
                    .leading,

                stackView.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
            )
        case .right:
            stackView.axis = .horizontal

            Constraintable.activate(
                stackView.cbuild
                    .bottom
                    .top,

                stackView.cbuild
                    .trailing,

                stackView.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
            )
        case .top:
            stackView.axis = .vertical

            Constraintable.activate(
                stackView.cbuild
                    .bottom
                    .top,

                stackView.cbuild
                    .trailing,

                stackView.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0)
            )

        case .bottom:
            stackView.axis = .vertical

            Constraintable.activate(
                stackView.cbuild
                    .bottom,

                stackView.cbuild
                    .leading
                    .trailing,

                stackView.cbuild
                    .top
                    .greaterThanOrEqualTo(0)
            )
        }
    }

    func setIndicatorViews(location: IndicatorViewPosition, views: [UIView]) {
        self.stackView?.removeFromSuperview()

        if views.isEmpty {
            return
        }

        let stackView = UIStackView()
        CBSubview(self).addSubview(stackView)
        self.positionSV(stackView, orientedBy: location)
        views.forEach {
            CBSubview(stackView).addArrangedSubview($0)
        }

        self.stackView = stackView
        self.indicatorLocation = location
        self.setNeedsLayout()
    }
}
