//
//  ViewBuilder+Navigation.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation

internal extension ViewBuilder {
    weak var viewController: UIViewController! {
        return sequence(first: self as UIResponder, next: { $0?.next }).first(where: {
            $0 is UIViewController
        }) as? UIViewController
    }
}

public extension ViewBuilder {
//    fileprivate var host: Host? {
//        var ref: UIView? = self
//        while let host = ref, !(host is Host) {
//            ref = host.superview
//        }
//
//        return ref as? Host
//    }

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
}
