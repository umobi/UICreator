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

public class LongPress: UIGesture {
    public typealias Gesture = UILongPressGestureRecognizer

    public required init(target view: UIView!) {
        self.setGesture(Gesture.init(target: view))
        self.gesture.parent = self
    }
}

public extension UIGesture where Gesture: UILongPressGestureRecognizer {
    func maximumMovement(_ value: CGFloat) -> Self {
        (self.gesture as? Gesture)?.allowableMovement = value
        return self
    }

    func minimumPressDuration(_ duration: TimeInterval) -> Self {
        (self.gesture as? Gesture)?.minimumPressDuration = duration
        return self
    }
}

public extension UIViewCreator {

    func onLongPressMaker(_ longPressConfigurator: (LongPress) -> LongPress) -> Self {
        self.uiView.addGesture(longPressConfigurator(LongPress(target: self.uiView)))
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
