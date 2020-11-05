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

private class ReactiveToken: CustomStringConvertible, Equatable {
    var description: String {
        "\(ObjectIdentifier(self))"
    }

    static func == (_ left: ReactiveToken, _ right: ReactiveToken) -> Bool {
        ObjectIdentifier(left) == ObjectIdentifier(right)
    }
}

final class ReactiveCenter: NotificationCenter {
    static let shared = ReactiveCenter()
}

struct ReactiveReferenceCenter<Value> {
    fileprivate let reference: StateSource<Value>

    fileprivate init(_ reference: StateSource<Value>) {
        self.reference = reference
    }
}

extension StateSource {
    var reactive: ReactiveReferenceCenter<Value> {
        .init(self)
    }
}

private let kNotificationNewValue = "kNotificationNewValue"
private let kNotificationToken = "kNotificationToken"

private extension ReactiveReferenceCenter {
    var valueChangedNotification: Notification.Name {
        .init(rawValue: "\(self.reference.id).valueChanged")
    }

    var valueGetterNotification: Notification.Name {
        .init("\(self.reference.id).getter.value")
    }

    var requestValueGetterNotification: Notification.Name {
        .init("\(self.reference.id).request.getter.value")
    }

    var valueSetterNotification: Notification.Name {
        .init("\(self.reference.id).request.setter.value")
    }
}

extension ReactiveReferenceCenter {

    func valueDidChange(_ newValue: Value) {
        ReactiveCenter.shared.post(
            name: self.valueChangedNotification,
            object: nil,
            userInfo: [
                kNotificationNewValue: newValue
            ])
    }

    func valueDidChange(handler: @escaping (Value) -> Void) {
        self.reference.append(ReactiveCenter.shared.addObserver(
            forName: self.valueChangedNotification,
            object: nil,
            queue: nil,
            using: { notification in
                guard let value = notification.userInfo?[kNotificationNewValue] as? Value else {
                    Fatal.Builder("ReactiveCenter couldn't cast value to type of \(Value.self)").die()
                }

                handler(value)
            }))
    }
}

extension ReactiveReferenceCenter {
    func requestValueSetter(_ newValue: Value) {
        ReactiveCenter.shared.post(
            name: self.valueSetterNotification,
            object: nil,
            userInfo: [
                kNotificationNewValue: newValue
            ])
    }

    func valueSetter(_ handler: @escaping (Value) -> Void) {
        self.reference.append(ReactiveCenter.shared.addObserver(
            forName: self.valueSetterNotification,
            object: nil,
            queue: nil,
            using: {
                guard let value = $0.userInfo?[kNotificationNewValue] as? Value else {
                    Fatal.Builder("ReactiveCenter couldn't cast value to type of \(Value.self)").die()
                }

                handler(value)
            }))
    }
}

extension ReactiveReferenceCenter {
    func valueGetter<Value>(handler: @escaping () -> Value) {
        self.reference.append(ReactiveCenter.shared.addObserver(
            forName: self.requestValueGetterNotification,
            object: nil,
            queue: nil,
            using: { [valueGetterNotification] in
                guard let token = $0.userInfo?[kNotificationToken] as? ReactiveToken else {
                    return
                }

                ReactiveCenter.shared.post(
                    name: valueGetterNotification,
                    object: nil,
                    userInfo: [
                        kNotificationNewValue: handler(),
                        kNotificationToken: token
                    ]
                )
            }))
    }

    func requestValueGetter(handler: @escaping (Value) -> Void) {
        let token = ReactiveToken()
        let observable: NSObjectProtocol = ReactiveCenter.shared.addObserver(
            forName: self.valueGetterNotification,
            object: nil,
            queue: nil,
            using: {
                guard
                    let notificationToken = $0.userInfo?[kNotificationToken] as? ReactiveToken,
                    notificationToken == token
                    else {
                        return
                    }

                let valueOfUserInfo = $0.userInfo?[kNotificationNewValue]
                guard let value = valueOfUserInfo as? Value else {
                    Fatal.Builder("ReactiveCenter couldn't cast \(valueOfUserInfo ?? "nil") to type of \(Value.self)").die()
                }

                handler(value)
        })

        ReactiveCenter.shared.post(
            name: self.requestValueGetterNotification,
            object: nil,
            userInfo: [
                kNotificationToken: token
            ])

        ReactiveCenter.shared.removeObserver(observable)
    }
}
