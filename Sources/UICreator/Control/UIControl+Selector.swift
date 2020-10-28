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

fileprivate extension UIControl {
    @objc func onTouchDown() {
        self.memory.touchDownHandler?(self)
    }

    @objc func onTouchDownRepeat() {
        self.memory.touchDownRepeatHandler?(self)
    }

    @objc func onTouchDragInside() {
        self.memory.touchDragInsideHandler?(self)
    }

    @objc func onTouchDragOutside() {
        self.memory.touchDragOutsideHandler?(self)
    }

    @objc func onTouchDragEnter() {
        self.memory.touchDragEnterHandler?(self)
    }

    @objc func onTouchDragExit() {
        self.memory.touchDragExitHandler?(self)
    }

    @objc func onTouchUpInside() {
        self.memory.touchUpInsideHandler?(self)
    }

    @objc func onTouchUpOutside() {
        self.memory.touchUpOutsideHandler?(self)
    }

    @objc func onTouchCancel() {
        self.memory.touchCancelHandler?(self)
    }

    @objc func onValueChanged() {
        self.memory.valueChangedHandler?(self)
    }

    @objc func onPrimaryActionTriggered() {
        self.memory.primaryActionTriggeredHandler?(self)
    }

    @objc func onEditingDidBegin() {
        self.memory.editingDidBeginHandler?(self)
    }

    @objc func onEditingChanged() {
        self.memory.editingChangedHandler?(self)
    }

    @objc func onEditingDidEnd() {
        self.memory.editingDidEndHandler?(self)
    }

    @objc func onEditingDidEndOnExit() {
        self.memory.editingDidEndOnExitHandler?(self)
    }

    @objc func onAllTouchEvents() {
        self.memory.allTouchEventsHandler?(self)
    }

    @objc func onAllEditingEvents() {
        self.memory.allEditingEventsHandler?(self)
    }

    @objc func onApplicationReserved() {
        self.memory.applicationReservedHandler?(self)
    }

    @objc func onSystemReserved() {
        self.memory.systemReservedHandler?(self)
    }

    @objc func onAllEvents() {
        self.memory.allEventsHandler?(self)
    }
}

