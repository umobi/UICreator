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

public class PanGesture: UIPanGestureRecognizer, GestureRecognizer {

    required public init(target: UIView!) {
        super.init(target: target, action: #selector(target.someGestureRecognized(_:)))
    }
}

public class Pan: UIGesture {
    public typealias Gesture = PanGesture

    public required init(target view: UIView!) {
        self.setGesture(Gesture.init(target: view))
        self.gesture.parent = self
    }
}

#if os(iOS)
extension UIGesture where Gesture: UIPanGestureRecognizer {
    func maximumNumber(ofTouches number: Int) -> Self {
        (self.gesture as? Gesture)?.maximumNumberOfTouches = number
        return self
    }

    func minimumNumber(ofTouches number: Int) -> Self {
        (self.gesture as? Gesture)?.minimumNumberOfTouches = number
        return self
    }
}
#endif

internal extension UIView {
    @objc func someGestureRecognized(_ sender: UIGestureRecognizer) {
        guard let sender = sender as? GestureRecognizer else {
            return
        }

        sender.parent?.commit(sender)
    }
}

public extension UIViewCreator {

    func onPanMaker(_ panConfigurator: (Pan) -> Pan) -> Self {
        self.uiView.addGestureRecognizer(panConfigurator(Pan(target: self.uiView)).gesture)
        return self
    }

    func onPan(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onPanMaker {
            $0.onRecognized { _ in
                handler(self.uiView)
            }
        }
    }
}
