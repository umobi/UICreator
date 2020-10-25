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

public class GestureDelegate: NSObject, UIGestureRecognizerDelegate {

    private var shouldBeginHandler: ((UIGestureRecognizer) -> Bool)?
    func onShouldBegin(_ handler: @escaping (UIGestureRecognizer) -> Bool) {
        let old = self.shouldBeginHandler
        self.shouldBeginHandler = {
            if old?($0) ?? false {
                return true
            }

            return handler($0)
        }
    }

    private var shouldRecognizeSimultaneouslyGesture: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)?
    func onShouldRecognizeSimultaneouslyOtherGesture(
        _ handler: @escaping (UIGestureRecognizer, UIGestureRecognizer) -> Bool) {

        let old = self.shouldRecognizeSimultaneouslyGesture
        self.shouldRecognizeSimultaneouslyGesture = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldRequireFailureOfGestureHandler: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)?
    func onShouldRequireFailureOfOtherGesture(
        _ handler: @escaping (UIGestureRecognizer, UIGestureRecognizer) -> Bool) {

        let old = self.shouldRequireFailureOfGestureHandler
        self.shouldRequireFailureOfGestureHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldBeRequiredToFailByOtherGesture: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)?
    func onShouldBeRequiredToFailByOtherGesture(
        _ handler: @escaping (UIGestureRecognizer, UIGestureRecognizer) -> Bool) {

        let old = self.shouldBeRequiredToFailByOtherGesture
        self.shouldBeRequiredToFailByOtherGesture = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldReceiveTouchHandler: ((UIGestureRecognizer, UITouch) -> Bool)?
    func onShouldReceiveTouch(_ handler: @escaping (UIGestureRecognizer, UITouch) -> Bool) {
        let old = self.shouldReceiveTouchHandler
        self.shouldReceiveTouchHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldReceivePressHandler: ((UIGestureRecognizer, UIPress) -> Bool)?
    func onShouldReceivePress(_ handler: @escaping (UIGestureRecognizer, UIPress) -> Bool) {
        let old = self.shouldReceivePressHandler
        self.shouldReceivePressHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    private var shouldReceiveEventHandler: ((UIGestureRecognizer, UIEvent) -> Bool)?
    func onShouldReceiveEvent(_ handler: @escaping (UIGestureRecognizer, UIEvent) -> Bool) {
        let old = self.shouldReceiveEventHandler
        self.shouldReceiveEventHandler = {
            if old?($0, $1) ?? false {
                return true
            }

            return handler($0, $1)
        }
    }

    public func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer) -> Bool {

        self.shouldBeginHandler?(gestureRecognizer) ?? true
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        self.shouldRecognizeSimultaneouslyGesture?(
            gestureRecognizer,
            otherGestureRecognizer
        ) ?? false
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        self.shouldRequireFailureOfGestureHandler?(
            gestureRecognizer,
            otherGestureRecognizer
        ) ?? gestureRecognizer.shouldRequireFailure(of: otherGestureRecognizer)
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        self.shouldBeRequiredToFailByOtherGesture?(
            gestureRecognizer,
            otherGestureRecognizer
        ) ?? gestureRecognizer.shouldBeRequiredToFail(by: otherGestureRecognizer)
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch) -> Bool {

        self.shouldReceiveTouchHandler?(
            gestureRecognizer,
            touch
        ) ?? true
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive press: UIPress) -> Bool {

        self.shouldReceivePressHandler?(
            gestureRecognizer,
            press
        ) ?? true
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive event: UIEvent) -> Bool {
        if #available(iOS 13.4, tvOS 13.4, *) {
            return self.shouldReceiveEventHandler?(
                gestureRecognizer,
                event
            ) ?? gestureRecognizer.shouldReceive(event)
        }

        return self.shouldReceiveEventHandler?(
            gestureRecognizer,
            event
        ) ?? true
    }
}
