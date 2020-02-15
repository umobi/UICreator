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

class Destructor {
    var identifiers: [String] = []

    weak static var shared: Destructor!

    static func remove(_ id: String) {
        if let shared = Self.shared {
            shared.append(id)
            return
        }

        let destructor = Destructor()
        Self.shared = destructor
        destructor.append(id)
    }

    private var queue: DispatchQueue? = nil
    func run() {
        guard queue == nil else {
            return
        }

        self.queue = DispatchQueue.main
        self.queue?.async {
            while let id = self.identifiers.first {
                self.identifiers.removeFirst()

                ReactiveCenter.shared.privateDeinit(id)
                ReactiveCenter.shared.unregister(id)
            }

            self.queue = nil
            Self.shared = nil
        }
    }

    func append(_ id: String) {
        self.identifiers.append(id)
        self.run()
    }

    deinit {
        if !self.identifiers.isEmpty {
            fatalError()
        }
    }
}

private let _reactive = ReactiveCenter()
final class ReactiveCenter: NotificationCenter {
    static var shared: ReactiveCenter {
        return _reactive
    }

    private var activeObservables: [String: [NSObjectProtocol]] = [:]

    func start(_ identifier: String) {
        self.unregister(identifier)

        self.activeObservables[identifier] = []
    }

    func unregister(_ identifier: String) {
        self.activeObservables[identifier]?.forEach {
            ReactiveCenter.shared.removeObserver($0)
        }

        self.activeObservables[identifier] = nil
    }

    private func isRegisteredOrDie(_ identifier: String) {
        guard self.activeObservables[identifier] != nil else {
            Fatal.ReactiveCenter.unregistered.die()
            return
        }
    }

    private func track(_ identifier: String,_ observable: NSObjectProtocol) {
        self.activeObservables[identifier]?.append(observable)
    }

    private static let kNotificationNewValue = "kNotificationNewValue"
    func valueDidChange<Value>(_ identifier: String, newValue: Value) {
        self.isRegisteredOrDie(identifier)
        self.post(name: .init(rawValue: "\(identifier).valueChanged"), object: nil, userInfo: [Self.kNotificationNewValue: newValue])
    }

    func valueDidChange<Value>(_ identifier: String, handler: @escaping (Value) -> Void) {
        self.isRegisteredOrDie(identifier)

        self.track(identifier, self.addObserver(forName: .init(rawValue: "\(identifier).valueChanged"), object: nil, queue: nil) { notification in
            handler(notification.userInfo?[Self.kNotificationNewValue] as! Value)
        })
    }

    func privateValueDidChange<Value>(_ identifier: String, newValue: Value) {
        self.isRegisteredOrDie(identifier)

        self.post(name: .init(rawValue: "\(identifier).private.valueChanged"), object: nil, userInfo: [Self.kNotificationNewValue: newValue])
    }

    func privateValueDidChange<Value>(_ identifier: String, handler: @escaping (Value) -> Void) {
        self.isRegisteredOrDie(identifier)

        self.track(identifier, self.addObserver(forName: .init(rawValue: "\(identifier).private.valueChanged"), object: nil, queue: nil) { notification in
            handler(notification.userInfo?[Self.kNotificationNewValue] as! Value)
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

    func privateLatestValue<Value>(_ identifier: String, newValue: Value) {
        self.isRegisteredOrDie(identifier)

        self.post(name: .init(rawValue: "\(identifier).private.latestValue"), object: nil, userInfo: [Self.kNotificationNewValue: newValue])
    }

    func privateLatestValue<Value>(_ identifier: String, handler: @escaping (Value) -> Void) {
        self.isRegisteredOrDie(identifier)

        self.track(identifier, self.addObserver(forName: .init(rawValue: "\(identifier).private.latestValue"), object: nil, queue: nil) { notification in
            handler(notification.userInfo?[Self.kNotificationNewValue] as! Value)
        })
    }

    func privateResquestLatestValue(_ identifier: String) {
        self.isRegisteredOrDie(identifier)

        self.post(name: .init(rawValue: "\(identifier).private.request.latestValue"), object: nil)
    }

    func privateResquestLatestValue(_ identifier: String, handler: @escaping () -> Void) {
        self.isRegisteredOrDie(identifier)

        self.track(identifier, self.addObserver(forName: .init(rawValue: "\(identifier).private.request.latestValue"), object: nil, queue: nil) { _ in
            handler()
        })
    }

    func remove(_ id: String) {
        Destructor.remove(id)
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
