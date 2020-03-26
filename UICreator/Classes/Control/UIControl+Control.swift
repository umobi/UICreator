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

class Mutable<Value> {
    var value: Value
    init(value: Value) {
        self.value = value
    }
}

protocol MutableEditable {
    associatedtype Editable
    func edit(_ edit: @escaping (Editable) -> Void) -> Self
}

extension Mutable where Value: MutableEditable {
    func update(_ update: @escaping (Value.Editable) -> Void) {
        self.value = value.edit(update)
    }
}

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

private var kControlMutable: UInt = 0
fileprivate extension UIControl {
    var controlWrapper: Mutable<ControlPayload> {
        OBJCSet(self, &kControlMutable) {
            .init(value: .init())
        }
    }
}

fileprivate extension UIControl {
    @objc func onTouchDown() {
        self.controlWrapper.value.touchDown?.commit(in: self)
    }

    @objc func onTouchDownRepeat() {
        self.controlWrapper.value.touchDownRepeat?.commit(in: self)
    }

    @objc func onTouchDragInside() {
        self.controlWrapper.value.touchDragInside?.commit(in: self)
    }

    @objc func onTouchDragOutside() {
        self.controlWrapper.value.touchDragOutside?.commit(in: self)
    }

    @objc func onTouchDragEnter() {
        self.controlWrapper.value.touchDragEnter?.commit(in: self)
    }

    @objc func onTouchDragExit() {
        self.controlWrapper.value.touchDragExit?.commit(in: self)
    }

    @objc func onTouchUpInside() {
        self.controlWrapper.value.touchUpInside?.commit(in: self)
    }

    @objc func onTouchUpOutside() {
        self.controlWrapper.value.touchUpOutside?.commit(in: self)
    }

    @objc func onTouchCancel() {
        self.controlWrapper.value.touchCancel?.commit(in: self)
    }

    @objc func onValueChanged() {
        self.controlWrapper.value.valueChanged?.commit(in: self)
    }

    @objc func onPrimaryActionTriggered() {
        self.controlWrapper.value.primaryActionTriggered?.commit(in: self)
    }


    @objc func onEditingDidBegin() {
        self.controlWrapper.value.editingDidBegin?.commit(in: self)
    }

    @objc func onEditingChanged() {
        self.controlWrapper.value.editingChanged?.commit(in: self)
    }

    @objc func onEditingDidEnd() {
        self.controlWrapper.value.editingDidEnd?.commit(in: self)
    }

    @objc func onEditingDidEndOnExit() {
        self.controlWrapper.value.editingDidEndOnExit?.commit(in: self)
    }

    @objc func onAllTouchEvents() {
        self.controlWrapper.value.allTouchEvents?.commit(in: self)
    }

    @objc func onAllEditingEvents() {
        self.controlWrapper.value.allEditingEvents?.commit(in: self)
    }

    @objc func onApplicationReserved() {
        self.controlWrapper.value.applicationReserved?.commit(in: self)
    }

    @objc func onSystemReserved() {
        self.controlWrapper.value.systemReserved?.commit(in: self)
    }

    @objc func onAllEvents() {
        self.controlWrapper.value.allEvents?.commit(in: self)
    }
}

extension Control {
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

    public func removeEvent(_ event: UIControl.Event) {
        self.onRendered {
            guard let view = $0 as? UIControl else {
                fatalError()
            }

            view.removeTarget($0, action: nil, for: event)
            let control = view.controlWrapper

            switch event {
            case .touchDown:
                control.update {
                    $0.touchDown = nil
                }
            case .touchDownRepeat:
                control.update {
                    $0.touchDownRepeat = nil
                }
            case .touchDragInside:
                control.update {
                    $0.touchDragInside = nil
                }
            case .touchDragOutside:
                control.update {
                    $0.touchDragOutside = nil
                }
            case .touchDragEnter:
                control.update {
                    $0.touchDragEnter = nil
                }
            case .touchDragExit:
                control.update {
                    $0.touchDragExit = nil
                }
            case .touchUpInside:
                control.update {
                    $0.touchUpInside = nil
                }
            case .touchUpOutside:
                control.update {
                    $0.touchUpOutside = nil
                }
            case .touchCancel:
                control.update {
                    $0.touchCancel = nil
                }

            case .valueChanged:
                control.update {
                    $0.valueChanged = nil
                }
            case .primaryActionTriggered:
                control.update {
                    $0.primaryActionTriggered = nil
                }

            case .editingDidBegin:
                control.update {
                    $0.editingDidBegin = nil
                }
            case .editingChanged:
                control.update {
                    $0.editingChanged = nil
                }
            case .editingDidEnd:
                control.update {
                    $0.editingDidEnd = nil
                }
            case .editingDidEndOnExit:
                control.update {
                    $0.editingDidEndOnExit = nil
                }

            case .allTouchEvents:
                control.update {
                    $0.allTouchEvents = nil
                }
            case .allEditingEvents:
                control.update {
                    $0.allEditingEvents = nil
                }
            case .applicationReserved:
                control.update {
                    $0.applicationReserved = nil
                }
            case .systemReserved:
                control.update {
                    $0.systemReserved = nil
                }
            case .allEvents:
                control.update {
                    $0.allEvents = nil
                }

            default:
                control.update {
                    $0.allEvents = nil
                }
            }
        }
    }

    private func appendEvent(_ event: UIControl.Event, _ handler: @escaping (UIView) -> Void) {
        self.onNotRendered {
            guard let view = $0 as? UIControl else {
                fatalError()
            }

            let control = view.controlWrapper

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
