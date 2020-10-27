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

public extension UIViewCreator where View: UIControl {
    @inlinable
    func isEnabled(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? UIControl)?.isEnabled = flag
        }
    }

    @inlinable
    func contentHorizontal(alignment: UIControl.ContentHorizontalAlignment) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? UIControl)?.contentHorizontalAlignment = alignment
        }
    }

    @inlinable
    func contentVertical(alignment: UIControl.ContentVerticalAlignment) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? UIControl)?.contentVerticalAlignment = alignment
        }
    }
}

public extension UIViewCreator where View: UIControl {
    @inlinable
    func isEnabled(_ isEnabled: Relay<Bool>) -> UICModifiedView<View> {
        return self.onNotRendered { view in
            weak var weakView = view

            isEnabled.sync {
                (weakView as? View)?.isEnabled = $0
            }
        }
    }
}

extension UIViewCreator where View: UIControl {
    @usableFromInline
    func onEvent(_ event: UIControl.Event, _ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.onEvent(event, handler)
        }
    }
}
