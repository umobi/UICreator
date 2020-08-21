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

private class NavigationLinkView: UIView {
    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            RenderManager(self)?.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            RenderManager(self)?.frame(newValue)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self)?.willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self)?.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self)?.didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self)?.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        RenderManager(self)?.traitDidChange()
    }
}

public class UICNavigationLink: ViewCreator {

    public init(_ relay: Relay<Bool>, destination: @escaping () -> ViewCreator, content: @escaping () -> ViewCreator) {
        self.loadView {
            NavigationLinkView(builder: self)
        }
        .onNotRendered {
            $0.add(priority: .required, content().releaseUIView())
        }
        .onInTheScene {
            weak var navigationController = $0.viewController.navigationController
            weak var pushingView: UIViewController?

            relay.distinctSync {
                if $0 {
                    guard
                        let navigationController = navigationController,
                        pushingView == nil
                    else { return }

                    let viewController = UICHostingController(content: destination)
                    pushingView = viewController
                    viewController.onDisappear {
                        if $0.isBeingPoped {
                            relay.wrappedValue = false
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
    }
}

private extension UIViewController {
    var isBeingPoped: Bool {
        self.navigationController?.viewControllers.contains(self) ?? true
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
