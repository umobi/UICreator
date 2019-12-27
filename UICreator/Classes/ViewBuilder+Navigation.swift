//
//  ViewCreator+Navigation.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation

internal extension UIView {
    weak var viewController: UIViewController! {
        return sequence(first: self as UIResponder, next: { $0.next }).first(where: {
            $0 is UIViewController
        }) as? UIViewController
    }
}

internal extension ViewCreator {
    weak var viewController: UIViewController! {
        return self.uiView.viewController
    }
}

public extension ViewCreator {
    var navigation: NavigationRepresentable? {
        return self.uiView.navigation
    }
}

public extension UIView {
    var navigation: NavigationRepresentable? {
        return sequence(first: self, next: { $0?.superview }).first(where: {
            $0?.ViewCreator is NavigationRepresentable
        })??.ViewCreator as? NavigationRepresentable
    }
}

#if os(iOS)
public extension UIViewCreator {
    func toolbar(_ views: ViewCreator...) -> Self {
        self.onInTheScene {
            $0.viewController.toolbarItems = views.map { view in
                UIBarButtonItem(customView: Host {
                    view
                }.uiView)
            }
        }
    }

    func toolbar(_ views: [ViewCreator]) -> Self {
        self.onInTheScene {
            $0.viewController.toolbarItems = views.map { view in
                UIBarButtonItem(customView: Host {
                    view
                }.uiView)
            }
        }
    }

    func toolbar(isHidden flag: Bool) -> Self {
        self.onInTheScene {
            $0.navigation?.navigationController?.isToolbarHidden = flag
        }
    }

    func toolbar(style: UIBarStyle) -> Self {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.barStyle = style
        }
    }

    func toolbar(tintColor color: UIColor?) -> Self {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.tintColor = color
        }
    }

    func toolbar(barTintColor color: UIColor?) -> Self {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.barTintColor = color
        }
    }

    func toolbar(delegate: UIToolbarDelegate?) -> Self {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.delegate = delegate
        }
    }

    func toolbar(isTranslucent flag: Bool) -> Self {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.isTranslucent = flag
        }
    }

    @available(iOS 13.0, *)
    func toolbar(standardAppearance appearance: UIToolbarAppearance) -> Self {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.standardAppearance = appearance
        }
    }

    @available(iOS 13.0, *)
    func toolbar(compactAppearance appearance: UIToolbarAppearance?) -> Self {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.compactAppearance = appearance
        }
    }
}
#endif

public extension UIViewCreator {

    func navigation(isHidden flag: Bool) -> Self {
        self.onInTheScene {
           $0.navigation?.navigationController?.isNavigationBarHidden = flag
        }
    }

    func navigation(title: String?) -> Self {
        return self.onInTheScene {
            $0.navigationItem.title = title
        }
    }

    func navigation(titleView content: @escaping () -> ViewCreator) -> Self {
        return self.onInTheScene {
            $0.navigationItem.titleView = Host(content: content).uiView
        }
    }

    func navigation(background image: UIImage?, for position: UIBarPosition = .any
        , barMetrics: UIBarMetrics = .default) -> Self {
        return self.onInTheScene {
            $0.navigation?.navigationController?.navigationBar.setBackgroundImage(image, for: position, barMetrics: barMetrics)
        }
    }

    #if os(iOS)
    func navigation(backButton item: @escaping () -> ViewCreator) -> Self {
        return self.onInTheScene {
            $0.navigationItem.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)
            guard ($0.navigation?.navigationController?.viewControllers.count ?? 0) > 1 else {
                print("Navigation doesn't accepted backButton, you may try to assign as leftButton")
                return
            }

            $0.navigationItem.setLeftBarButton(.init(customView: Host(content: item).uiView), animated: false)
        }
    }
    #endif

    func navigation(leftButton item: @escaping () -> ViewCreator) -> Self {
        return self.onInTheScene {
            $0.navigationItem.setLeftBarButton(.init(customView: Host(content: item).uiView), animated: false)
        }
    }

    func navigation(rightButton item: @escaping () -> ViewCreator) -> Self {
        return self.onInTheScene {
            $0.navigationItem.setLeftBarButton(.init(customView: Host(content: item).uiView), animated: false)
        }
    }

    func navigation(leftButtons items: ViewCreator...) -> Self {
        return self.onInTheScene {
            $0.navigationItem
                .setLeftBarButtonItems(items.map { view in
                    .init(customView: Host(content: { view }).uiView)
                }, animated: false)
        }
    }

    func navigation<Right: ViewCreator>(rightButtons items: Right...) -> Self {
        return self.onInTheScene {
            $0.navigationItem
                .setRightBarButtonItems(items.map { view in
                    .init(customView: Host(content: { view }).uiView)
                }, animated: false)
        }
    }

    #if os(iOS)
    @available(iOS 11.0, *)
    func navigation(searchController: UISearchController) -> Self {
        return self.onInTheScene {
            $0.navigationItem.searchController = searchController
        }
    }
    #endif
}

public extension UIViewCreator {
    func navigation(titleColor color: UIColor) -> Self {
        return self.onInTheScene {
           guard let navigationBar = $0.navigation?.navigationController?.navigationBar else {
               return
           }

            navigationBar.titleTextAttributes = (navigationBar.titleTextAttributes ?? [:]).merging(
                [NSAttributedString.Key.foregroundColor: color],
                uniquingKeysWith: { $1 }
            )
        }
    }

    func navigation(titleFont font: UIFont) -> Self {
        return self.onInTheScene {
            guard let navigationBar = $0.navigation?.navigationController?.navigationBar else {
                return
            }

            navigationBar.titleTextAttributes = (navigationBar.titleTextAttributes ?? [:]).merging(
                [NSAttributedString.Key.font: font],
                uniquingKeysWith: { $1 }
            )
        }
    }
}

#if os(iOS)
public extension UIViewCreator {
    @available(iOS 11.0, *)
    func navigation(largeTitleMode mode: UINavigationItem.LargeTitleDisplayMode) -> Self {
        return self.onInTheScene {
            $0.navigationItem.largeTitleDisplayMode = mode
        }
    }

    @available(iOS 11.0, *)
    func navigation(prefersLargeTitles: Bool) -> Self {
        return self.onInTheScene {
            $0.navigation?.navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        }
    }

    @available(iOS 11.0, *)
    func navigation(largeTitleColor color: UIColor) -> Self {
        return self.onInTheScene {
            guard let navigationBar = $0.navigation?.navigationController?.navigationBar else {
                return
            }

            navigationBar.largeTitleTextAttributes = (navigationBar.largeTitleTextAttributes ?? [:]).merging(
                [NSAttributedString.Key.foregroundColor: color],
                uniquingKeysWith: { $1 }
            )
        }
    }

    @available(iOS 11.0, *)
    func navigation(largeTitleFont font: UIFont) -> Self {
        return self.onInTheScene {
            guard let navigationBar = $0.navigation?.navigationController?.navigationBar else {
                return
            }

            navigationBar.largeTitleTextAttributes = (navigationBar.largeTitleTextAttributes ?? [:]).merging(
                [NSAttributedString.Key.font: font],
                uniquingKeysWith: { $1 }
            )
        }
    }

    @available(iOS 13.0, *)
    func navigation(largeContentImage image: UIImage?) -> Self {
        return self.onInTheScene {
            $0.navigation?.navigationController?.navigationBar.largeContentImage = image
        }
    }

    @available(iOS 13.0, *)
    func navigation(largeContentTitle title: String?) -> Self {
        return self.onInTheScene {
            $0.navigation?.navigationController?.navigationBar.largeContentTitle = title
        }
    }
}
#endif
