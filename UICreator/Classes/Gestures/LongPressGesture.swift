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

public class LongPressGesture: UILongPressGestureRecognizer, Gesture, HasViewDelegate {

    required public init(target: UIView!) {
        super.init(target: target, action: #selector(target.longPress(_:)))
    }

    @discardableResult
    public func delegate(_ delegate: UIGestureRecognizerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

extension Gesture where Self: UILongPressGestureRecognizer {
    func maximumMovement(_ value: CGFloat) -> Self {
        self.allowableMovement = value
        return self
    }

    func minimumPressDuration(_ duration: TimeInterval) -> Self {
        self.minimumPressDuration = duration
        return self
    }
}

fileprivate extension UIView {

    @objc func longPress(_ sender: LongPressGesture!) {
        sender.commit(sender)
    }
}

public extension UIViewCreator {

    func onLongPressMaker(_ longPressConfigurator: (LongPressGesture) -> LongPressGesture) -> Self {
        self.uiView.addGestureRecognizer(longPressConfigurator(LongPressGesture(target: self.uiView)))
        return self
    }

    func onLongPress(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onLongPressMaker {
            $0.onRecognized { _ in
                handler(self.uiView)
            }
        }
    }
}
