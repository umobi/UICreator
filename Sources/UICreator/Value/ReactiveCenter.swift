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

class ReactiveToken: CustomStringConvertible, Equatable {
    var description: String {
        "\(ObjectIdentifier(self))"
    }

    static func ==(_ left: ReactiveToken,_ right: ReactiveToken) -> Bool {
        ObjectIdentifier(left) == ObjectIdentifier(right)
    }
}

private let _reactive = ReactiveCenter()
final class ReactiveCenter: NotificationCenter {
    static var shared: ReactiveCenter {
        return _reactive
    }
}

extension ReactiveCenter {
    struct ReferenceCenter {
        fileprivate let reactiveCenter: ReactiveCenter
        fileprivate let reference: ReactiveItemReference

        fileprivate init(reference: ReactiveItemReference,_ center: ReactiveCenter) {
            self.reactiveCenter = center
            self.reference = reference
        }
    }

    fileprivate func referenceCenter(_ reference: ReactiveItemReference) -> ReferenceCenter {
        .init(reference: reference, self)
    }
}

extension ReactiveItemReference {
    var reactive: ReactiveCenter.ReferenceCenter {
        ReactiveCenter.shared.referenceCenter(self)
    }
}

private extension ReactiveCenter.ReferenceCenter {
    static let kNotificationNewValue = "kNotificationNewValue"
    static let kNotificationToken = "kNotificationToken"

    var valueChangedNotification: Notification.Name {
        .init(rawValue: "\(self.reference).valueChanged")
    }

    var valueGetterNotification: Notification.Name {
        .init("\(self.reference).getter.value")
    }

    var requestValueGetterNotification: Notification.Name {
        .init("\(self.reference).request.getter.value")
    }

    var valueSetterNotification: Notification.Name {
        .init("\(self.reference).setter.value")
    }

    var requestValueSetterNotification: Notification.Name {
        .init("\(self.reference).request.setter.value")
    }
}

extension ReactiveCenter.ReferenceCenter {

    func valueDidChange<Value>(_ newValue: Value) {
        self.reactiveCenter.post(
            name: self.valueChangedNotification,
            object: nil,
            userInfo: [
                Self.kNotificationNewValue: newValue
            ])
    }

    func valueDidChange<Value>(handler: @escaping (Value) -> Void) {
        self.reference.append(self.reactiveCenter.addObserver(
            forName: self.valueChangedNotification,
            object: nil,
            queue: nil,
            using: { notification in
                guard let value = notification.userInfo?[Self.kNotificationNewValue] as? Value else {
                    fatalError()
                }

                handler(value)
            }))
    }
}

extension ReactiveCenter.ReferenceCenter {
    func requestValueSetter<Value>(_ newValue: Value) {
        self.reactiveCenter.post(
            name: self.requestValueSetterNotification,
            object: nil,
            userInfo: [
                Self.kNotificationNewValue: newValue
            ])
    }

    func valueSetter<Value>(_ handler: @escaping (Value) -> Void) {
        self.reference.append(self.reactiveCenter.addObserver(
            forName: self.valueSetterNotification,
            object: nil,
            queue: nil,
            using: {
                guard let value = $0.userInfo?[Self.kNotificationNewValue] as? Value else {
                    fatalError()
                }

                handler(value)
            }))
    }
}

extension ReactiveCenter.ReferenceCenter {
    func valueGetter<Value>(handler: @escaping () -> Value) {
        self.reference.append(self.reactiveCenter.addObserver(
            forName: self.requestValueGetterNotification,
            object: nil,
            queue: nil,
            using: { [weak reactiveCenter, valueGetterNotification] in
                guard let token = $0.userInfo?[Self.kNotificationToken] as? ReactiveToken else {
                    return
                }

                reactiveCenter?.post(
                    name: valueGetterNotification,
                    object: nil,
                    userInfo: [
                        Self.kNotificationNewValue: handler(),
                        Self.kNotificationToken: token
                    ]
                )
            }))
    }

    func requestValueGetter<Value>(handler: @escaping (Value) -> Void) {
        let token = ReactiveToken()
        let observable: NSObjectProtocol = self.reactiveCenter.addObserver(
            forName: self.valueGetterNotification,
            object: nil,
            queue: nil,
            using: {
                guard
                    let notificationToken = $0.userInfo?[Self.kNotificationToken] as? ReactiveToken,
                    notificationToken == token
                    else {
                        return
                    }

                guard let value = $0.userInfo?[Self.kNotificationNewValue] as? Value else {
                    fatalError()
                }

                handler(value)
        })

        self.reactiveCenter.post(
            name: self.requestValueGetterNotification,
            object: nil,
            userInfo: [
                Self.kNotificationToken: token
            ])

        self.reactiveCenter.removeObserver(observable)
    }
}

extension Fatal {
    enum ReactiveCenter: FatalType {
        case unregistered

        var error: String {
            switch self {
                case .unregistered:
                    return "Identifier for Relay or Value isn't registered in ReactiveCenter"
            }
        }
    }
}
