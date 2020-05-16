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

fileprivate extension UIControl {
    @objc func onTouchDown() {
        self.controlMemory.value.touchDown?.commit(in: self)
    }

    @objc func onTouchDownRepeat() {
        self.controlMemory.value.touchDownRepeat?.commit(in: self)
    }

    @objc func onTouchDragInside() {
        self.controlMemory.value.touchDragInside?.commit(in: self)
    }

    @objc func onTouchDragOutside() {
        self.controlMemory.value.touchDragOutside?.commit(in: self)
    }

    @objc func onTouchDragEnter() {
        self.controlMemory.value.touchDragEnter?.commit(in: self)
    }

    @objc func onTouchDragExit() {
        self.controlMemory.value.touchDragExit?.commit(in: self)
    }

    @objc func onTouchUpInside() {
        self.controlMemory.value.touchUpInside?.commit(in: self)
    }

    @objc func onTouchUpOutside() {
        self.controlMemory.value.touchUpOutside?.commit(in: self)
    }

    @objc func onTouchCancel() {
        self.controlMemory.value.touchCancel?.commit(in: self)
    }

    @objc func onValueChanged() {
        self.controlMemory.value.valueChanged?.commit(in: self)
    }

    @objc func onPrimaryActionTriggered() {
        self.controlMemory.value.primaryActionTriggered?.commit(in: self)
    }

    @objc func onEditingDidBegin() {
        self.controlMemory.value.editingDidBegin?.commit(in: self)
    }

    @objc func onEditingChanged() {
        self.controlMemory.value.editingChanged?.commit(in: self)
    }

    @objc func onEditingDidEnd() {
        self.controlMemory.value.editingDidEnd?.commit(in: self)
    }

    @objc func onEditingDidEndOnExit() {
        self.controlMemory.value.editingDidEndOnExit?.commit(in: self)
    }

    @objc func onAllTouchEvents() {
        self.controlMemory.value.allTouchEvents?.commit(in: self)
    }

    @objc func onAllEditingEvents() {
        self.controlMemory.value.allEditingEvents?.commit(in: self)
    }

    @objc func onApplicationReserved() {
        self.controlMemory.value.applicationReserved?.commit(in: self)
    }

    @objc func onSystemReserved() {
        self.controlMemory.value.systemReserved?.commit(in: self)
    }

    @objc func onAllEvents() {
        self.controlMemory.value.allEvents?.commit(in: self)
    }
}

extension Control {
    // swiftlint:disable function_body_length cyclomatic_complexity
    public func onEvent(_ event: UIControl.Event, _ handler: @escaping (UIView) -> Void) -> Self {
        self.appendEvent(event, handler)

        return self.onNotRendered {
            ($0 as? UIControl)?.addTarget($0, action: {
                switch event {
                case .touchDown:
                    return #selector(($0 as? UIControl)?.onTouchDown)
                case .touchDownRepeat:
                    return #selector(($0 as? UIControl)?.onTouchDownRepeat)
                case .touchDragInside:
                    return #selector(($0 as? UIControl)?.onTouchDragInside)
                case .touchDragOutside:
                    return #selector(($0 as? UIControl)?.onTouchDragOutside)
                case .touchDragEnter:
                    return #selector(($0 as? UIControl)?.onTouchDragEnter)
                case .touchDragExit:
                    return #selector(($0 as? UIControl)?.onTouchDragExit)
                case .touchUpInside:
                    return #selector(($0 as? UIControl)?.onTouchUpInside)
                case .touchUpOutside:
                    return #selector(($0 as? UIControl)?.onTouchUpOutside)
                case .touchCancel:
                    return #selector(($0 as? UIControl)?.onTouchCancel)

                case .valueChanged:
                    return #selector(($0 as? UIControl)?.onValueChanged)
                case .primaryActionTriggered:
                    return #selector(($0 as? UIControl)?.onPrimaryActionTriggered)

                case .editingDidBegin:
                    return #selector(($0 as? UIControl)?.onEditingDidBegin)
                case .editingChanged:
                    return #selector(($0 as? UIControl)?.onEditingChanged)
                case .editingDidEnd:
                    return #selector(($0 as? UIControl)?.onEditingDidEnd)
                case .editingDidEndOnExit:
                    return #selector(($0 as? UIControl)?.onEditingDidEndOnExit)

                case .allTouchEvents:
                    return #selector(($0 as? UIControl)?.onAllTouchEvents)
                case .allEditingEvents:
                    return #selector(($0 as? UIControl)?.onAllEditingEvents)
                case .applicationReserved:
                    return #selector(($0 as? UIControl)?.onApplicationReserved)
                case .systemReserved:
                    return #selector(($0 as? UIControl)?.onSystemReserved)
                case .allEvents:
                    return #selector(($0 as? UIControl)?.onAllEvents)

                default:
                    return #selector(($0 as? UIControl)?.onAllEvents)
                }
            }($0), for: event)
        }
    }

    // swiftlint:disable function_body_length cyclomatic_complexity
    private func appendEvent(_ event: UIControl.Event, _ handler: @escaping (UIView) -> Void) {
        self.onNotRendered {
            guard let view = $0 as? UIControl else {
                fatalError()
            }

            let control = view.controlMemory

            switch event {
            case .touchDown:
                let old = control.value.touchDown
                control.update {
                    $0.touchDown = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .touchDownRepeat:
                let old = control.value.touchDownRepeat
                control.update {
                    $0.touchDownRepeat = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .touchDragInside:
                let old = control.value.touchDragInside
                control.update {
                    $0.touchDragInside = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .touchDragOutside:
                let old = control.value.touchDragOutside
                control.update {
                    $0.touchDragOutside = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .touchDragEnter:
                let old = control.value.touchDragEnter
                control.update {
                    $0.touchDragEnter = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .touchDragExit:
                let old = control.value.touchDragExit
                control.update {
                    $0.touchDragExit = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .touchUpInside:
                let old = control.value.touchUpInside
                control.update {
                    $0.touchUpInside = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .touchUpOutside:
                let old = control.value.touchUpOutside
                control.update {
                    $0.touchUpOutside = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .touchCancel:
                let old = control.value.touchCancel
                control.update {
                    $0.touchCancel = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }

            case .valueChanged:
                let old = control.value.valueChanged
                control.update {
                    $0.valueChanged = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .primaryActionTriggered:
                let old = control.value.primaryActionTriggered
                control.update {
                    $0.primaryActionTriggered = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }

            case .editingDidBegin:
                let old = control.value.editingDidBegin
                control.update {
                    $0.editingDidBegin = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .editingChanged:
                let old = control.value.editingChanged
                control.update {
                    $0.editingChanged = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .editingDidEnd:
                let old = control.value.editingDidEnd
                control.update {
                    $0.editingDidEnd = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .editingDidEndOnExit:
                let old = control.value.editingDidEndOnExit
                control.update {
                    $0.editingDidEndOnExit = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }

            case .allTouchEvents:
                let old = control.value.allTouchEvents
                control.update {
                    $0.allTouchEvents = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .allEditingEvents:
                let old = control.value.allEditingEvents
                control.update {
                    $0.allEditingEvents = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .applicationReserved:
                let old = control.value.applicationReserved
                control.update {
                    $0.applicationReserved = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .systemReserved:
                let old = control.value.systemReserved
                control.update {
                    $0.systemReserved = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            case .allEvents:
                let old = control.value.allEvents
                control.update {
                    $0.allEvents = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }

            default:
                let old = control.value.allEvents
                control.update {
                    $0.allEvents = .init {
                        handler($0)
                        old?.commit(in: $0)
                    }
                }
            }
        }
    }
}
