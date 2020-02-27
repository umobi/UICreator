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

private var kTouchDown: UInt = 0
private var kTouchDownRepeat: UInt = 0
private var kTouchDragInside: UInt = 0
private var kTouchDragOutside: UInt = 0
private var kTouchDragEnter: UInt = 0
private var kTouchDragExit: UInt = 0
private var kTouchUpInside: UInt = 0
private var kTouchUpOutside: UInt = 0
private var kTouchCancel: UInt = 0

private var kValueChanged: UInt = 0
private var kPrimaryActionTriggered: UInt = 0

private var kEditingDidBegin: UInt = 0
private var kEditingChanged: UInt = 0
private var kEditingDidEnd: UInt = 0
private var kEditingDidEndOnExit: UInt = 0

private var kAllTouchEvents: UInt = 0
private var kAllEditingEvents: UInt = 0
private var kApplicationReserved: UInt = 0
private var kSystemReserved: UInt = 0

private var kAllEvents: UInt = 0

fileprivate extension UIControl {

    var touchDown: Handler? {
        get { objc_getAssociatedObject(self, &kTouchDown) as? Handler }
        set { objc_setAssociatedObject(self, &kTouchDown, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var touchDownRepeat: Handler? {
        get { objc_getAssociatedObject(self, &kTouchDownRepeat) as? Handler }
        set { objc_setAssociatedObject(self, &kTouchDownRepeat, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var touchDragInside: Handler? {
        get { objc_getAssociatedObject(self, &kTouchDragInside) as? Handler }
        set { objc_setAssociatedObject(self, &kTouchDragInside, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var touchDragOutside: Handler? {
        get { objc_getAssociatedObject(self, &kTouchDragOutside) as? Handler }
        set { objc_setAssociatedObject(self, &kTouchDragOutside, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var touchDragEnter: Handler? {
        get { objc_getAssociatedObject(self, &kTouchDragEnter) as? Handler }
        set { objc_setAssociatedObject(self, &kTouchDragEnter, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var touchDragExit: Handler? {
        get { objc_getAssociatedObject(self, &kTouchDragExit) as? Handler }
        set { objc_setAssociatedObject(self, &kTouchDragExit, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var touchUpInside: Handler? {
        get { objc_getAssociatedObject(self, &kTouchUpInside) as? Handler }
        set { objc_setAssociatedObject(self, &kTouchUpInside, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var touchUpOutside: Handler? {
        get { objc_getAssociatedObject(self, &kTouchUpOutside) as? Handler }
        set { objc_setAssociatedObject(self, &kTouchUpOutside, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var touchCancel: Handler? {
        get { objc_getAssociatedObject(self, &kTouchCancel) as? Handler }
        set { objc_setAssociatedObject(self, &kTouchCancel, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var editingDidBegin: Handler? {
        get { objc_getAssociatedObject(self, &kTouchUpOutside) as? Handler }
        set { objc_setAssociatedObject(self, &kTouchUpOutside, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var valueChanged: Handler? {
        get { objc_getAssociatedObject(self, &kValueChanged) as? Handler }
        set { objc_setAssociatedObject(self, &kValueChanged, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var primaryActionTriggered: Handler? {
        get { objc_getAssociatedObject(self, &kPrimaryActionTriggered) as? Handler }
        set { objc_setAssociatedObject(self, &kPrimaryActionTriggered, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var editingChanged: Handler? {
        get { objc_getAssociatedObject(self, &kAllTouchEvents) as? Handler }
        set { objc_setAssociatedObject(self, &kAllTouchEvents, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var editingDidEnd: Handler? {
        get { objc_getAssociatedObject(self, &kAllEditingEvents) as? Handler }
        set { objc_setAssociatedObject(self, &kAllEditingEvents, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var editingDidEndOnExit: Handler? {
        get { objc_getAssociatedObject(self, &kApplicationReserved) as? Handler }
        set { objc_setAssociatedObject(self, &kApplicationReserved, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var allTouchEvents: Handler? {
        get { objc_getAssociatedObject(self, &kAllTouchEvents) as? Handler }
        set { objc_setAssociatedObject(self, &kAllTouchEvents, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var allEditingEvents: Handler? {
        get { objc_getAssociatedObject(self, &kAllEditingEvents) as? Handler }
        set { objc_setAssociatedObject(self, &kAllEditingEvents, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var applicationReserved: Handler? {
        get { objc_getAssociatedObject(self, &kApplicationReserved) as? Handler }
        set { objc_setAssociatedObject(self, &kApplicationReserved, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var systemReserved: Handler? {
        get { objc_getAssociatedObject(self, &kSystemReserved) as? Handler }
        set { objc_setAssociatedObject(self, &kSystemReserved, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var allEvents: Handler? {
        get { objc_getAssociatedObject(self, &kAllEvents) as? Handler }
        set { objc_setAssociatedObject(self, &kAllEvents, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

fileprivate extension UIControl {
    @objc func onTouchDown() {
        self.touchDown?.commit(in: self)
    }

    @objc func onTouchDownRepeat() {
        self.touchDownRepeat?.commit(in: self)
    }

    @objc func onTouchDragInside() {
        self.touchDragInside?.commit(in: self)
    }

    @objc func onTouchDragOutside() {
        self.touchDragOutside?.commit(in: self)
    }

    @objc func onTouchDragEnter() {
        self.touchDragEnter?.commit(in: self)
    }

    @objc func onTouchDragExit() {
        self.touchDragExit?.commit(in: self)
    }

    @objc func onTouchUpInside() {
        self.touchUpInside?.commit(in: self)
    }

    @objc func onTouchUpOutside() {
        self.touchUpOutside?.commit(in: self)
    }

    @objc func onTouchCancel() {
        self.touchCancel?.commit(in: self)
    }

    @objc func onValueChanged() {
        self.valueChanged?.commit(in: self)
    }

    @objc func onPrimaryActionTriggered() {
        self.primaryActionTriggered?.commit(in: self)
    }


    @objc func onEditingDidBegin() {
        self.editingDidBegin?.commit(in: self)
    }

    @objc func onEditingChanged() {
        self.editingChanged?.commit(in: self)
    }

    @objc func onEditingDidEnd() {
        self.editingDidEnd?.commit(in: self)
    }

    @objc func onEditingDidEndOnExit() {
        self.editingDidEndOnExit?.commit(in: self)
    }

    @objc func onAllTouchEvents() {
        self.allTouchEvents?.commit(in: self)
    }

    @objc func onAllEditingEvents() {
        self.allEditingEvents?.commit(in: self)
    }

    @objc func onApplicationReserved() {
        self.applicationReserved?.commit(in: self)
    }

    @objc func onSystemReserved() {
        self.systemReserved?.commit(in: self)
    }

    @objc func onAllEvents() {
        self.allEvents?.commit(in: self)
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
            ($0 as? UIControl)?.removeTarget($0, action: nil, for: event)

            switch event {
            case .touchDown:
                ($0 as? UIControl)?.touchDown = nil
            case .touchDownRepeat:
                ($0 as? UIControl)?.touchDownRepeat = nil
            case .touchDragInside:
                ($0 as? UIControl)?.touchDragInside = nil
            case .touchDragOutside:
                ($0 as? UIControl)?.touchDragOutside = nil
            case .touchDragEnter:
                ($0 as? UIControl)?.touchDragEnter = nil
            case .touchDragExit:
                ($0 as? UIControl)?.touchDragExit = nil
            case .touchUpInside:
                ($0 as? UIControl)?.touchUpInside = nil
            case .touchUpOutside:
                ($0 as? UIControl)?.touchUpOutside = nil
            case .touchCancel:
                ($0 as? UIControl)?.touchCancel = nil

            case .valueChanged:
                ($0 as? UIControl)?.valueChanged = nil
            case .primaryActionTriggered:
                ($0 as? UIControl)?.primaryActionTriggered = nil

            case .editingDidBegin:
                ($0 as? UIControl)?.editingDidBegin = nil
            case .editingChanged:
                ($0 as? UIControl)?.editingChanged = nil
            case .editingDidEnd:
                ($0 as? UIControl)?.editingDidEnd = nil
            case .editingDidEndOnExit:
                ($0 as? UIControl)?.editingDidEndOnExit = nil

            case .allTouchEvents:
                ($0 as? UIControl)?.allTouchEvents = nil
            case .allEditingEvents:
                ($0 as? UIControl)?.allEditingEvents = nil
            case .applicationReserved:
                ($0 as? UIControl)?.applicationReserved = nil
            case .systemReserved:
                ($0 as? UIControl)?.systemReserved = nil
            case .allEvents:
                ($0 as? UIControl)?.allEvents = nil

            default:
                ($0 as? UIControl)?.allEvents = nil
            }
        }
    }

    private func appendEvent(_ event: UIControl.Event, _ handler: @escaping (UIView) -> Void) {
        self.onNotRendered {
            switch event {
            case .touchDown:
                let old = ($0 as? UIControl)?.touchDown
                ($0 as? UIControl)?.touchDown = .init {
                    handler($0)
                    old?.commit(in: $0)
                }
            case .touchDownRepeat:
                let old = ($0 as? UIControl)?.touchDownRepeat
                ($0 as? UIControl)?.touchDownRepeat = .init {
                   handler($0)
                   old?.commit(in: $0)
               }
            case .touchDragInside:
                let old = ($0 as? UIControl)?.touchDragInside
                ($0 as? UIControl)?.touchDragInside = .init {
                   handler($0)
                   old?.commit(in: $0)
               }
            case .touchDragOutside:
                let old = ($0 as? UIControl)?.touchDragOutside
                ($0 as? UIControl)?.touchDragOutside = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            case .touchDragEnter:
                let old = ($0 as? UIControl)?.touchDragEnter
                ($0 as? UIControl)?.touchDragEnter = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            case .touchDragExit:
                let old = ($0 as? UIControl)?.touchDragExit
                ($0 as? UIControl)?.touchDragExit = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            case .touchUpInside:
                let old = ($0 as? UIControl)?.touchUpInside
                ($0 as? UIControl)?.touchUpInside = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            case .touchUpOutside:
                let old = ($0 as? UIControl)?.touchUpOutside
                ($0 as? UIControl)?.touchUpOutside = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            case .touchCancel:
                let old = ($0 as? UIControl)?.touchCancel
                ($0 as? UIControl)?.touchCancel = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }

            case .valueChanged:
                let old = ($0 as? UIControl)?.valueChanged
                ($0 as? UIControl)?.valueChanged = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            case .primaryActionTriggered:
                let old = ($0 as? UIControl)?.primaryActionTriggered
                ($0 as? UIControl)?.primaryActionTriggered = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }

            case .editingDidBegin:
                let old = ($0 as? UIControl)?.editingDidBegin
                ($0 as? UIControl)?.editingDidBegin = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            case .editingChanged:
                let old = ($0 as? UIControl)?.editingChanged
                ($0 as? UIControl)?.editingChanged = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            case .editingDidEnd:
                let old = ($0 as? UIControl)?.editingDidEnd
                ($0 as? UIControl)?.editingDidEnd = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            case .editingDidEndOnExit:
                let old = ($0 as? UIControl)?.editingDidEndOnExit
                ($0 as? UIControl)?.editingDidEndOnExit = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }

            case .allTouchEvents:
                let old = ($0 as? UIControl)?.allTouchEvents
                ($0 as? UIControl)?.allTouchEvents = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            case .allEditingEvents:
                let old = ($0 as? UIControl)?.allEditingEvents
                ($0 as? UIControl)?.allEditingEvents = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            case .applicationReserved:
                let old = ($0 as? UIControl)?.applicationReserved
                ($0 as? UIControl)?.applicationReserved = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            case .systemReserved:
                let old = ($0 as? UIControl)?.systemReserved
                ($0 as? UIControl)?.systemReserved = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            case .allEvents:
                let old = ($0 as? UIControl)?.allEvents
                ($0 as? UIControl)?.allEvents = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }

            default:
                let old = ($0 as? UIControl)?.allEvents
                ($0 as? UIControl)?.allEvents = .init {
                      handler($0)
                      old?.commit(in: $0)
                  }
            }
        }
    }
}
