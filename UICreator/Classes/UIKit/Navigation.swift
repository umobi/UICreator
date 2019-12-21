//
//  Navigation.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public class Navigation: View, NavigationRepresentable {

    public var navigationLoader: (UIViewController) -> UINavigationController {
        {
            return .init(rootViewController: $0)
        }
    }
}

public extension Navigation {
    class Other<NavigationController: UINavigationController>: Navigation {
        override public var navigationLoader: (UIViewController) -> UINavigationController {
            {
                return NavigationController(rootViewController: $0)
            }
        }
    }
}
