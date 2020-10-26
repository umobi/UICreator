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

@_functionBuilder
public struct UICTabItemBuilder {
    static public func buildBlock(_ segments: UICTabItem...) -> UICTabItem {
        UICTabItem(segments)
    }
}

public extension UITabBarController {
    func setViewControllers(@UICTabItemBuilder _ contents: @escaping () -> UICTabItem) {
        let viewControllers: [UIViewController] = contents().zip.map {
            let controller = UICHostingController(content: $0.content)
            controller.tabBarItem = $0.tabItem
            return controller
        }

        self.viewControllers = viewControllers
    }
}

public struct UICTab: UIViewControllerCreator {
    public typealias ViewController = UITabBarController

    let contents: () -> UICTabItem

    init(@UICTabItemBuilder _ contents: @escaping () -> UICTabItem) {
        self.contents = contents
    }

    public static func makeUIViewController(_ viewCreator: ViewCreator) -> CBViewController {
        let tabController = UITabBarController()
        tabController.setViewControllers((viewCreator as! Self).contents)
        return tabController
    }
}

public extension UIViewControllerCreator where ViewController: UITabBarController {
    func tabBar(backgroundImage image: UIImage?) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.backgroundImage = image
        }
    }

    #if os(iOS)
    func tabBar(barStyle style: UIBarStyle) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.barStyle = style
        }
    }
    #endif

    func tabBar(barTintColor tintColor: UIColor?) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.barTintColor = tintColor
        }
    }

    func tabBar(isTranslucent flag: Bool) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.isTranslucent = flag
        }
    }

    #if os(iOS)
    func tabBar(itemPositioning position: UITabBar.ItemPositioning) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.itemPositioning = position
        }
    }
    #endif

    func tabBar(itemSpacing spacing: CGFloat) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.itemSpacing = spacing
        }
    }

    func tabBar(itemWidth width: CGFloat) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.itemWidth = width
        }
    }

    func tabBar(selectedItem firstHandler: @escaping (UITabBarItem) -> Bool) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?
                .tabBar
                .selectedItem = {
                    ($0 as? ViewController)?
                        .tabBar
                        .items?
                        .first(where: firstHandler)
                }($0)
        }
    }

    func tabBar(selectionIndicatorImage image: UIImage?) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.selectionIndicatorImage = image
        }
    }

    func tabBar(shadowImage image: UIImage?) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.shadowImage = image
        }
    }

    @available(iOS 13.0, tvOS 13, *)
    func tabBar(standardAppearance: UITabBarAppearance) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.standardAppearance = standardAppearance
        }
    }

    func tabBar(tintColor color: UIColor?) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.tintColor = color
        }
    }

    func tabBar(unselectedItemTintColor color: UIColor?) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.unselectedItemTintColor = color
        }
    }

    func tabBar(isHidden flag: Bool) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.isHidden = flag
        }
    }
}

public extension UIViewCreator {
    func tabBarItem(title: String?) -> UICModifiedView<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.title = title
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(image: UIImage?) -> UICModifiedView<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.image = image
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(tag: Int) -> UICModifiedView<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.tag = tag
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(selectedImage image: UIImage?) -> UICModifiedView<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.selectedImage = image
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(titlePositionAdjustment position: UIOffset) -> UICModifiedView<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.titlePositionAdjustment = position
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(imageInsets insets: UIEdgeInsets) -> UICModifiedView<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.imageInsets = insets
            $0.tabBarItem = tabItem
        }
    }

    @available(iOS 13.0, tvOS 13, *)
    func tabBarItem(standardAppearance: UITabBarAppearance?) -> UICModifiedView<View> {
        self.onInTheScene {
            let tabItem = $0.viewController.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.standardAppearance = standardAppearance
            $0.tabBarItem = tabItem
        }
    }
}

public extension UIViewCreator {

    func tabBarItem(badgeColor color: UIColor?) -> UICModifiedView<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.badgeColor = color
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(
        badgeTextAttributes attributes: [NSAttributedString.Key: Any]?,
        for state: UIControl.State) -> UICModifiedView<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.setBadgeTextAttributes(attributes, for: state)
            $0.tabBarItem = tabItem
        }
    }

    func tabBarItem(badgeFont font: UIFont, for state: UIControl.State = .normal) -> UICModifiedView<View> {
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

    func tabBarItem(badgeFontColor color: UIFont, for state: UIControl.State = .normal) -> UICModifiedView<View> {
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

public extension UIViewControllerCreator where ViewController: UITabBarController {
    func selectedItem(_ selected: Relay<Int>) -> UICModifiedViewController<ViewController> {
        self.onInTheScene {
            weak var viewController = $0 as? ViewController

            selected.sync {
                viewController?.selectedIndex($0)
            }
        }
    }

    func selectedItem<Enum: RawRepresentable>(_ selected: Relay<Enum>) -> UICModifiedViewController<ViewController> where Enum.RawValue == Int {
        self.onInTheScene {
            weak var viewController = $0 as? ViewController

            selected.sync {
                viewController?.selectedIndex($0.rawValue)
            }
        }
    }
}

public extension UITabBarController {
    func selectedIndex(_ index: Int) {
        guard index != self.selectedIndex else {
            return
        }

        guard let view = self.viewControllers?[index] else {
            return
        }

        guard self.delegate?.tabBarController?(self, shouldSelect: view) ?? true else {
            return
        }

        self.selectedViewController = view
        self.delegate?.tabBarController?(self, didSelect: view)
    }
}

public extension UIView {
    var tabBarItem: UITabBarItem? {
        get {
            ViewControllerSearch(
                self,
                searchFor: UITabBarController.self
            ).viewNearFromSearch?.tabBarItem
        }
        set {
            ViewControllerSearch(
                self,
                searchFor: UITabBarController.self
            ).viewNearFromSearch?.tabBarItem = newValue
        }
    }
}
