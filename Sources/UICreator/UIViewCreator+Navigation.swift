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

#if os(iOS)
public extension UIViewCreator {
    @inlinable
    func toolbar(@UICViewBuilder _ contents: @escaping () -> ViewCreator) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.nearVCFromNavigation()?.toolbarItems = contents().zip.map { view in
                UIBarButtonItem(customView: UICAnyView(view).releaseUIView())
            }
        }
    }

    @inlinable
    func toolbar(isHidden flag: Bool) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationController?.isToolbarHidden = flag
        }
    }

    @inlinable
    func toolbar(style: UIBarStyle) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
           $0.navigationController?.toolbar.barStyle = style
        }
    }

    @inlinable
    func toolbar(tintColor color: UIColor?) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
           $0.navigationController?.toolbar.tintColor = color
        }
    }

    @inlinable
    func toolbar(barTintColor color: UIColor?) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
           $0.navigationController?.toolbar.barTintColor = color
        }
    }

    @inlinable
    func toolbar(delegate: UIToolbarDelegate?) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
           $0.navigationController?.toolbar.delegate = delegate
        }
    }

    @inlinable
    func toolbar(isTranslucent flag: Bool) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
           $0.navigationController?.toolbar.isTranslucent = flag
        }
    }

    @available(iOS 13.0, *) @inlinable
    func toolbar(standardAppearance appearance: UIToolbarAppearance) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
           $0.navigationController?.toolbar.standardAppearance = appearance
        }
    }

    @available(iOS 13.0, *) @inlinable
    func toolbar(compactAppearance appearance: UIToolbarAppearance?) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
           $0.navigationController?.toolbar.compactAppearance = appearance
        }
    }
}
#endif

public extension UIViewCreator {

    @inlinable
    func navigation(isHidden flag: Bool) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
           $0.navigationController?.isNavigationBarHidden = flag
        }
    }

    @inlinable
    func navigation(title: String?) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationItem.title = title
        }
    }

    @inlinable
    func navigation(titleView content: @escaping () -> ViewCreator) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationItem.titleView = UICAnyView(content()).releaseUIView()
        }
    }

    @inlinable
    func navigation(
        background image: UICImage?,
        for position: UIBarPosition = .any,
        barMetrics: UIBarMetrics = .default) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationController?
                .navigationBar
                .setBackgroundImage(
                    image?.uiImage,
                    for: position,
                    barMetrics: barMetrics
                )
        }
    }

    #if os(iOS)
    @inlinable
    func navigation(backButton content: @escaping () -> ViewCreator) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationItem.backBarButtonItem = .init(
                title: "",
                style: .plain,
                target: nil,
                action: nil
            )

            guard ($0.navigationController?.viewControllers.count ?? 0) > 1 else {
                print("Navigation doesn't accepted backButton, you may try to assign as leftButton")
                return
            }

            $0.navigationItem.setLeftBarButton(
                .init(customView: UICAnyView(content()).releaseUIView()),
                animated: false
            )
        }
    }
    #endif

    @inlinable
    func navigation(leftButton content: @escaping () -> ViewCreator) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationItem.setLeftBarButton(
                .init(customView: UICAnyView(content()).releaseUIView()),
                animated: false
            )
        }
    }

    @inlinable
    func navigation(@UICViewBuilder leftButtons contents: @escaping () -> ViewCreator) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationItem
                .setLeftBarButtonItems(contents().zip.map { view in
                    .init(customView: UICAnyView(view).releaseUIView())
                }, animated: false)
        }
    }

    @inlinable
    func navigation(rightButton content: @escaping () -> ViewCreator) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationItem.setRightBarButton(
                .init(customView: UICAnyView(content()).releaseUIView()),
                animated: false
            )
        }
    }

    @inlinable
    func navigation(@UICViewBuilder rightButtons contents: @escaping () -> ViewCreator) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationItem
                .setRightBarButtonItems(contents().zip.map { view in
                    .init(customView: UICAnyView(view).releaseUIView())
                }, animated: false)
        }
    }

    #if os(iOS)
    @available(iOS 11.0, *) @inlinable
    func navigation(searchController: UISearchController) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationItem.searchController = searchController
        }
    }
    #endif
}

public extension UIViewCreator {
    @inlinable
    func navigation(titleColor color: UIColor) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
           guard let navigationBar = $0.navigationController?.navigationBar else {
               return
           }

            navigationBar.titleTextAttributes = (navigationBar.titleTextAttributes ?? [:]).merging(
                [NSAttributedString.Key.foregroundColor: color],
                uniquingKeysWith: { $1 }
            )
        }
    }

    @inlinable
    func navigation(titleFont font: UIFont) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            guard let navigationBar = $0.navigationController?.navigationBar else {
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
    @available(iOS 11.0, *) @inlinable
    func navigation(largeTitleMode mode: UINavigationItem.LargeTitleDisplayMode) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationItem.largeTitleDisplayMode = mode
        }
    }

    @available(iOS 11.0, *) @inlinable
    func navigation(prefersLargeTitles: Bool) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        }
    }

    @available(iOS 11.0, *) @inlinable
    func navigation(largeTitleColor color: UIColor) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            guard let navigationBar = $0.navigationController?.navigationBar else {
                return
            }

            navigationBar.largeTitleTextAttributes = (navigationBar.largeTitleTextAttributes ?? [:]).merging(
                [NSAttributedString.Key.foregroundColor: color],
                uniquingKeysWith: { $1 }
            )
        }
    }

    @available(iOS 11.0, *) @inlinable
    func navigation(largeTitleFont font: UIFont) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            guard let navigationBar = $0.navigationController?.navigationBar else {
                return
            }

            navigationBar.largeTitleTextAttributes = (navigationBar.largeTitleTextAttributes ?? [:]).merging(
                [NSAttributedString.Key.font: font],
                uniquingKeysWith: { $1 }
            )
        }
    }

    @available(iOS 13.0, *) @inlinable
    func navigation(largeContentImage image: UICImage?) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationController?.navigationBar.largeContentImage = image?.uiImage
        }
    }

    @available(iOS 13.0, *) @inlinable
    func navigation(largeContentTitle title: String?) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.navigationController?.navigationBar.largeContentTitle = title
        }
    }
}
#endif

public extension UIViewCreator {

    @inlinable
    func navigation(title dynamicTitle: Relay<String?>) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            weak var view = $0

            dynamicTitle.sync {
                view?.navigationItem.title = $0
            }
        }
    }
}
