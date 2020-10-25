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

private var kControlMutable: UInt = 0
internal extension UIControl {
    struct Memory {
        @MutableBox var touchDownHandler: ((UIView) -> Void)?
        @MutableBox var touchDownRepeatHandler: ((UIView) -> Void)?
        @MutableBox var touchDragInsideHandler: ((UIView) -> Void)?
        @MutableBox var touchDragOutsideHandler: ((UIView) -> Void)?
        @MutableBox var touchDragEnterHandler: ((UIView) -> Void)?
        @MutableBox var touchDragExitHandler: ((UIView) -> Void)?
        @MutableBox var touchUpInsideHandler: ((UIView) -> Void)?
        @MutableBox var touchUpOutsideHandler: ((UIView) -> Void)?
        @MutableBox var touchCancelHandler: ((UIView) -> Void)?
        @MutableBox var editingDidBeginHandler: ((UIView) -> Void)?
        @MutableBox var valueChangedHandler: ((UIView) -> Void)?
        @MutableBox var primaryActionTriggeredHandler: ((UIView) -> Void)?
        @MutableBox var editingChangedHandler: ((UIView) -> Void)?
        @MutableBox var editingDidEndHandler: ((UIView) -> Void)?
        @MutableBox var editingDidEndOnExitHandler: ((UIView) -> Void)?
        @MutableBox var allTouchEventsHandler: ((UIView) -> Void)?
        @MutableBox var allEditingEventsHandler: ((UIView) -> Void)?
        @MutableBox var applicationReservedHandler: ((UIView) -> Void)?
        @MutableBox var systemReservedHandler: ((UIView) -> Void)?
        @MutableBox var allEventsHandler: ((UIView) -> Void)?
    }

    var memory: Memory {
        OBJCSet(
            self,
            &kControlMutable,
            policity: .OBJC_ASSOCIATION_COPY,
            orLoad: Memory.init
        )
    }
}
