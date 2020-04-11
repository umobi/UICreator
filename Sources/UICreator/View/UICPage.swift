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
import ConstraintBuilder

public class UICPageViewController: UIPageViewController {
    private var queuedViewControllers: [UIViewController]!
    #if os(iOS)
    fileprivate var spineLocationHandler: ((UIInterfaceOrientation) -> SpineLocation)? = nil
    #endif
    fileprivate var onPageChangeHandler: ((Int) -> Void)? = nil
    fileprivate var isInfinityScroll: Bool = false

    public func updateViewControllers(_ viewControllers: [UIViewController], direction: UIPageViewController.NavigationDirection, animated flag: Bool, completion: ((Bool) -> Void)? = nil) {
        self.queuedViewControllers = viewControllers
        self.setViewControllers([viewControllers.first].compactMap { $0 }, direction: .forward, animated: flag, completion: completion)
    }

    public var currentPage: Int {
        get {
            guard let currentSlice = (self.queuedViewControllers.enumerated().compactMap { slice -> (Int, CGRect)? in
                guard let rect = slice.element.view.superview?.convert(slice.element.view.bounds, to: self.view) else {
                    return nil
                }

                return (slice.offset, self.view.frame.intersection(rect))
            }.sorted(by: {
                ($0.1.size.height * $0.1.size.width) > ($1.1.size.height * $1.1.size.width)
            }).first) else { return 0 }

            return currentSlice.0
        }

        set {
            let currentPage = self.currentPage
            if currentPage != newValue {
                guard let toPageView = self.queuedViewControllers.enumerated().first(where: {
                    $0.offset == newValue
                }) else {
                    return
                }

                self.setViewControllers([toPageView.element], direction: {
                    if currentPage <= toPageView.offset {
                        return .forward
                    }

                    return .reverse
                }(), animated: !UIAccessibility.isReduceMotionEnabled && self.view.window != nil, completion: nil)
            }
        }
    }
}

extension UICPageViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed) {
            return
        }

        let currentPage = self.currentPage
        self.onPageChangeHandler?(currentPage)
    }

    #if os(iOS)
    public func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        return self.spineLocationHandler?(orientation) ?? .none
    }

    public func pageViewControllerSupportedInterfaceOrientations(_ pageViewController: UIPageViewController) -> UIInterfaceOrientationMask {
        return UIApplication.shared.supportedInterfaceOrientations(for: self.view.window)
    }
    #endif
}

extension UICPageViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let queueViews = self.queuedViewControllers ?? []
        guard let viewControllerSlice = queueViews.enumerated().first(where: {
            $0.element === viewController
        }) else {
            return nil
        }

        guard let back = queueViews.enumerated().split(maxSplits: 1, omittingEmptySubsequences: true, whereSeparator: {
            $0.element === viewController
        }).first?.last else { return nil }

        if !self.isInfinityScroll && back.offset >= viewControllerSlice.offset {
            return nil
        }

        return back.element
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let queueViews = self.queuedViewControllers ?? []
        guard let viewControllerSlice = queueViews.enumerated().first(where: {
            $0.element === viewController
        }) else {
            return nil
        }

        guard let next = queueViews.enumerated().split(maxSplits: 1, omittingEmptySubsequences: true, whereSeparator: {
            $0.element === viewController
        }).last?.first else { return nil }

        if !self.isInfinityScroll && next.offset <= viewControllerSlice.offset {
            return nil
        }

        return next.element
    }
}

public class UICPageContainer: UIView {
    private(set) weak var container: _Container<UICPageViewController>!
    private var content: (() -> UICPageViewController)? = nil

    private weak var stackView: UIStackView!
    private var indicatorLocation: IndicatorViewPosition? = nil

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
            let container = _Container<UICPageViewController>(in: self.viewController, loadHandler: { [unowned self] in
                let viewController = self.content?()
                self.content = nil
                return viewController
            })

