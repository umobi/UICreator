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

    /// UIViewWrapper gets the UIView inside the ViewCreator to expose the view directly used for imperative methods.
    public init(_ wrap: ViewCreator) {
        self.wrap = wrap
    }
    /// Constructing the UIViewWrapper with the view reference allows to make sure that view is related to some ViewCreator.
    public convenience init?(_ view: UIView) {
        guard let creator = view.viewCreator else {
            return nil
        }

        self.init(creator)
    }

    /// This will retain view on viewCreator
    public var uiView: UIView! {
        return self.wrap.uiView
    }

    /// This will release the UIView changing the reference to weak
    @available(*, deprecated, message: "Use UICHostingController(content:)")
    public func releaseUIView() -> UIView! {
        return self.wrap.releaseUIView()
    }

    /// Use this to get the safe view to append constraints.
    public var safe: UIView! {
        if let maker = self.wrap as? ViewRepresentable {
            return maker.wrapper
        }

        if let maker = self.wrap as? ViewControllerRepresentable {
            return maker.wrapper
        }

        return self.wrap.uiView
    }
}
