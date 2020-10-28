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
import ConstraintBuilder

private var kControlMutable: UInt = 0
internal extension UIControl {
    struct Memory {
        @MutableBox var touchDownHandler: ((CBView) -> Void)?
        @MutableBox var touchDownRepeatHandler: ((CBView) -> Void)?
        @MutableBox var touchDragInsideHandler: ((CBView) -> Void)?
        @MutableBox var touchDragOutsideHandler: ((CBView) -> Void)?
        @MutableBox var touchDragEnterHandler: ((CBView) -> Void)?
        @MutableBox var touchDragExitHandler: ((CBView) -> Void)?
        @MutableBox var touchUpInsideHandler: ((CBView) -> Void)?
        @MutableBox var touchUpOutsideHandler: ((CBView) -> Void)?
        @MutableBox var touchCancelHandler: ((CBView) -> Void)?
        @MutableBox var editingDidBeginHandler: ((CBView) -> Void)?
        @MutableBox var valueChangedHandler: ((CBView) -> Void)?
        @MutableBox var primaryActionTriggeredHandler: ((CBView) -> Void)?
        @MutableBox var editingChangedHandler: ((CBView) -> Void)?
        @MutableBox var editingDidEndHandler: ((CBView) -> Void)?
        @MutableBox var editingDidEndOnExitHandler: ((CBView) -> Void)?
        @MutableBox var allTouchEventsHandler: ((CBView) -> Void)?
        @MutableBox var allEditingEventsHandler: ((CBView) -> Void)?
        @MutableBox var applicationReservedHandler: ((CBView) -> Void)?
        @MutableBox var systemReservedHandler: ((CBView) -> Void)?
        @MutableBox var allEventsHandler: ((CBView) -> Void)?
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
