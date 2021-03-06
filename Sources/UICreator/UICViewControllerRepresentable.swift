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

public protocol ViewControllerRepresentable: ViewCreator {
    func privateMakeUIView() -> UIView
}

public protocol UICViewControllerRepresentable: ViewControllerRepresentable, UIViewControllerCreator {
    func makeUIViewController() -> ViewController
    func updateViewController(_ viewController: ViewController)
}

internal extension ViewControllerRepresentable {
    var wrapper: UIView! {
        self.uiView?.superview
    }
}

public extension UICViewControllerRepresentable {
    func privateMakeUIView() -> UIView {
        if let view = self.uiView {
            return view
        }

        self.loadView { [unowned self] in
            let view: UIView! = self.makeUIViewController().view
            view.updateBuilder(self)
            return view
        }.onInTheScene {
            guard let viewController = $0.viewController as? ViewController else {
                return
            }

            self.updateViewController(viewController)
        }

        return Adaptor(.viewController(self)).releaseUIView()
    }
}

public extension UICViewControllerRepresentable {

    var uiViewController: ViewController! {
        (self as ViewCreator).uiView?.next as? ViewController
    }

    var wrapper: UIView! {
        self.uiView?.superview
    }
}
