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
import ConstraintBuilder
import UIKit

@frozen
public struct UICNavigationLink: ViewCreator {
    @Relay private var isPushing: Bool

    private let destination: () -> ViewCreator
    private let content: ViewCreator

    public init(
        _ isPushing: Relay<Bool>,
        destination: @escaping () -> ViewCreator,
        content: () -> ViewCreator) {

        self._isPushing = isPushing
        self.destination = destination
        self.content = content()
    }

    public init(
        destination: @escaping () -> ViewCreator,
        content: () -> ViewCreator) {

        let value = Value(wrappedValue: false)

        self._isPushing = value.projectedValue
        self.destination = destination
        self.content = UICAnyView(content()).onTap { _ in
            value.wrappedValue = true
        }
    }

    public init(
        destination: @escaping (Relay<Bool>) -> ViewCreator,
        content: @escaping () -> ViewCreator) {

        let value = Value(wrappedValue: false)

        self._isPushing = value.projectedValue
        self.destination = { destination(value.projectedValue) }
        self.content = UICAnyView(content()).onTap { _ in
            value.wrappedValue = true
        }
    }

    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        let isPushing = _self.$isPushing
        let destination = _self.destination

        return UICAnyView(_self.content)
            .onInTheScene {
                weak var navigationController = $0.navigationController
                weak var pushingView: UIViewController?

                isPushing.distinctSync {
                    if $0 {
                        guard
                            let navigationController = navigationController,
                            pushingView == nil
                        else { return }

                        let viewController = UICHostingController(rootView: destination())
                        pushingView = viewController
                        viewController.onDisappear {
                            if $0.isBeingPoped {
                                isPushing.wrappedValue = false
                            }
                        }

                        navigationController.pushViewController(
                            viewController,
                            animated: true
                        )

                    } else {
                        guard
                            let pushedView = pushingView,
                            let beforeView = pushedView.beforeNavigationView
                        else { return }

                        pushingView = nil

                        pushedView.navigationController?.popToViewController(
                            beforeView,
                            animated: true
                        )
                    }
                }
            }
            .releaseUIView()
    }
}

private extension UIViewController {

    @inline(__always)
    var isBeingPoped: Bool {
        !(self.navigationController?.viewControllers.contains(self) ?? false)
    }

    var beforeNavigationView: UIViewController? {
         let index = (self.navigationController?
            .viewControllers
            .enumerated()
            .first(where: { $0.element === self })?
            .offset ?? 0) - 1

        guard index >= .zero else {
            return nil
        }

        return self.navigationController?.viewControllers[index]
    }
}
