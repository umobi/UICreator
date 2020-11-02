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

public struct UICTab: UIViewControllerCreator {
    public typealias ViewController = UITabBarController

    @Relay private var selectedItem: Int
    private let contents: () -> UICTabItem

    public init(
        selectedItem: Relay<Int>,
        @UICTabItemBuilder _ contents: @escaping () -> UICTabItem) {
        self._selectedItem = selectedItem
        self.contents = contents
    }

    @inline(__always)
    public static func _makeUIViewController(_ viewCreator: ViewCreator) -> CBViewController {
        let _self = viewCreator as! Self

        let tabController = UITabBarController()
        tabController.setViewControllers(_self.contents)

        _self.$selectedItem.distinctSync { [weak tabController] in
            tabController?.selectedIndex($0)
        }

        tabController.onDidSelect {
            _self.selectedItem = $0.selectedIndex
        }

        return tabController
    }
}

public extension UIViewControllerCreator where ViewController: UITabBarController {
    @inlinable
    func tabBar(backgroundImage image: UICImage?) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.backgroundImage = image?.uiImage
        }
    }

    #if os(iOS)
    @inlinable
    func tabBar(barStyle style: UIBarStyle) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.barStyle = style
        }
    }
    #endif

    @inlinable
    func tabBar(barTintColor tintColor: UIColor?) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.barTintColor = tintColor
        }
    }

    @inlinable
    func tabBar(isTranslucent flag: Bool) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.isTranslucent = flag
        }
    }

    #if os(iOS)
    @inlinable
    func tabBar(itemPositioning position: UITabBar.ItemPositioning) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.itemPositioning = position
        }
    }
    #endif

    @inlinable
    func tabBar(itemSpacing spacing: CGFloat) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.itemSpacing = spacing
        }
    }

    @inlinable
    func tabBar(itemWidth width: CGFloat) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.itemWidth = width
        }
    }

    @inlinable
    func tabBar(selectedItem firstHandler: @escaping (UITabBarItem) -> Bool) -> UICInTheSceneModifierController<ViewController> {
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

    @inlinable
    func tabBar(selectionIndicatorImage image: UICImage?) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.selectionIndicatorImage = image?.uiImage
        }
    }

    @inlinable
    func tabBar(shadowImage image: UICImage?) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.shadowImage = image?.uiImage
        }
    }

    @inlinable @available(iOS 13.0, tvOS 13, *)
    func tabBar(standardAppearance: UITabBarAppearance) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.standardAppearance = standardAppearance
        }
    }

    @inlinable
    func tabBar(tintColor color: UIColor?) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.tintColor = color
        }
    }

    @inlinable
    func tabBar(unselectedItemTintColor color: UIColor?) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.unselectedItemTintColor = color
        }
    }

    @inlinable
    func tabBar(isHidden flag: Bool) -> UICInTheSceneModifierController<ViewController> {
        self.onInTheScene {
            ($0 as? ViewController)?.tabBar.isHidden = flag
        }
    }
}

public extension UIViewCreator {
    @inlinable
    func tabBarItem(title: String?) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.title = title
            $0.tabBarItem = tabItem
        }
    }

    @inlinable
    func tabBarItem(image: UICImage?) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.image = image?.uiImage
            $0.tabBarItem = tabItem
        }
    }

    @inlinable
    func tabBarItem(tag: Int) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.tag = tag
            $0.tabBarItem = tabItem
        }
    }

    @inlinable
    func tabBarItem(selectedImage image: UICImage?) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.selectedImage = image?.uiImage
            $0.tabBarItem = tabItem
        }
    }

    @inlinable
    func tabBarItem(titlePositionAdjustment position: UIOffset) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.titlePositionAdjustment = position
            $0.tabBarItem = tabItem
        }
    }

    @inlinable
    func tabBarItem(imageInsets insets: UIEdgeInsets) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.imageInsets = insets
            $0.tabBarItem = tabItem
        }
    }

    @inlinable @available(iOS 13.0, tvOS 13, *)
    func tabBarItem(standardAppearance: UITabBarAppearance?) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.standardAppearance = standardAppearance
            $0.tabBarItem = tabItem
        }
    }
}

public extension UIViewCreator {

    @inlinable
    func tabBarItem(badgeColor color: UIColor?) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.badgeColor = color
            $0.tabBarItem = tabItem
        }
    }

    @inlinable
    func tabBarItem(
        badgeTextAttributes attributes: [NSAttributedString.Key: Any]?,
        for state: UIControl.State) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            let tabItem = $0.tabBarItem ?? .init(title: nil, image: nil, tag: 0)
            tabItem.setBadgeTextAttributes(attributes, for: state)
            $0.tabBarItem = tabItem
        }
    }

    @inlinable
    func tabBarItem(badgeFont font: UIFont, for state: UIControl.State = .normal) -> UICInTheSceneModifier<View> {
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

    @inlinable
    func tabBarItem(badgeFontColor color: UIFont, for state: UIControl.State = .normal) -> UICInTheSceneModifier<View> {
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

extension UITabBarController {
    @usableFromInline
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
