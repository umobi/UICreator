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

private let _reactive = ReactiveCenter()
final class ReactiveCenter: NotificationCenter {
    static var shared: ReactiveCenter {
        return _reactive
    }

    private var activeIdentifiers: Set<String> = []
    private var activeObservables: [(String, NSObjectProtocol)] = []

    func start(_ identifier: String) {
        self.unregister(identifier)

        self.activeIdentifiers.insert(identifier)
    }

    func unregister(_ identifier: String) {
        self.activeObservables = self.activeObservables.filter {
            $0.0 == identifier ? {
                ReactiveCenter.shared.removeObserver($0)
                return false
            }($0.1) : true
        }

        self.activeIdentifiers = self.activeIdentifiers.filter {
            $0 != identifier
        }
    }

    private func isRegisteredOrDie(_ identifier: String) {
        guard self.activeIdentifiers.contains(identifier) else {
            Fatal.ReactiveCenter.unregistered.die()
            return
        }
    }

    private func track(_ identifier: String,_ observable: NSObjectProtocol) {
        self.activeObservables.append((identifier, observable))
    }

    private static let kNotificationNewValue = "kNotificationNewValue"
    func valueDidChange<Value>(_ identifier: String, newValue: Value) {
        self.isRegisteredOrDie(identifier)
        self.post(name: .init(rawValue: "\(identifier).valueChanged"), object: nil, userInfo: [Self.kNotificationNewValue: newValue])
    }

    func valueDidChange<Value>(_ identifier: String, handler: @escaping (Value) -> Void) {
        self.isRegisteredOrDie(identifier)

        self.track(identifier, self.addObserver(forName: .init(rawValue: "\(identifier).valueChanged"), object: nil, queue: nil) { notification in
            handler(transform(notification.userInfo?[Self.kNotificationNewValue]))
        })
    }

    func privateValueDidChange<Value>(_ identifier: String, newValue: Value) {
        self.isRegisteredOrDie(identifier)

        self.post(name: .init(rawValue: "\(identifier).private.valueChanged"), object: nil, userInfo: [Self.kNotificationNewValue: newValue])
    }

    func privateValueDidChange<Value>(_ identifier: String, handler: @escaping (Value) -> Void) {
        self.isRegisteredOrDie(identifier)

        self.track(identifier, self.addObserver(forName: .init(rawValue: "\(identifier).private.valueChanged"), object: nil, queue: nil) { notification in
            handler(transform(notification.userInfo?[Self.kNotificationNewValue]))
        })
    }

    func privateDeinit(_ identifier: String) {
        self.isRegisteredOrDie(identifier)

        self.post(name: .init(rawValue: "\(identifier).private.deinit"), object: nil)
    }

    func privateDeinit(_ identifier: String, handler: @escaping () -> Void) {
        self.isRegisteredOrDie(identifier)

        self.track(identifier, self.addObserver(forName: .init(rawValue: "\(identifier).private.deinit"), object: nil, queue: nil) { _ in
            handler()
        })
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
