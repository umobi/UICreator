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

struct ControlPayload: MutableEditable {

    let touchDown: UIHandler<UIView>?
    let touchDownRepeat: UIHandler<UIView>?
    let touchDragInside: UIHandler<UIView>?
    let touchDragOutside: UIHandler<UIView>?
    let touchDragEnter: UIHandler<UIView>?
    let touchDragExit: UIHandler<UIView>?
    let touchUpInside: UIHandler<UIView>?
    let touchUpOutside: UIHandler<UIView>?
    let touchCancel: UIHandler<UIView>?
    let editingDidBegin: UIHandler<UIView>?
    let valueChanged: UIHandler<UIView>?
    let primaryActionTriggered: UIHandler<UIView>?
    let editingChanged: UIHandler<UIView>?
    let editingDidEnd: UIHandler<UIView>?
    let editingDidEndOnExit: UIHandler<UIView>?
    let allTouchEvents: UIHandler<UIView>?
    let allEditingEvents: UIHandler<UIView>?
    let applicationReserved: UIHandler<UIView>?
    let systemReserved: UIHandler<UIView>?
    let allEvents: UIHandler<UIView>?

    init() {
        self.touchDown = nil
        self.touchDownRepeat = nil
        self.touchDragInside = nil
        self.touchDragOutside = nil
        self.touchDragEnter = nil
        self.touchDragExit = nil
        self.touchUpInside = nil
        self.touchUpOutside = nil
        self.touchCancel = nil
        self.editingDidBegin = nil
        self.valueChanged = nil
        self.primaryActionTriggered = nil
        self.editingChanged = nil
        self.editingDidEnd = nil
        self.editingDidEndOnExit = nil
        self.allTouchEvents = nil
        self.allEditingEvents = nil
        self.applicationReserved = nil
        self.systemReserved = nil
        self.allEvents = nil
    }

    init(_ original: ControlPayload, editable: Editable) {
        self.touchDown = editable.touchDown
        self.touchDownRepeat = editable.touchDownRepeat
        self.touchDragInside = editable.touchDragInside
        self.touchDragOutside = editable.touchDragOutside
        self.touchDragEnter = editable.touchDragEnter
        self.touchDragExit = editable.touchDragExit
        self.touchUpInside = editable.touchUpInside
        self.touchUpOutside = editable.touchUpOutside
        self.touchCancel = editable.touchCancel
        self.editingDidBegin = editable.editingDidBegin
        self.valueChanged = editable.valueChanged
        self.primaryActionTriggered = editable.primaryActionTriggered
        self.editingChanged = editable.editingChanged
        self.editingDidEnd = editable.editingDidEnd
        self.editingDidEndOnExit = editable.editingDidEndOnExit
        self.allTouchEvents = editable.allTouchEvents
        self.allEditingEvents = editable.allEditingEvents
        self.applicationReserved = editable.applicationReserved
        self.systemReserved = editable.systemReserved
        self.allEvents = editable.allEvents
    }

    func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

extension ControlPayload {
    class Editable {

        var touchDown: UIHandler<UIView>?
        var touchDownRepeat: UIHandler<UIView>?
        var touchDragInside: UIHandler<UIView>?
        var touchDragOutside: UIHandler<UIView>?
        var touchDragEnter: UIHandler<UIView>?
        var touchDragExit: UIHandler<UIView>?
        var touchUpInside: UIHandler<UIView>?
        var touchUpOutside: UIHandler<UIView>?
        var touchCancel: UIHandler<UIView>?
        var editingDidBegin: UIHandler<UIView>?
        var valueChanged: UIHandler<UIView>?
        var primaryActionTriggered: UIHandler<UIView>?
        var editingChanged: UIHandler<UIView>?
        var editingDidEnd: UIHandler<UIView>?
        var editingDidEndOnExit: UIHandler<UIView>?
        var allTouchEvents: UIHandler<UIView>?
        var allEditingEvents: UIHandler<UIView>?
        var applicationReserved: UIHandler<UIView>?
        var systemReserved: UIHandler<UIView>?
        var allEvents: UIHandler<UIView>?

        init(_ payload: ControlPayload) {
            self.touchDown = payload.touchDown
            self.touchDownRepeat = payload.touchDownRepeat
            self.touchDragInside = payload.touchDragInside
            self.touchDragOutside = payload.touchDragOutside
            self.touchDragEnter = payload.touchDragEnter
            self.touchDragExit = payload.touchDragExit
            self.touchUpInside = payload.touchUpInside
            self.touchUpOutside = payload.touchUpOutside
            self.touchCancel = payload.touchCancel
            self.editingDidBegin = payload.editingDidBegin
            self.valueChanged = payload.valueChanged
            self.primaryActionTriggered = payload.primaryActionTriggered
            self.editingChanged = payload.editingChanged
            self.editingDidEnd = payload.editingDidEnd
            self.editingDidEndOnExit = payload.editingDidEndOnExit
            self.allTouchEvents = payload.allTouchEvents
            self.allEditingEvents = payload.allEditingEvents
            self.applicationReserved = payload.applicationReserved
            self.systemReserved = payload.systemReserved
            self.allEvents = payload.allEvents
        }
    }
}
