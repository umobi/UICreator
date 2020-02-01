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

public class UICTabContainer: UIView {
    private(set) weak var container: _Container<UITabBarController>!
    private var content: (() -> UITabBarController)? = nil

    func setContent(content: @escaping () -> UITabBarController) {
        self.content = content
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.commitNotRendered()
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        self.container = self.container ?? {
            let container = _Container<UITabBarController>(in: self.viewController, loadHandler: { [unowned self] in
                let viewController = self.content?()
                self.content = nil
                return viewController
            })

            self.addSubview(container)
            container.snp.makeConstraints {
                $0.edges.equalTo(0)
            }
            return container
        }()
        self.commitInTheScene()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }

    override var watchingViews: [UIView] {
        return [self] + self.subviews
    }
}

public class UICTabCreator<TabController: UITabBarController>: UIViewCreator {
    public typealias View = UICTabContainer

    private lazy var _tabBarController: TabController? = {
        return .init()
    }()

    private weak var tabBarController: TabController! {
        willSet {
            self._tabBarController = nil
        }
    }

    var tabController: TabController! {
        return self._tabBarController ?? self.tabBarController
    }

    public init(_ contents: @escaping () -> [ViewCreator]) {
        self.uiView = View.init(builder: self)

        self.tabController.viewControllers = contents().map { view in
            let controller = ContainerController(UICHost {
                view
            })
            controller.tabBarItem = view.uiView.tabBarItem
            return controller
        }

        (self.uiView as? View)?.setContent { [unowned self] in
            let tabBarController = self._tabBarController!
            self.tabBarController = tabBarController
            return tabBarController
        }
    }
}

public typealias UICTab = UICTabCreator<UITabBarController>

extension UICTab {
    typealias Other<TabController: UITabBarController> = UICTabCreator<UITabBarController>
}

public extension UICTabCreator {
    func `as`(_ ref: inout TabController!) -> Self {
        ref = self.tabController
        return self
    }
}

public extension UICTabCreator {
    func tabBar(backgroundImage image: UIImage?) -> Self {
        self.onRendered { [unowned self] _ in
            self.tabController.tabBar.backgroundImage = image
        }
    }

    #if os(iOS)
    func tabBar(barStyle style: UIBarStyle) -> Self {
        self.onRendered { [unowned self] _ in
            self.tabController.tabBar.barStyle = style
        }
    }
    #endif

    func tabBar(barTintColor tintColor: UIColor?) -> Self {
        self.onRendered { [unowned self] _ in
            self.tabController.tabBar.barTintColor = tintColor
        }
    }

    func tabBar(isTranslucent flag: Bool) -> Self {
        self.onRendered { [unowned self] _ in
            self.tabController.tabBar.isTranslucent = flag
        }
    }

    #if os(iOS)
    func tabBar(itemPositioning position: UITabBar.ItemPositioning) -> Self {
        self.onRendered { [unowned self] _ in
            self.tabController.tabBar.itemPositioning = position
        }
    }
    #endif

    func tabBar(itemSpacing spacing: CGFloat) -> Self {
        self.onRendered { [unowned self] _ in
            self.tabController.tabBar.itemSpacing = spacing
        }
    }

    func tabBar(itemWidth width: CGFloat) -> Self {
        self.onRendered { [unowned self] _ in
            self.tabController.tabBar.itemWidth = width
        }
    }

    func tabBar(selectedItem firstHandler: @escaping (UITabBarItem) -> Bool) -> Self {
        self.onRendered { [unowned self] _ in
            self.tabController.tabBar.selectedItem = self.tabController.tabBar.items?.first(where: {
                firstHandler($0)
            })
        }
    }

    func tabBar(selectionIndicatorImage image: UIImage?) -> Self {
        self.onRendered { [unowned self] _ in
            self.tabController.tabBar.selectionIndicatorImage = image
        }
    }

    func tabBar(shadowImage image: UIImage?) -> Self {
        self.onRendered { [unowned self] _ in
            self.tabController.tabBar.shadowImage = image
        }
    }

    @available(iOS 13.0, tvOS 13, *)
    func tabBar(standardAppearance: UITabBarAppearance) -> Self {
        self.onRendered { [unowned self] _ in
            self.tabController.tabBar.standardAppearance = standardAppearance
        }
    }

    func tabBar(tintColor color: UIColor?) -> Self {
        self.onRendered { [unowned self] _ in
            self.tabController.tabBar.tintColor = color
        }
    }

    func tabBar(unselectedItemTintColor color: UIColor?) -> Self {
        self.onRendered { [unowned self] _ in
            self.tabController.tabBar.unselectedItemTintColor = color
        }
    }
}

private var kTabBarItem: UInt = 0
public extension UIView {
    var tabBarItem: UITabBarItem? {
        get { objc_getAssociatedObject(self, &kTabBarItem) as? UITabBarItem }

        set {
            objc_setAssociatedObject(self, &kTabBarItem, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

public extension ViewCreator {
    func tabBarItem(title: String?) -> Self {
        self.onNotRendered {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.title = title
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(image: UIImage?) -> Self {
        self.onNotRendered {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.image = image
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(tag: Int) -> Self {
        self.onNotRendered {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.tag = tag
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(selectedImage image: UIImage?) -> Self {
        self.onNotRendered {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.selectedImage = image
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(titlePositionAdjustment position: UIOffset) -> Self {
        self.onNotRendered {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.titlePositionAdjustment = position
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(imageInsets insets: UIEdgeInsets) -> Self {
        self.onNotRendered {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.imageInsets = insets
            $0.tabBarItem = tabItem
        }
    }

    @available(iOS 13.0, tvOS 13, *)
    func tabBarItem(standardAppearance: UITabBarAppearance?) -> Self {
        self.onNotRendered {
            let tabItem = $0.viewController.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.standardAppearance = standardAppearance
            $0.tabBarItem = tabItem
        }
    }
}

public extension ViewCreator {

    func tabBarItem(badgeColor color: UIColor?) -> Self {
        self.onNotRendered {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.badgeColor = color
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(badgeTextAttributes attributes: [NSAttributedString.Key : Any]?, for state: UIControl.State) -> Self {
        self.onNotRendered {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.setBadgeTextAttributes(attributes, for: state)
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(badgeFont font: UIFont, for state: UIControl.State = .normal) -> Self {
        self.onNotRendered {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.setBadgeTextAttributes(tabItem.badgeTextAttributes(for: state)?.merging([.font: font], uniquingKeysWith: {
                $1
            }), for: state)
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(badgeFontColor color: UIFont, for state: UIControl.State = .normal) -> Self {
        self.onNotRendered {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.setBadgeTextAttributes(tabItem.badgeTextAttributes(for: state)?.merging([.foregroundColor: color], uniquingKeysWith: {
                $1
            }), for: state)
            $0.tabBarItem = tabItem
        }
    }
}

public class Controller: UIViewCreator {
    public typealias View = _Container<ContainerController<UICHost>>

    public init(content: @escaping () -> ViewCreator) {
        self.uiView = View.init(builder: self)
        _ = self.onInTheScene {
            ($0 as? View)?.prepareContainer(inside: $0.viewController, loadHandler: {
                ContainerController(UICHost {
                    content()
                })
            })
        }
    }
}
