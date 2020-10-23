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

struct UIGesturePayload {
    let gestureObject: Mutable<MemorySwitch> = .init(value: .nil)
    let targetViewObject: Mutable<MemorySwitch> = .init(value: .nil)
}

private var kUIGesturePayload: UInt = 0
internal extension UIGestureRecognizer {
    private var mutable: UIGesturePayload {
        OBJCSet(
            self,
            &kUIGesturePayload,
            policity: .strong,
            orLoad: UIGesturePayload.init
        )
    }

    var parent: Gesture? {
        self.mutable.gestureObject.value.object as? Gesture
    }

    var targetView: UIView? {
        get { self.mutable.targetViewObject.value.castedObject() ?? self.view }
        set {
            if let newValue = newValue {
                self.mutable.targetViewObject.value = .weak(newValue)
                return
            }

            self.mutable.targetViewObject.value = .nil
        }
    }

    static func set(_ uiGesture: UIGestureRecognizer, _ gesture: Gesture?, weak: Bool) {
        guard let gesture = gesture else {
            uiGesture.mutable.gestureObject.value = .nil
            return
        }

        if weak {
            uiGesture.mutable.gestureObject.value = .weak(gesture)
            return
        }

        uiGesture.mutable.gestureObject.value = .strong(gesture)
    }

    convenience init(target view: UIView!) {
        self.init(target: view, action: #selector(view.someGestureRecognized(_:)))
        self.targetView = view
    }
}
