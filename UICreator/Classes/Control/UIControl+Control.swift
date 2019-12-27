//
//  UIControl+Control.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
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

        (self.uiView as? UIControl)?.addTarget(self.uiView, action: {
            switch event {
            case .touchDown:
                return #selector((self.uiView as? UIControl)?.onTouchDown)
            case .touchDownRepeat:
                return #selector((self.uiView as? UIControl)?.onTouchDownRepeat)
            case .touchDragInside:
                return #selector((self.uiView as? UIControl)?.onTouchDragInside)
            case .touchDragOutside:
                return #selector((self.uiView as? UIControl)?.onTouchDragOutside)
            case .touchDragEnter:
                return #selector((self.uiView as? UIControl)?.onTouchDragEnter)
            case .touchDragExit:
                return #selector((self.uiView as? UIControl)?.onTouchDragExit)
            case .touchUpInside:
                return #selector((self.uiView as? UIControl)?.onTouchUpInside)
            case .touchUpOutside:
                return #selector((self.uiView as? UIControl)?.onTouchUpOutside)
            case .touchCancel:
                return #selector((self.uiView as? UIControl)?.onTouchCancel)

            case .valueChanged:
                return #selector((self.uiView as? UIControl)?.onValueChanged)
            case .primaryActionTriggered:
                return #selector((self.uiView as? UIControl)?.onPrimaryActionTriggered)

            case .editingDidBegin:
                return #selector((self.uiView as? UIControl)?.onEditingDidBegin)
            case .editingChanged:
                return #selector((self.uiView as? UIControl)?.onEditingChanged)
            case .editingDidEnd:
                return #selector((self.uiView as? UIControl)?.onEditingDidEnd)
            case .editingDidEndOnExit:
                return #selector((self.uiView as? UIControl)?.onEditingDidEndOnExit)

            case .allTouchEvents:
                return #selector((self.uiView as? UIControl)?.onAllTouchEvents)
            case .allEditingEvents:
                return #selector((self.uiView as? UIControl)?.onAllEditingEvents)
            case .applicationReserved:
                return #selector((self.uiView as? UIControl)?.onApplicationReserved)
            case .systemReserved:
                return #selector((self.uiView as? UIControl)?.onSystemReserved)
            case .allEvents:
                return #selector((self.uiView as? UIControl)?.onAllEvents)

            default:
                return #selector((self.uiView as? UIControl)?.onAllEvents)
            }
        }(), for: event)

        return self
    }

    public func removeEvent(_ event: UIControl.Event) {
        (self.uiView as? UIControl)?.removeTarget(self.uiView, action: nil, for: event)

        switch event {
        case .touchDown:
            (self.uiView as? UIControl)?.touchDown = nil
        case .touchDownRepeat:
            (self.uiView as? UIControl)?.touchDownRepeat = nil
        case .touchDragInside:
            (self.uiView as? UIControl)?.touchDragInside = nil
        case .touchDragOutside:
            (self.uiView as? UIControl)?.touchDragOutside = nil
        case .touchDragEnter:
            (self.uiView as? UIControl)?.touchDragEnter = nil
        case .touchDragExit:
            (self.uiView as? UIControl)?.touchDragExit = nil
        case .touchUpInside:
            (self.uiView as? UIControl)?.touchUpInside = nil
        case .touchUpOutside:
            (self.uiView as? UIControl)?.touchUpOutside = nil
        case .touchCancel:
            (self.uiView as? UIControl)?.touchCancel = nil

        case .valueChanged:
            (self.uiView as? UIControl)?.valueChanged = nil
        case .primaryActionTriggered:
            (self.uiView as? UIControl)?.primaryActionTriggered = nil

        case .editingDidBegin:
            (self.uiView as? UIControl)?.editingDidBegin = nil
        case .editingChanged:
            (self.uiView as? UIControl)?.editingChanged = nil
        case .editingDidEnd:
            (self.uiView as? UIControl)?.editingDidEnd = nil
        case .editingDidEndOnExit:
            (self.uiView as? UIControl)?.editingDidEndOnExit = nil

        case .allTouchEvents:
            (self.uiView as? UIControl)?.allTouchEvents = nil
        case .allEditingEvents:
            (self.uiView as? UIControl)?.allEditingEvents = nil
        case .applicationReserved:
            (self.uiView as? UIControl)?.applicationReserved = nil
        case .systemReserved:
            (self.uiView as? UIControl)?.systemReserved = nil
        case .allEvents:
            (self.uiView as? UIControl)?.allEvents = nil

        default:
            (self.uiView as? UIControl)?.allEvents = nil
        }
    }

    private func appendEvent(_ event: UIControl.Event, _ handler: @escaping (UIView) -> Void) {
        switch event {
        case .touchDown:
            let old = (self.uiView as? UIControl)?.touchDown
            (self.uiView as? UIControl)?.touchDown = .init {
                handler($0)
                old?.commit(in: $0)
            }
        case .touchDownRepeat:
            let old = (self.uiView as? UIControl)?.touchDownRepeat
            (self.uiView as? UIControl)?.touchDownRepeat = .init {
               handler($0)
               old?.commit(in: $0)
           }
        case .touchDragInside:
            let old = (self.uiView as? UIControl)?.touchDragInside
            (self.uiView as? UIControl)?.touchDragInside = .init {
               handler($0)
               old?.commit(in: $0)
           }
        case .touchDragOutside:
            let old = (self.uiView as? UIControl)?.touchDragOutside
            (self.uiView as? UIControl)?.touchDragOutside = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        case .touchDragEnter:
            let old = (self.uiView as? UIControl)?.touchDragEnter
            (self.uiView as? UIControl)?.touchDragEnter = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        case .touchDragExit:
            let old = (self.uiView as? UIControl)?.touchDragExit
            (self.uiView as? UIControl)?.touchDragExit = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        case .touchUpInside:
            let old = (self.uiView as? UIControl)?.touchUpInside
            (self.uiView as? UIControl)?.touchUpInside = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        case .touchUpOutside:
            let old = (self.uiView as? UIControl)?.touchUpOutside
            (self.uiView as? UIControl)?.touchUpOutside = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        case .touchCancel:
            let old = (self.uiView as? UIControl)?.touchCancel
            (self.uiView as? UIControl)?.touchCancel = .init {
                  handler($0)
                  old?.commit(in: $0)
              }

        case .valueChanged:
            let old = (self.uiView as? UIControl)?.valueChanged
            (self.uiView as? UIControl)?.valueChanged = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        case .primaryActionTriggered:
            let old = (self.uiView as? UIControl)?.primaryActionTriggered
            (self.uiView as? UIControl)?.primaryActionTriggered = .init {
                  handler($0)
                  old?.commit(in: $0)
              }

        case .editingDidBegin:
            let old = (self.uiView as? UIControl)?.editingDidBegin
            (self.uiView as? UIControl)?.editingDidBegin = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        case .editingChanged:
            let old = (self.uiView as? UIControl)?.editingChanged
            (self.uiView as? UIControl)?.editingChanged = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        case .editingDidEnd:
            let old = (self.uiView as? UIControl)?.editingDidEnd
            (self.uiView as? UIControl)?.editingDidEnd = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        case .editingDidEndOnExit:
            let old = (self.uiView as? UIControl)?.editingDidEndOnExit
            (self.uiView as? UIControl)?.editingDidEndOnExit = .init {
                  handler($0)
                  old?.commit(in: $0)
              }

        case .allTouchEvents:
            let old = (self.uiView as? UIControl)?.allTouchEvents
            (self.uiView as? UIControl)?.allTouchEvents = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        case .allEditingEvents:
            let old = (self.uiView as? UIControl)?.allEditingEvents
            (self.uiView as? UIControl)?.allEditingEvents = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        case .applicationReserved:
            let old = (self.uiView as? UIControl)?.applicationReserved
            (self.uiView as? UIControl)?.applicationReserved = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        case .systemReserved:
            let old = (self.uiView as? UIControl)?.systemReserved
            (self.uiView as? UIControl)?.systemReserved = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        case .allEvents:
            let old = (self.uiView as? UIControl)?.allEvents
            (self.uiView as? UIControl)?.allEvents = .init {
                  handler($0)
                  old?.commit(in: $0)
              }

        default:
            let old = (self.uiView as? UIControl)?.allEvents
            (self.uiView as? UIControl)?.allEvents = .init {
                  handler($0)
                  old?.commit(in: $0)
              }
        }
    }
}
