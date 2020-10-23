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

@frozen
public struct UICPresent {
    let presentingStyle: UIModalPresentationStyle
    let transitionStyle: UIModalTransitionStyle
    weak var fromView: ViewCreator?
    let toView: (() -> ViewCreator)?
    let onCompletion: (() -> Void)?
    let animated: Bool

    init(fromView: ViewCreator) {
        self.fromView = fromView
        self.toView = nil
        self.onCompletion = nil
        if #available(iOS 13, tvOS 13, *) {
            self.presentingStyle = .automatic
        } else {
            self.presentingStyle = .currentContext
        }
        self.transitionStyle = .coverVertical
        self.animated = true
    }

    private init(_ original: UICPresent, editable: Editable) {
        self.presentingStyle = editable.presentingStyle
        self.transitionStyle = editable.transitionStyle
        self.fromView = original.fromView
        self.toView = editable.toView
        self.onCompletion = editable.onCompletion
        self.animated = editable.animated
    }

    private func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    public func presentingStyle(_ style: UIModalPresentationStyle) -> Self {
        self.edit {
            $0.presentingStyle = style
        }
    }

    public func transitionStyle(_ style: UIModalTransitionStyle) -> Self {
        self.edit {
            $0.transitionStyle = style
        }
    }

    public func onCompletion(_ handler: @escaping () -> Void) -> Self {
        self.edit {
            $0.onCompletion = handler
        }
    }

    public func animated(_ flag: Bool) -> Self {
        self.edit {
            $0.animated = flag
        }
    }

    func present() {
        let viewController = UICHostingController(content: self.toView!)

        viewController.modalPresentationStyle = self.presentingStyle
        viewController.modalTransitionStyle = self.transitionStyle

        self.fromView?.present(animated: self.animated, onCompletion: self.onCompletion, viewController)
    }

    func recycle(viewController: UIViewController) {
        viewController.modalPresentationStyle = self.presentingStyle
        viewController.modalTransitionStyle = self.transitionStyle
    }

    public func to(_ content: @escaping () -> ViewCreator) -> Self {
        self.edit {
            $0.toView = content
        }
    }

    public func present(content: @escaping () -> ViewCreator) {
        self.edit {
            $0.toView = content
        }.present()
    }

    private class Editable {
        var presentingStyle: UIModalPresentationStyle
        var transitionStyle: UIModalTransitionStyle
        var toView: (() -> ViewCreator)?
        var onCompletion: (() -> Void)?
        var animated: Bool

        init(_ present: UICPresent) {
            self.presentingStyle = present.presentingStyle
            self.transitionStyle = present.transitionStyle
            self.toView = present.toView
            self.onCompletion = present.onCompletion
            self.animated = present.animated
        }
    }
}
