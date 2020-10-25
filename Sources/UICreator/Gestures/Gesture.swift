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

public protocol GestureCreator {
    static func makeUIGesture(_ gestureCreator: GestureCreator) -> UIGestureRecognizer
}

extension GestureCreator {
    func releaseUIGesture() -> UIGestureRecognizer {
        Self.makeUIGesture(self)
    }
}

public extension GestureCreator {
    func add(_ view: UIView) {
        let gestureRecognizer = self.releaseUIGesture()
        view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.addTarget(gestureRecognizer, action: #selector(gestureRecognizer.commit(_:)))
    }
}

public protocol UIGestureCreator: GestureCreator {
    associatedtype Gesture: UIGestureRecognizer

    func onModify(_ handler: @escaping (Gesture) -> Void) -> UICModifiedGesture<Gesture>
}

public extension UIGestureCreator {
    func onModify(_ handler: @escaping (Gesture) -> Void) -> UICModifiedGesture<Gesture> {
        UICModifiedGesture {
            let gesture = self.releaseCastedGesture()
            handler(gesture)
            return gesture
        }
    }
}

extension UIGestureCreator {
    func releaseCastedGesture() -> Gesture {
        self.releaseUIGesture() as! Gesture
    }
}

public struct UICModifiedGesture<Gesture>: UIGestureCreator where Gesture: UIGestureRecognizer {
    let gestureLoader: () -> Gesture

    init(_ gestureLoader: @escaping () -> Gesture) {
        self.gestureLoader = gestureLoader
    }

    public static func makeUIGesture(_ gestureCreator: GestureCreator) -> UIGestureRecognizer {
        (gestureCreator as! Self).gestureLoader()
    }
}

public struct AnyGesture: UIGestureCreator {
    public typealias Gesture = UIGestureRecognizer

    let gestureLoader: () -> Gesture

    init(_ gestureLoader: @escaping () -> Gesture) {
        self.gestureLoader = gestureLoader
    }

    public static func makeUIGesture(_ gestureCreator: GestureCreator) -> UIGestureRecognizer {
        (gestureCreator as! Self).gestureLoader()
    }
}

public protocol UICGestureRepresentable: UIGestureCreator {
    func makeUIGesture() -> Gesture
}

public extension UICGestureRepresentable {
    static func makeUIGesture(_ gestureCreator: GestureCreator) -> UIGestureRecognizer {
        (gestureCreator as! Self).makeUIGesture()
    }
}

private var kGestureDelegate: UInt = 0
internal extension UIGestureRecognizer {
    var gestureDelegate: GestureDelegate {
        OBJCSet(self, &kGestureDelegate, policity: .OBJC_ASSOCIATION_RETAIN) {
            let delegate = GestureDelegate()
            self.delegate = delegate
            return delegate
        }
    }
}

public extension UIGestureCreator {
    func `as`(_ outlet: UICOutlet<Gesture>) -> UICModifiedGesture<Gesture> {
        self.onModify {
            outlet.ref($0)
        }
    }

    func allowedPress(types pressTypes: Set<UIPress.PressType>) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.allowedPressTypes = pressTypes.map { NSNumber(value: $0.rawValue) }
        }
    }

    func allowedTouch(types touchTypes: Set<UITouch.TouchType>) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.allowedTouchTypes = touchTypes.map { NSNumber(value: $0.rawValue) }
        }
    }

    func cancelsTouches(inView flag: Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.cancelsTouchesInView = flag
        }
    }

    func delaysTouches(atBegan flag: Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.delaysTouchesEnded = flag
        }
    }

    func delaysTouches(atEnded flag: Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.delaysTouchesEnded = flag
        }
    }

    func isEnabled(_ flag: Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.isEnabled = flag
        }
    }

    @available(iOS 11, tvOS 11.0, *)
    func name(_ string: String?) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.name = string
        }
    }

    func requiredExclusive(touchType flag: Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.requiresExclusiveTouchType = flag
        }
    }
}

public extension UIGestureCreator {
    func onBegan(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onBegan(handler)
        }
    }

    func onCancelled(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onCancelled(handler)
        }
    }

    func onChanged(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onChanged(handler)
        }
    }

    func onFailed(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onFailed(handler)
        }
    }

    func onRecognized(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onRecognized(handler)
        }
    }

    func onPossible(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onPossible(handler)
        }
    }

    func onEnded(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onEnded(handler)
        }
    }

    func onAnyOther(_ handler: @escaping (UIGestureRecognizer) -> Void) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.onAnyOther(handler)
        }
    }
}

public extension UIGestureCreator {
    func onShouldBegin(_ handler: @escaping (UIGestureRecognizer) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.gestureDelegate.onShouldBegin(handler)
        }
    }

    func onShouldRecognizeSimultaneouslyOtherGesture(
        _ handler: @escaping (UIGestureRecognizer, UIGestureRecognizer) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.gestureDelegate.onShouldRecognizeSimultaneouslyOtherGesture(handler)
        }
    }

    func onShouldRequireFailureOfOtherGesture(
        _ handler: @escaping (UIGestureRecognizer, UIGestureRecognizer) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.gestureDelegate.onShouldRequireFailureOfOtherGesture(handler)
        }
    }

    func onShouldBeRequiredToFailByOtherGesture(
        _ handler: @escaping (UIGestureRecognizer, UIGestureRecognizer) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.gestureDelegate.onShouldBeRequiredToFailByOtherGesture(handler)
        }
    }

    func onShouldReceiveTouch(_ handler: @escaping (UIGestureRecognizer, UITouch) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.gestureDelegate.onShouldReceiveTouch(handler)
        }
    }

    func onShouldReceivePress(_ handler: @escaping (UIGestureRecognizer, UIPress) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.gestureDelegate.onShouldReceivePress(handler)
        }
    }

    func onShouldReceiveEvent(_ handler: @escaping (UIGestureRecognizer, UIEvent) -> Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.gestureDelegate.onShouldReceiveEvent(handler)
        }
    }
}
