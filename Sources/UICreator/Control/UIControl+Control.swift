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

extension UIControl {
    // swiftlint:disable function_body_length cyclomatic_complexity
    public func removeEvent(_ event: UIControl.Event) {
        self.removeTarget(self, action: nil, for: event)
        switch event {
        case .touchDown:
            self.memory.touchDownHandler = nil

        case .touchDownRepeat:
            self.memory.touchDownRepeatHandler = nil
        case .touchDragInside:
            self.memory.touchDragInsideHandler = nil
        case .touchDragOutside:
            self.memory.touchDragOutsideHandler = nil
        case .touchDragEnter:
            self.memory.touchDragEnterHandler = nil
        case .touchDragExit:
            self.memory.touchDragExitHandler = nil
        case .touchUpInside:
            self.memory.touchUpInsideHandler = nil
        case .touchUpOutside:
            self.memory.touchUpOutsideHandler = nil
        case .touchCancel:
            self.memory.touchCancelHandler = nil

        case .valueChanged:
            self.memory.valueChangedHandler = nil
        case .primaryActionTriggered:
            self.memory.primaryActionTriggeredHandler = nil

        case .editingDidBegin:
            self.memory.editingDidBeginHandler = nil
        case .editingChanged:
            self.memory.editingChangedHandler = nil
        case .editingDidEnd:
            self.memory.editingDidEndHandler = nil
        case .editingDidEndOnExit:
            self.memory.editingDidEndOnExitHandler = nil

        case .allTouchEvents:
            self.memory.allTouchEventsHandler = nil
        case .allEditingEvents:
            self.memory.allEditingEventsHandler = nil
        case .applicationReserved:
            self.memory.applicationReservedHandler = nil
        case .systemReserved:
            self.memory.systemReservedHandler = nil
        case .allEvents:
            self.memory.allEventsHandler = nil

        default:
            self.memory.allEventsHandler = nil
        }
    }
}
