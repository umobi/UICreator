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

public protocol ViewRepresentable: ViewCreator {
    func privateMakeUIView() -> UIView
}

public protocol UICViewRepresentable: UIViewCreator, ViewRepresentable {
    func makeUIView() -> View
    func updateView(_ view: View)
}

internal extension ViewRepresentable {
    var wrapper: UIView! {
        self.uiView?.superview
    }
}

public extension UICViewRepresentable {
    func privateMakeUIView() -> UIView {
        if let view = self.uiView {
            return view
        }

        self.loadView { [unowned self] in
            let view = self.makeUIView()
            view.updateBuilder(self)
            return view
        }.onInTheScene { [weak self] in
            guard let view = $0 as? View else {
                fatalError()
            }
            self?.updateView(view)
        }

        return Adaptor(.view(self)).releaseUIView()
    }
}

public extension UICViewRepresentable {

    var uiView: View! {
        return (self as ViewCreator).uiView as? View
    }

    var wrapper: UIView! {
        self.uiView?.superview
    }
}
