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

extension UIViewCreator {
    @usableFromInline
    func dynamicPresent(
        _ relay: Relay<Bool>,
        animated flag: Bool = true,
        content: @escaping () -> ViewCreator,
        viewControllerBuilder: ((UIViewController) -> Void)?) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            weak var view = $0
            weak var presentingView: UIViewController?

            relay.sync {
                if $0 {
                    guard presentingView == nil else {
                        return
                    }

                    guard let presentableViewController = view?.presentableViewController() else {
                        relay.wrappedValue = false
                        return
                    }

                    let hostingController = UICHostingController(rootView: content())
                    let projectedValue = relay.projectedValue
                    hostingController.onDismiss {
                        projectedValue.wrappedValue = false
                    }

                    viewControllerBuilder?(hostingController)

                    presentableViewController.present(
                        hostingController,
                        animated: flag,
                        completion: nil
                    )

                    presentingView = hostingController
                } else {
                    guard let presentedView = presentingView else {
                        return
                    }

                    presentedView.dismiss(animated: flag, completion: nil)
                }
            }
        }
    }
}

public extension UIViewCreator {

    @inline(__always) @inlinable
    func present(_ relay: Relay<Bool>, content: @escaping () -> ViewCreator) -> UICInTheSceneModifier<View> {
        self.dynamicPresent(
            relay,
            content: content,
            viewControllerBuilder: nil
        )
    }

    @inline(__always) @inlinable
    func presentMaker(_ relay: Relay<Bool>,_ presentMaker: () -> PresentMaker) -> UICInTheSceneModifier<View> {
        let presentMaker = presentMaker()

        return self.dynamicPresent(
            relay,
            animated: presentMaker.animated,
            content: presentMaker.viewToPresent,
            viewControllerBuilder: presentMaker.setViewController(_:)
        )
    }

    @inline(__always) @inlinable
    func presentModal(_ relay: Relay<Bool>, content: @escaping () -> ViewCreator) -> UICInTheSceneModifier<View> {
        self.presentMaker(relay) {
            PresentMaker(content)
                .animated(true)
                .presentingStyle(.overFullScreen)
        }
    }
}
