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

public class GestureDelegate<Gesture>: NSObject, UIGestureRecognizerDelegate where Gesture: UIGestureRecognizer {

    private var shouldBeginHandler: ((Gesture) -> Bool)? = nil
    func onShouldBegin(_ handler: @escaping (Gesture) -> Bool) {
        let old = self.shouldBeginHandler
        self.shouldBeginHandler = {
            if old?($0) ?? false {
                return true
            }

            return handler($0)
        }
    }

    private var shouldRecognizeSimultaneouslyOtherGestureHandler: ((Gesture, UIGestureRecognizer) -> Bool)? = nil
    func onShouldRecognizeSimultaneouslyOtherGesture(_ handler: @escaping (Gesture, UIGestureRecognizer) -> Bool) {
        let old = self.shouldRecognizeSimultaneouslyOtherGestureHandler
        self.shouldRecognizeSimultaneouslyOtherGestureHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldRequireFailureOfOtherGestureHandler: ((Gesture, UIGestureRecognizer) -> Bool)? = nil
    func onShouldRequireFailureOfOtherGesture(_ handler: @escaping (Gesture, UIGestureRecognizer) -> Bool) {
        let old = self.shouldRequireFailureOfOtherGestureHandler
        self.shouldRequireFailureOfOtherGestureHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldBeRequiredToFailByOtherGesture: ((Gesture, UIGestureRecognizer) -> Bool)? = nil
    func onShouldBeRequiredToFailByOtherGesture(_ handler: @escaping (Gesture, UIGestureRecognizer) -> Bool) {
        let old = self.shouldBeRequiredToFailByOtherGesture
        self.shouldBeRequiredToFailByOtherGesture = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldReceiveTouchHandler: ((Gesture, UITouch) -> Bool)? = nil
    func onShouldReceiveTouch(_ handler: @escaping (Gesture, UITouch) -> Bool) {
        let old = self.shouldReceiveTouchHandler
        self.shouldReceiveTouchHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldReceivePressHandler: ((Gesture, UIPress) -> Bool)? = nil
    func onShouldReceivePress(_ handler: @escaping (Gesture, UIPress) -> Bool) {
        let old = self.shouldReceivePressHandler
        self.shouldReceivePressHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldReceiveEventHandler: ((Gesture, UIEvent) -> Bool)? = nil
    func onShouldReceiveEvent(_ handler: @escaping (Gesture, UIEvent) -> Bool) {
        let old = self.shouldReceiveEventHandler
        self.shouldReceiveEventHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        return self.shouldBeginHandler?(gestureRecognizer) ?? true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        return self.shouldRecognizeSimultaneouslyOtherGestureHandler?(gestureRecognizer, otherGestureRecognizer) ?? false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        return self.shouldRecognizeSimultaneouslyOtherGestureHandler?(gestureRecognizer, otherGestureRecognizer) ?? gestureRecognizer.shouldRequireFailure(of: otherGestureRecognizer)
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        return self.shouldRequireFailureOfOtherGestureHandler?(gestureRecognizer, otherGestureRecognizer) ?? gestureRecognizer.shouldBeRequiredToFail(by: otherGestureRecognizer)
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        return self.shouldReceiveTouchHandler?(gestureRecognizer, touch) ?? true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        return self.shouldReceivePressHandler?(gestureRecognizer, press) ?? true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? Gesture else {
            fatalError()
        }

        if #available(iOS 13.4, tvOS 13.4, *) {
            return self.shouldReceiveEventHandler?(gestureRecognizer, event) ?? gestureRecognizer.shouldReceive(event)
        }

        return self.shouldReceiveEventHandler?(gestureRecognizer, event) ?? true
    }
}
