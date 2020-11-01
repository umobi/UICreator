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

public protocol UIGestureCreator: GestureCreator {
    associatedtype Gesture: UIGestureRecognizer

    func onModify(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture>
}

public extension UIGestureCreator {
    @inline(__always) @inlinable
    func onModify(_ onModify: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        UICModifiedGesture(self, onModify: onModify)
    }
}

public extension UIGestureCreator {
    @inlinable
    func `as`(_ outlet: UICOutlet<Gesture>) -> UICModifiedGesture<Gesture> {
        self.onModify {
            outlet.ref($0 as? Gesture)
        }
    }

    @inlinable
    func allowedPress(types pressTypes: Set<UIPress.PressType>) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.allowedPressTypes = pressTypes.map { NSNumber(value: $0.rawValue) }
        }
    }

    @inlinable
    func allowedTouch(types touchTypes: Set<UITouch.TouchType>) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.allowedTouchTypes = touchTypes.map { NSNumber(value: $0.rawValue) }
        }
    }

    @inlinable
    func cancelsTouches(inView flag: Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.cancelsTouchesInView = flag
        }
    }

    @inlinable
    func delaysTouches(atBegan flag: Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.delaysTouchesEnded = flag
        }
    }

    @inlinable
    func delaysTouches(atEnded flag: Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.delaysTouchesEnded = flag
        }
    }

    @inlinable
    func isEnabled(_ flag: Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.isEnabled = flag
        }
    }

    @inlinable @available(iOS 11, tvOS 11.0, *)
    func name(_ string: String?) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.name = string
        }
    }

    @inlinable
    func requiredExclusive(touchType flag: Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.requiresExclusiveTouchType = flag
        }
    }
}

public extension UIGestureCreator {

    @inlinable
    func onBegan(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onBegan(handler)
        }
    }

    @inlinable
    func onCancelled(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onCancelled(handler)
        }
    }

    @inlinable
    func onChanged(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onChanged(handler)
        }
    }

    @inlinable
    func onFailed(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onFailed(handler)
        }
    }

    @inlinable
    func onRecognized(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onRecognized(handler)
        }
    }

    @inlinable
    func onPossible(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onPossible(handler)
        }
    }

    @inlinable
    func onEnded(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onEnded(handler)
        }
    }

    @inlinable
    func onAnyOther(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onAnyOther(handler)
        }
    }
}

public extension UIGestureCreator {

    @inlinable
    func onShouldBegin(_ handler: @escaping (UIGestureRecognizer) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onShouldBegin(handler)
        }
    }

    @inlinable
    func onShouldRecognizeSimultaneouslyGesture(
        _ handler: @escaping (UIGestureRecognizer, UIGestureRecognizer) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onShouldRecognizeSimultaneouslyGesture(handler)
        }
    }

    @inlinable
    func onShouldRequireFailureOfGesture(
        _ handler: @escaping (UIGestureRecognizer, UIGestureRecognizer) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onShouldRequireFailureOfGesture(handler)
        }
    }

    @inlinable
    func onShouldBeRequiredToFailByOtherGesture(
        _ handler: @escaping (UIGestureRecognizer, UIGestureRecognizer) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onShouldBeRequiredToFailByOther(handler)
        }
    }

    @inlinable
    func onShouldReceiveTouch(_ handler: @escaping (UIGestureRecognizer, UITouch) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onShouldReceiveTouch(handler)
        }
    }

    @inlinable
    func onShouldReceivePress(_ handler: @escaping (UIGestureRecognizer, UIPress) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onShouldReceivePress(handler)
        }
    }

    @inlinable
    func onShouldReceiveEvent(_ handler: @escaping (UIGestureRecognizer, UIEvent) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onShouldReceiveEvent(handler)
        }
    }
}

