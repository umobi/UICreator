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
import UIContainer

public class UICHost: Root, ViewControllerType, UIViewCreator {
    public init(size: CGSize = .zero, content: @escaping () -> ViewCreator) {
        super.init()
//        super.init(loader: nil)
        self.uiView.frame = .init(origin: self.uiView.frame.origin, size: size)
        _ = self.uiView.add(content().releaseUIView())
    }
}

extension UICHost: ViewControllerAppearStates {
    var hosted: ViewCreator? {
        return (self.uiView.subviews.first(where: { $0.viewCreator != nil }))?.viewCreator
    }

    public func viewWillAppear(_ animated: Bool) {
        (self.hosted as? ViewControllerAppearStates)?.viewWillAppear(animated)
    }

    public func viewDidAppear(_ animated: Bool) {
        (self.hosted as? ViewControllerAppearStates)?.viewDidAppear(animated)
    }

    public func viewWillDisappear(_ animated: Bool) {
        (self.hosted as? ViewControllerAppearStates)?.viewWillDisappear(animated)
    }

    public func viewDidDisappear(_ animated: Bool) {
        (self.hosted as? ViewControllerAppearStates)?.viewDidDisappear(animated)
    }
}
