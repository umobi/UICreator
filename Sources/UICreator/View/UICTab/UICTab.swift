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

public class UICTabCreator<TabController: UITabBarController>: ViewCreator {

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

    public init(_ contents: @escaping () -> [UICTabItem]) {
        self.loadView { [unowned self] in
            let view = UICTabContainer.init(builder: self)

            self.tabController.viewControllers = contents().map { item in
                let controller = UICHostingController(content: item.content)
                controller.tabBarItem = item.tabItem
                return controller
            }

            view.setContent { [unowned self] in
                let tabBarController = self._tabBarController!
                self.tabBarController = tabBarController
                return tabBarController
            }

            return view
        }
    }
}

public typealias UICTab = UICTabCreator<UITabBarController>

public extension UICTab {
    typealias Other<TabController: UITabBarController> = UICTabCreator<TabController>
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

    func tabBar(isHidden flag: Bool) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.tabController.tabBar.isHidden = flag
        }
    }
}

public extension ViewCreator {
    var tabBarItem: UITabBarItem? {
        get { self.uiView.tabBarItem }
        set { self.uiView.viewController.tabBarItem = newValue }
    }
}

public extension ViewCreator {
    func tabBarItem(title: String?) -> Self {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.title = title
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(image: UIImage?) -> Self {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.image = image
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(tag: Int) -> Self {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.tag = tag
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(selectedImage image: UIImage?) -> Self {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.selectedImage = image
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(titlePositionAdjustment position: UIOffset) -> Self {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.titlePositionAdjustment = position
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(imageInsets insets: UIEdgeInsets) -> Self {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.imageInsets = insets
            $0.tabBarItem = tabItem
        }
    }

    @available(iOS 13.0, tvOS 13, *)
    func tabBarItem(standardAppearance: UITabBarAppearance?) -> Self {
        self.onInTheScene {
            let tabItem = $0.viewController.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.standardAppearance = standardAppearance
            $0.tabBarItem = tabItem
        }
    }
}

public extension ViewCreator {

    func tabBarItem(badgeColor color: UIColor?) -> Self {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.badgeColor = color
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(
        badgeTextAttributes attributes: [NSAttributedString.Key: Any]?,
        for state: UIControl.State) -> Self {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.setBadgeTextAttributes(attributes, for: state)
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(badgeFont font: UIFont, for state: UIControl.State = .normal) -> Self {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.setBadgeTextAttributes(
                tabItem
                    .badgeTextAttributes(for: state)?
                    .merging([.font: font], uniquingKeysWith: {
                        $1
                    }),
                for: state)
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(badgeFontColor color: UIFont, for state: UIControl.State = .normal) -> Self {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.setBadgeTextAttributes(
                tabItem
                    .badgeTextAttributes(for: state)?
                    .merging([.foregroundColor: color], uniquingKeysWith: {
                        $1
                    }),
                for: state)
            $0.tabBarItem = tabItem
        }
    }
}

public extension UICTabCreator {
    func selectedItem(_ selected: Relay<Int>) -> Self {
        self.onInTheScene {
            weak var view = $0 as? UICTabContainer

            selected.sync {
                view?.tabBarController.selectedIndex($0)
            }
        }
    }

    func selectedItem<Enum: RawRepresentable>(_ selected: Relay<Enum>) -> Self where Enum.RawValue == Int {
        self.onInTheScene {
            weak var view = $0 as? UICTabContainer

            selected.sync {
                view?.tabBarController.selectedIndex($0.rawValue)
            }
        }
    }
}