extension UIControl {
    // swiftlint:disable function_body_length cyclomatic_complexity
    @discardableResult
    public func onEvent(_ event: UIControl.Event, _ handler: @escaping (CBView) -> Void) -> CBView {
        switch event {
        case .touchDown:
            if self.memory.touchDownHandler == nil {
                self.addTarget(self, action: #selector(self.onTouchDown), for: event)
            }
        case .touchDownRepeat:
            if self.memory.touchDownRepeatHandler == nil {
                self.addTarget(self, action: #selector(self.onTouchDownRepeat), for: event)
            }
        case .touchDragInside:
            if self.memory.touchDragInsideHandler == nil {
                self.addTarget(self, action: #selector(self.onTouchDragInside), for: event)
            }
        case .touchDragOutside:
            if self.memory.touchDragOutsideHandler == nil {
                self.addTarget(self, action: #selector(self.onTouchDragOutside), for: event)
            }
        case .touchDragEnter:
            if self.memory.touchDragEnterHandler == nil {
                self.addTarget(self, action: #selector(self.onTouchDragEnter), for: event)
            }
        case .touchDragExit:
            if self.memory.touchDragExitHandler == nil {
                self.addTarget(self, action: #selector(self.onTouchDragExit), for: event)
            }
        case .touchUpInside:
            if self.memory.touchUpInsideHandler == nil {
                self.addTarget(self, action: #selector(self.onTouchUpInside), for: event)
            }
        case .touchUpOutside:
            if self.memory.touchUpOutsideHandler == nil {
                self.addTarget(self, action: #selector(self.onTouchUpOutside), for: event)
            }
        case .touchCancel:
            if self.memory.touchCancelHandler == nil {
                self.addTarget(self, action: #selector(self.onTouchCancel), for: event)
            }

        case .valueChanged:
            if self.memory.valueChangedHandler == nil {
                self.addTarget(self, action: #selector(self.onValueChanged), for: event)
            }
        case .primaryActionTriggered:
            if self.memory.primaryActionTriggeredHandler == nil {
                self.addTarget(self, action: #selector(self.onPrimaryActionTriggered), for: event)
            }

        case .editingDidBegin:
            if self.memory.editingDidBeginHandler == nil {
                self.addTarget(self, action: #selector(self.onEditingDidBegin), for: event)
            }
        case .editingChanged:
            if self.memory.editingChangedHandler == nil {
                self.addTarget(self, action: #selector(self.onEditingChanged), for: event)
            }
        case .editingDidEnd:
            if self.memory.editingDidEndHandler == nil {
                self.addTarget(self, action: #selector(self.onEditingDidEnd), for: event)
            }
        case .editingDidEndOnExit:
            if self.memory.editingDidEndOnExitHandler == nil {
                self.addTarget(self, action: #selector(self.onEditingDidEndOnExit), for: event)
            }

        case .allTouchEvents:
            if self.memory.allTouchEventsHandler == nil {
                self.addTarget(self, action: #selector(self.onAllTouchEvents), for: event)
            }
        case .allEditingEvents:
            if self.memory.allEditingEventsHandler == nil {
                self.addTarget(self, action: #selector(self.onAllEditingEvents), for: event)
            }
        case .applicationReserved:
            if self.memory.applicationReservedHandler == nil {
                self.addTarget(self, action: #selector(self.onApplicationReserved), for: event)
            }
        case .systemReserved:
            if self.memory.systemReservedHandler == nil {
                self.addTarget(self, action: #selector(self.onSystemReserved), for: event)
            }
        case .allEvents:
            if self.memory.allEditingEventsHandler == nil {
                self.addTarget(self, action: #selector(self.onAllEvents), for: event)
            }

        default:
            if self.memory.allEditingEventsHandler == nil {
                self.addTarget(self, action: #selector(self.onAllEvents), for: event)
            }
        }

        self.appendEvent(event, handler)
        return self
    }

    // swiftlint:disable function_body_length cyclomatic_complexity
    private func appendEvent(_ event: UIControl.Event, _ handler: @escaping (CBView) -> Void) {
        switch event {
        case .touchDown:
            let old = self.memory.touchDownHandler
            self.memory.touchDownHandler = {
                old?($0)
                handler($0)
            }
        case .touchDownRepeat:
            let old = self.memory.touchDownRepeatHandler
            self.memory.touchDownRepeatHandler = {
                old?($0)
                handler($0)
            }
        case .touchDragInside:
            let old = self.memory.touchDragInsideHandler
            self.memory.touchDragInsideHandler = {
                old?($0)
                handler($0)
            }
        case .touchDragOutside:
            let old = self.memory.touchDragOutsideHandler
            self.memory.touchDragOutsideHandler = {
                old?($0)
                handler($0)
            }
        case .touchDragEnter:
            let old = self.memory.touchDragEnterHandler
            self.memory.touchDragEnterHandler = {
                old?($0)
                handler($0)
            }
        case .touchDragExit:
            let old = self.memory.touchDragExitHandler
            self.memory.touchDragExitHandler = {
                old?($0)
                handler($0)
            }
        case .touchUpInside:
            let old = self.memory.touchUpInsideHandler
            self.memory.touchUpInsideHandler = {
                old?($0)
                handler($0)
            }
        case .touchUpOutside:
            let old = self.memory.touchUpOutsideHandler
            self.memory.touchUpOutsideHandler = {
                old?($0)
                handler($0)
            }
        case .touchCancel:
            let old = self.memory.touchCancelHandler
            self.memory.touchCancelHandler = {
                old?($0)
                handler($0)
            }

        case .valueChanged:
            let old = self.memory.valueChangedHandler
            self.memory.valueChangedHandler = {
                old?($0)
                handler($0)
            }
        case .primaryActionTriggered:
            let old = self.memory.primaryActionTriggeredHandler
            self.memory.primaryActionTriggeredHandler = {
                old?($0)
                handler($0)
            }

        case .editingDidBegin:
            let old = self.memory.editingDidBeginHandler
            self.memory.editingDidBeginHandler = {
                old?($0)
                handler($0)
            }
        case .editingChanged:
            let old = self.memory.editingChangedHandler
            self.memory.editingChangedHandler = {
                old?($0)
                handler($0)
            }
        case .editingDidEnd:
            let old = self.memory.editingDidEndHandler
            self.memory.editingDidEndHandler = {
                old?($0)
                handler($0)
            }
        case .editingDidEndOnExit:
            let old = self.memory.editingDidEndOnExitHandler
            self.memory.editingDidEndOnExitHandler = {
                old?($0)
                handler($0)
            }

        case .allTouchEvents:
            let old = self.memory.allTouchEventsHandler
            self.memory.allTouchEventsHandler = {
                old?($0)
                handler($0)
            }
        case .allEditingEvents:
            let old = self.memory.allEditingEventsHandler
            self.memory.allEditingEventsHandler = {
                old?($0)
                handler($0)
            }
        case .applicationReserved:
            let old = self.memory.applicationReservedHandler
            self.memory.applicationReservedHandler = {
                old?($0)
                handler($0)
            }
        case .systemReserved:
            let old = self.memory.systemReservedHandler
            self.memory.systemReservedHandler = {
                old?($0)
                handler($0)
            }
        case .allEvents:
            let old = self.memory.allEventsHandler
            self.memory.allEventsHandler = {
                old?($0)
                handler($0)
            }

        default:
            let old = self.memory.allEventsHandler
            self.memory.allEventsHandler = {
                old?($0)
                handler($0)
            }
        }
    }
}
