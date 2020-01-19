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

struct Fatal {
    static func die(_ string: String) {
        fatalError(string)
    }

    enum ReactiveCenter {
        case unregistered

        func error() {
            Fatal.die({
                switch self {
                case .unregistered:
                    return "Identifier for Relay or Value isn't registered in ReactiveCenter"
                }
                }())
        }
    }
}

private let _reactive = ReactiveCenter()
class ReactiveCenter: NotificationCenter {
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
            Fatal.ReactiveCenter.unregistered.error()
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

public class Relay<Value> {
    let identifier: String
    init(identifier: String) {
        self.identifier = identifier
        self.handler = nil
        print("[Relay] init")
    }

    deinit {
        print("[Relay] deinit")
    }

    public func next(_ handler: @escaping (Value) -> Void) {
        Self.collapse(self)() { value in
            handler(value)
        }
    }

    private static func collapse<Value>(_ relay: Relay<Value>) -> ((@escaping (Value) -> Void) -> Void) {
        let identifier = relay.identifier
        let handler = relay.handler

        return  { externalHandler in
            if let selfHandler = handler {
                selfHandler() {
                    externalHandler($0)
                }

                return
            }

            ReactiveCenter.shared.valueDidChange(identifier) {
                externalHandler($0)
            }

            ReactiveCenter.shared.privateValueDidChange(identifier) {
                externalHandler($0)
            }
        }
    }

    let handler: ((@escaping  (Value) -> Void) -> Void)?
    init(_ identifier: String, handler: @escaping ((@escaping (Value) -> Void) -> Void)) {
        self.identifier = identifier
        self.handler = handler
        print("[Relay] init")
    }

    public func map<Other>(_ handler: @escaping  (Value) -> Other) -> Relay<Other> {
        let callbase = Self.collapse(self)
        return Relay<Other>.init(self.identifier, handler: { function in
            return callbase() {
                function(handler($0))
            }
        })
    }

    func `post`(_ value: Value) {
        ReactiveCenter.shared.privateValueDidChange(self.identifier, newValue: value)
    }
}

public extension Value {
    var asRelay: Relay<Value> {
        return .init(identifier: self.identifier)
    }
}

public protocol _Getter: class {
    associatedtype Value

    var value: Value { get }
}

public protocol _Setter: _Getter {
    var value: Value { get set }
    init(value: Value)
}

private var kGetterValue: UInt = 0

public extension _Getter {
    fileprivate var identifier: String {
        return "\(ObjectIdentifier(self))"
    }

    var value: Value {
        transform(objc_getAssociatedObject(self, &kGetterValue))
    }
    
    func next(_ handler: @escaping (Value) -> Void) {
        ReactiveCenter.shared.valueDidChange(self.identifier, handler: handler)
    }

    func sync(_ syncHandler: @escaping (Value) -> Void) {
        self.next {
            syncHandler($0)
        }

        syncHandler(self.value)
    }
}

private func transform<Value>(_ any: Any?) -> Value {
    var a: Value! {
        return any as? Value
    }

    return a
}

public extension _Setter {
    var value: Value {
        get { transform(objc_getAssociatedObject(self, &kGetterValue)) }
        set {
            objc_setAssociatedObject(self, &kGetterValue, newValue, .OBJC_ASSOCIATION_RETAIN)
            ReactiveCenter.shared.valueDidChange(self.identifier, newValue: newValue)
        }
    }
}

public class Value<Value>: _Getter, _Setter {
    required public init(value: Value) {
        ReactiveCenter.shared.start(self.identifier)
        self.value = value
    }

    deinit {
        ReactiveCenter.shared.privateDeinit(self.identifier)
        ReactiveCenter.shared.unregister(self.identifier)
    }
}