            AddSubview(self).addSubview(container)
            Constraintable.activate(container.cbuild.edges)
            return container
        }()
        RenderManager(self)?.didMoveToWindow()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self)?.layoutSubviews()

        if #available(iOS 11, tvOS 11, *), let view = self.container.view {
            if let stackView = self.stackView, let location = indicatorLocation {
                switch location {
                case .topRespectedToSafeArea:
                    view.additionalSafeAreaInsets = .init(top: stackView.frame.height, left: 0, bottom: 0, right: 0)
                case .left:
                    view.additionalSafeAreaInsets = .init(top: 0, left: stackView.frame.width, bottom: 0, right: 0)
                case .right:
                    view.additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: 0, right: stackView.frame.width)
                case .bottomRespectedToSafeArea:
                    view.additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: stackView.frame.height, right: 0)
                case .top:
                    let topSafeArea = view.view.safeAreaInsets.top
                    view.additionalSafeAreaInsets = .init(top: stackView.frame.height - topSafeArea, left: 0, bottom: 0, right: 0)

                case .bottom:
                    let bottomSafeArea = view.view.safeAreaInsets.bottom
                    view.additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: stackView.frame.height - bottomSafeArea, right: 0)
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
        AddSubview(self).addSubview(stackView)
        self.positionSV(stackView, orientedBy: location)
        views.forEach {
            AddSubview(stackView).addArrangedSubview($0)
        }

        self.stackView = stackView
        self.indicatorLocation = location
        self.setNeedsLayout()
    }
}

public class UICPage: UIViewCreator {
    public typealias View = UICPageContainer

    private(set) var transitionStyle: UIPageViewController.TransitionStyle = .scroll
    private(set) var navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal
    private(set) var options: [UIPageViewController.OptionsKey: Any]?

    private lazy var _pageViewController: UICPageViewController? = {
        let pageController: UICPageViewController = .init(transitionStyle: self.transitionStyle, navigationOrientation: self.navigationOrientation, options: self.options)

        pageController.dataSource = pageController
        pageController.delegate = pageController

        return pageController
    }()

    private weak var pageViewController: UICPageViewController! {
        willSet {
            self._pageViewController = nil
        }
    }

    var pageController: UICPageViewController! {
        return self._pageViewController ?? self.pageViewController
    }

    public init(transitionStyle: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey: Any]?) {
        self.loadView { [unowned self] in
            self.transitionStyle = transitionStyle
            self.navigationOrientation = navigationOrientation
            self.options = options
            let view = View.init(builder: self)
            view.setContent { [unowned self] in
                let pageViewController = self._pageViewController!
                self.pageViewController = pageViewController
                return pageViewController
            }
            return view
        }
    }
}

public extension UICPage {
    func `as`<Controller: UIPageViewController>(_ reference: UICOutlet<Controller>) -> Self {
        return self.onInTheScene { [weak self, reference] _ in
            reference.ref(self?.pageController as? Controller)
        }
    }
    
    func pages(direction: UIPageViewController.NavigationDirection,_ contents: @escaping () -> [ViewCreator]) -> Self {
        let contents = contents().map { content in
            UICHost(content: { content })
        }

        contents.forEach {
            self.tree.append($0)
        }

        return self.onInTheScene { [unowned self] _ in
            self.pageController.updateViewControllers(contents.map { content in
                ContainerController(content)
            }, direction: direction, animated: false, completion: nil)
        }
    }

    #if os(iOS)
    func spineLocation(_ handler: @escaping (UIInterfaceOrientation) -> UIPageViewController.SpineLocation) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.pageController.spineLocationHandler = handler
        }
    }
    #endif

    func onPageChanged(_ handler: @escaping (Int) -> Void) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.pageController.onPageChangeHandler = handler
        }
    }

    func isInfinityScroll(_ flag: Bool) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.pageController.isInfinityScroll = flag
        }
    }

    func addIndicator(atLocation location: View.IndicatorViewPosition, content: @escaping () -> ViewCreator) -> Self {
        let content = UICHost(content: content)
        self.tree.append(content)

        return self.onInTheScene {
            ($0 as? View)?.setIndicatorViews(location: location, views: [content.releaseUIView()])
        }
    }
}
