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

public class UICTab: UIViewControllerCreator {
    public typealias ViewController = UITabBarController

    public init(@UICTabItemBuilder _ contents: @escaping () -> UICTabItem) {
        self.loadView {
            ControllerView<UITabBarController>(builder: self)
        }
        .onInTheScene {
            ($0 as? ControllerView<UITabBarController>)?.contain(viewController: {
                let tabController = UITabBarController()
                tabController.setViewControllers(contents)
                return tabController
            }())
        }
    }
}

public extension UIViewControllerCreator where ViewController: UITabBarController {
    func tabBar(backgroundImage image: UIImage?) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.backgroundImage = image
        }
    }

    #if os(iOS)
    func tabBar(barStyle style: UIBarStyle) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.barStyle = style
        }
    }
    #endif

    func tabBar(barTintColor tintColor: UIColor?) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.barTintColor = tintColor
        }
    }

    func tabBar(isTranslucent flag: Bool) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.isTranslucent = flag
        }
    }

    #if os(iOS)
    func tabBar(itemPositioning position: UITabBar.ItemPositioning) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.itemPositioning = position
        }
    }
    #endif

    func tabBar(itemSpacing spacing: CGFloat) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.itemSpacing = spacing
        }
    }

    func tabBar(itemWidth width: CGFloat) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.itemWidth = width
        }
    }

    func tabBar(selectedItem firstHandler: @escaping (UITabBarItem) -> Bool) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.selectedItem = self.wrappedViewController.tabBar.items?.first(where: {
                firstHandler($0)
            })
        }
    }

    func tabBar(selectionIndicatorImage image: UIImage?) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.selectionIndicatorImage = image
        }
    }

    func tabBar(shadowImage image: UIImage?) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.shadowImage = image
        }
    }

    @available(iOS 13.0, tvOS 13, *)
    func tabBar(standardAppearance: UITabBarAppearance) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.standardAppearance = standardAppearance
        }
    }

    func tabBar(tintColor color: UIColor?) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.tintColor = color
        }
    }

    func tabBar(unselectedItemTintColor color: UIColor?) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.unselectedItemTintColor = color
        }
    }

    func tabBar(isHidden flag: Bool) -> Self {
        self.onInTheScene { [unowned self] _ in
            self.wrappedViewController.tabBar.isHidden = flag
        }
    }
}

public extension ViewCreator {
    var tabBarItem: UITabBarItem? {
        get { self.uiView?.tabBarItem }
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

public extension UIViewControllerCreator where ViewController: UITabBarController {
    func selectedItem(_ selected: Relay<Int>) -> Self {
        self.onInTheScene { [weak self] _ in
            weak var viewController = self?.wrappedViewController
            selected.sync {
                viewController?.selectedIndex($0)
            }
        }
    }

    func selectedItem<Enum: RawRepresentable>(_ selected: Relay<Enum>) -> Self where Enum.RawValue == Int {
        self.onInTheScene { [weak self] _ in
            weak var viewController = self?.wrappedViewController
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
