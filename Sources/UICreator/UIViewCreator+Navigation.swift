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

public extension UIView {
    var viewController: UIViewController! {
        sequence(first: self as UIResponder, next: { $0.next }).first(where: {
            $0 is UIViewController
        }) as? UIViewController
    }

    var navigationController: UINavigationController? {
        self.viewController.navigationController
    }
}

public extension UIView {
    var navigation: NavigationRepresentable? {
        NavigationRepresentable(view: self)
    }
}

#if os(iOS)
public extension UIViewCreator {
    func toolbar(@UICViewBuilder _ contents: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.viewController.toolbarItems = contents().zip.map { view in
                UIBarButtonItem(customView: ViewAdaptor(view.releaseUIView()))
            }
        }
    }

    func toolbar(isHidden flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigation?.navigationController?.isToolbarHidden = flag
        }
    }

    func toolbar(style: UIBarStyle) -> UICModifiedView<View> {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.barStyle = style
        }
    }

    func toolbar(tintColor color: UIColor?) -> UICModifiedView<View> {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.tintColor = color
        }
    }

    func toolbar(barTintColor color: UIColor?) -> UICModifiedView<View> {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.barTintColor = color
        }
    }

    func toolbar(delegate: UIToolbarDelegate?) -> UICModifiedView<View> {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.delegate = delegate
        }
    }

    func toolbar(isTranslucent flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.isTranslucent = flag
        }
    }

    @available(iOS 13.0, *)
    func toolbar(standardAppearance appearance: UIToolbarAppearance) -> UICModifiedView<View> {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.standardAppearance = appearance
        }
    }

    @available(iOS 13.0, *)
    func toolbar(compactAppearance appearance: UIToolbarAppearance?) -> UICModifiedView<View> {
        self.onInTheScene {
           $0.navigation?.navigationController?.toolbar.compactAppearance = appearance
        }
    }
}
#endif

public extension UIViewCreator {

    func navigation(isHidden flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
           $0.navigation?.navigationController?.isNavigationBarHidden = flag
        }
    }

    func navigation(title: String?) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigationItem.title = title
        }
    }

    func navigation(titleView content: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigationItem.titleView = ViewAdaptor(content().releaseUIView())
        }
    }

    func navigation(
        background image: UIImage?,
        for position: UIBarPosition = .any,
        barMetrics: UIBarMetrics = .default) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigation?
                .navigationController?
                .navigationBar
                .setBackgroundImage(
                    image,
                    for: position,
                    barMetrics: barMetrics
                )
        }
    }

    #if os(iOS)
    func navigation(backButton content: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigationItem.backBarButtonItem = .init(
                title: "",
                style: .plain,
                target: nil,
                action: nil
            )

            guard ($0.navigation?.navigationController?.viewControllers.count ?? 0) > 1 else {
                print("Navigation doesn't accepted backButton, you may try to assign as leftButton")
                return
            }

            $0.navigationItem.setLeftBarButton(
                .init(customView: ViewAdaptor(content().releaseUIView())),
                animated: false
            )
        }
    }
    #endif

    func navigation(leftButton content: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigationItem.setLeftBarButton(
                .init(customView: ViewAdaptor(content().releaseUIView())),
                animated: false
            )
        }
    }

    func navigation(@UICViewBuilder leftButtons contents: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigationItem
                .setLeftBarButtonItems(contents().zip.map { view in
                    .init(customView: ViewAdaptor(view.releaseUIView()))
                }, animated: false)
        }
    }

    func navigation(rightButton content: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigationItem.setRightBarButton(
                .init(customView: ViewAdaptor(content().releaseUIView())),
                animated: false
            )
        }
    }

    func navigation(@UICViewBuilder rightButtons contents: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigationItem
                .setRightBarButtonItems(contents().zip.map { view in
                    .init(customView: ViewAdaptor(view.releaseUIView()))
                }, animated: false)
        }
    }

    #if os(iOS)
    @available(iOS 11.0, *)
    func navigation(searchController: UISearchController) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigationItem.searchController = searchController
        }
    }
    #endif
}

public extension UIViewCreator {
    func navigation(titleColor color: UIColor) -> UICModifiedView<View> {
        self.onInTheScene {
           guard let navigationBar = $0.navigation?.navigationController?.navigationBar else {
               return
           }

            navigationBar.titleTextAttributes = (navigationBar.titleTextAttributes ?? [:]).merging(
                [NSAttributedString.Key.foregroundColor: color],
                uniquingKeysWith: { $1 }
            )
        }
    }

    func navigation(titleFont font: UIFont) -> UICModifiedView<View> {
        self.onInTheScene {
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
    func navigation(largeTitleMode mode: UINavigationItem.LargeTitleDisplayMode) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigationItem.largeTitleDisplayMode = mode
        }
    }

    @available(iOS 11.0, *)
    func navigation(prefersLargeTitles: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigation?.navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        }
    }

    @available(iOS 11.0, *)
    func navigation(largeTitleColor color: UIColor) -> UICModifiedView<View> {
        self.onInTheScene {
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
    func navigation(largeTitleFont font: UIFont) -> UICModifiedView<View> {
        self.onInTheScene {
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
    func navigation(largeContentImage image: UIImage?) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigation?.navigationController?.navigationBar.largeContentImage = image
        }
    }

    @available(iOS 13.0, *)
    func navigation(largeContentTitle title: String?) -> UICModifiedView<View> {
        self.onInTheScene {
            $0.navigation?.navigationController?.navigationBar.largeContentTitle = title
        }
    }
}
#endif

public extension UIViewCreator {
    func navigation(title dynamicTitle: Relay<String?>) -> UICModifiedView<View> {
        self.onInTheScene {
            weak var view = $0

            dynamicTitle.sync {
                view?.navigationItem.title = $0
            }
        }
    }
}
