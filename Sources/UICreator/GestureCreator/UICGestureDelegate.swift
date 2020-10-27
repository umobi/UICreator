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

public final class UICGestureDelegate: NSObject, UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer) -> Bool {

        gestureRecognizer.commit(\.shouldBegin, gestureRecognizer) ?? true
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        gestureRecognizer.commit(
            \.shouldRecognizeSimultaneouslyGesture,
            gestureRecognizer,
            otherGestureRecognizer
        ) ?? false
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        gestureRecognizer.commit(
            \.shouldRequireFailureOfGesture,
            gestureRecognizer,
            otherGestureRecognizer
        ) ?? gestureRecognizer.shouldRequireFailure(of: otherGestureRecognizer)
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        gestureRecognizer.commit(
            \.shouldBeRequiredToFailByOther,
            gestureRecognizer,
            otherGestureRecognizer
        ) ?? gestureRecognizer.shouldBeRequiredToFail(by: otherGestureRecognizer)
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch) -> Bool {

        gestureRecognizer.commit(
            \.shouldReceiveTouch,
            gestureRecognizer,
            touch
        ) ?? true
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive press: UIPress) -> Bool {

        gestureRecognizer.commit(
            \.shouldReceivePress,
            gestureRecognizer,
            press
        ) ?? true
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive event: UIEvent) -> Bool {
        if #available(iOS 13.4, tvOS 13.4, *) {

            return gestureRecognizer.commit(
                \.shouldReceiveEvent,
                gestureRecognizer,
                event
            ) ?? gestureRecognizer.shouldReceive(event)
        }

        return gestureRecognizer.commit(
            \.shouldReceiveEvent,
            gestureRecognizer,
            event
        ) ?? true
    }
}
