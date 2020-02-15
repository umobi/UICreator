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

public class UIViewWrapper {
    private let wrap: ViewCreator
    public init(_ wrap: ViewCreator) {
        self.wrap = wrap
    }

    /// This will retain view on viewCreator
    public weak var uiView: UIView! {
        return self.wrap.uiView
    }

    /// This changes the keeper reference to UIView
    public func releaseUIView() -> UIView! {
        return self.wrap.releaseUIView()
    }
}

public protocol UIViewMaker: ViewCreator {
    var loadView: UIView { get }
}

public protocol UICViewRepresentable: UIViewCreator, UIViewMaker {
    var uiView: View! { get }
    func makeUIView() -> View
    func updateView(_ view: View)
}

internal extension UIViewMaker {
    func makeView() -> UIView {
        if let view = objc_getAssociatedObject(self, &kUIView) as? UIView {
            return view
        }

        let view = self.loadView
        view.updateBuilder(self)
        objc_setAssociatedObject(self, &kUIView, view, .OBJC_ASSOCIATION_RETAIN)
        return view
    }
}

public extension UICViewRepresentable {
    var loadView: UIView {
        return self.makeUIView().appendInTheScene { [weak self] in
            guard let view = ($0 as? View) else {
                return
            }

            self?.updateView(view)
        }
    }

    var uiView: View! {
        return (self as ViewCreator).uiView as? View
    }
}
