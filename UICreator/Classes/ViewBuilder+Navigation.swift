//
//  ViewBuilder+Navigation.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation

internal extension ViewBuilder {
    weak var viewController: UIViewController! {
        return sequence(first: self as UIResponder, next: { $0.next }).first(where: {
            $0 is UIViewController
        }) as? UIViewController
    }
}

#if os(iOS)
public extension ViewBuilder {
    func toolbar(_ views: UIView...) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.viewController.toolbarItems = views.map { view in
                UIBarButtonItem(customView: Host {
                    view
                })
            }
        }
    }

    func toolbar(_ views: [UIView]) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.viewController.toolbarItems = views.map { view in
                UIBarButtonItem(customView: Host {
                    view
                })
            }
        }
    }

    func toolbar(isHidden flag: Bool) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.navigation?.navigationController.isToolbarHidden = flag
        }
    }

    func toolbar(style: UIBarStyle) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.navigation?.navigationController.toolbar.barStyle = style
        }
    }

    func toolbar(tintColor color: UIColor?) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.navigation?.navigationController.toolbar.tintColor = color
        }
    }

    func toolbar(barTintColor color: UIColor?) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.navigation?.navigationController.toolbar.barTintColor = color
        }
    }

    func toolbar(delegate: UIToolbarDelegate?) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.navigation?.navigationController.toolbar.delegate = delegate
        }
    }

    func toolbar(isTranslucent flag: Bool) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.navigation?.navigationController.toolbar.isTranslucent = flag
        }
    }

    @available(iOS 13.0, *)
    func toolbar(standardAppearance appearance: UIToolbarAppearance) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.navigation?.navigationController.toolbar.standardAppearance = appearance
        }
    }

    @available(iOS 13.0, *)
    func toolbar(compactAppearance appearance: UIToolbarAppearance?) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.navigation?.navigationController.toolbar.compactAppearance = appearance
        }
    }
}
#endif

public extension ViewBuilder {

    func navigation(isHidden flag: Bool) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.navigation?.navigationController.isNavigationBarHidden = flag
        }
    }

    func navigation(title: String?) -> Self {
        return self.appendInTheScene {
            ($0 as? Self)?.navigationItem.title = title
        }
    }

    func navigation(titleView: @escaping () -> UIView) -> Self {
        return self.appendInTheScene {
            ($0 as? Self)?.navigationItem.titleView = Host(titleView)
        }
    }

    func navigation(background image: UIImage?, for position: UIBarPosition = .any
        , barMetrics: UIBarMetrics = .default) -> Self {
        return self.appendInTheScene {
            ($0 as? Self)?.navigation?.navigationController.navigationBar.setBackgroundImage(image, for: position, barMetrics: barMetrics)
        }
    }

    #if os(iOS)
    func navigation(backButton item: @escaping () -> UIView) -> Self {
        return self.appendInTheScene {
            ($0 as? Self)?.navigationItem.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)
            guard (($0 as? Self)?.navigation?.navigationController.viewControllers.count ?? 0) > 1 else {
                print("Navigation doesn't accepted backButton, you may try to assign as leftButton")
                return
            }

            ($0 as? Self)?.navigationItem.setLeftBarButton(.init(customView: Host(item)), animated: false)
        }
    }
    #endif

    func navigation(leftButton item: @escaping () -> UIView) -> Self {
        return self.appendInTheScene {
            ($0 as? Self)?.navigationItem.setLeftBarButton(.init(customView: Host(item)), animated: false)
        }
    }

    func navigation(rightButton item: @escaping () -> UIView) -> Self {
        return self.appendInTheScene {
            ($0 as? Self)?.navigationItem.setLeftBarButton(.init(customView: Host(item)), animated: false)
        }
    }

    func navigation(leftButtons items: UIView...) -> Self {
        return self.appendInTheScene {
            ($0 as? Self)?.navigationItem
                .setLeftBarButtonItems(items.map { view in
                    .init(customView: Host({ view }))
                }, animated: false)
        }
    }

    func navigation(rightButtons items: UIView...) -> Self {
        return self.appendInTheScene {
            ($0 as? Self)?.navigationItem
                .setRightBarButtonItems(items.map { view in
                    .init(customView: Host({ view }))
                }, animated: false)
        }
    }

    #if os(iOS)
    @available(iOS 11.0, *)
    func navigation(searchController: UISearchController) -> Self {
        return self.appendInTheScene {
            ($0 as? Self)?.navigationItem.searchController = searchController
        }
    }
    #endif
}

public extension ViewBuilder {
    func navigation(titleColor color: UIColor) -> Self {
        return self.appendInTheScene {
                guard let view = ($0 as? Self) else {
                    return
                }

                view.navigation?.navigationBar.titleTextAttributes = (view.navigation?.navigationBar.titleTextAttributes ?? [:]).merging(
                    [NSAttributedString.Key.foregroundColor: color],
                    uniquingKeysWith: { $1 }
                )
            }
    }

    func navigation(titleFont font: UIFont) -> Self {
        return self.appendInTheScene {
                guard let view = ($0 as? Self) else {
                    return
                }

                view.navigation?.navigationBar.titleTextAttributes = (view.navigation?.navigationBar.titleTextAttributes ?? [:]).merging(
                    [NSAttributedString.Key.font: font],
                    uniquingKeysWith: { $1 }
                )
            }
    }
}

#if os(iOS)
public extension ViewBuilder {
    @available(iOS 11.0, *)
    func navigation(largeTitleMode mode: UINavigationItem.LargeTitleDisplayMode) -> Self {
        return self.appendInTheScene {
            ($0 as? Self)?.navigationItem.largeTitleDisplayMode = mode
        }
    }

    @available(iOS 11.0, *)
    func navigation(prefersLargeTitles: Bool) -> Self {
        return self.appendInTheScene {
            ($0 as? Self)?.navigation?.navigationBar.prefersLargeTitles = prefersLargeTitles
        }
    }

    @available(iOS 11.0, *)
    func navigation(largeTitleColor color: UIColor) -> Self {
        return self.appendInTheScene {
            guard let view = ($0 as? Self) else {
                return
            }

            view.navigation?.navigationBar.largeTitleTextAttributes = (view.navigation?.navigationBar.largeTitleTextAttributes ?? [:]).merging(
                [NSAttributedString.Key.foregroundColor: color],
                uniquingKeysWith: { $1 }
            )
        }
    }

    @available(iOS 11.0, *)
    func navigation(largeTitleFont font: UIFont) -> Self {
        return self.appendInTheScene {
            guard let view = ($0 as? Self) else {
                return
            }

            view.navigation?.navigationBar.largeTitleTextAttributes = (view.navigation?.navigationBar.largeTitleTextAttributes ?? [:]).merging(
                [NSAttributedString.Key.font: font],
                uniquingKeysWith: { $1 }
            )
        }
    }

    @available(iOS 13.0, *)
    func navigation(largeContentImage image: UIImage?) -> Self {
        return self.appendInTheScene {
            ($0 as? Self)?.navigation?.navigationBar.largeContentImage = image
        }
    }

    @available(iOS 13.0, *)
    func navigation(largeContentTitle title: String?) -> Self {
        return self.appendInTheScene {
            ($0 as? Self)?.navigation?.navigationBar.largeContentTitle = title
        }
    }
}
#endif
