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

@propertyWrapper
//@dynamicMemberLookup
public struct Relay<Value> {
    private var storage: Storage

    init(_ reference: ReactiveItemReference) {
        self.storage = .weak(.init(reference: reference))
    }

    fileprivate init(_ value: Value) {
        self.storage = .constant(value)
    }

    public var wrappedValue: Value {
        get {
            switch self.storage {
            case .constant(let value):
                return value
            case .weak(let container):
                let dispatchGroup = DispatchGroup()
                dispatchGroup.enter()

                var value: Value!

                container.reference.reactive.requestValueGetter(handler: { (requestedValue: Value) in
                    value = requestedValue
                    dispatchGroup.leave()
                })

                dispatchGroup.wait()
                return value
            }
        }
        nonmutating
        set {
            switch self.storage {
            case .constant:
                return
            case .weak(let container):
                container.reference.reactive.requestValueSetter(newValue)
            }
        }
    }

    public var projectedValue: Relay<Value> { self }

    public func next(_ handler: @escaping (Value) -> Void) {
        switch self.storage {
        case .constant(let value):
            handler(value)
        case .weak(let container):
            container.reference.reactive.valueDidChange(handler: handler)
        }
    }

    public func sync(_ handler: @escaping (Value) -> Void) {
        self.next(handler)

        if case .weak(let container) = self.storage {
            container.reference.reactive.requestValueGetter(handler: handler)
        }
    }

    public func map<Other>(_ handler: @escaping (Value) -> Other) -> Relay<Other> {
        let value = UICreator.Value<Other>(wrappedValue: handler(self.wrappedValue))
        self.next {
            value.wrappedValue = handler($0)
        }

        return value.projectedValue
    }
}

public extension Relay {
    static func constant(_ value: Value) -> Relay<Value> {
        .init(value)
    }
}

public extension Relay {
    private class FlatMapToken {}

    func flatMap<Other>(_ flatHandler: @escaping (Value) -> Relay<Other>) -> Relay<Other> {
        let value = UICreator.Value(wrappedValue: flatHandler(self.wrappedValue).wrappedValue)
        var token = FlatMapToken()

        self.sync {
            token = .init()
            weak var token = token

            flatHandler($0).sync {
                guard token != nil else {
                    return
                }

                value.wrappedValue = $0
            }
        }

        return value.projectedValue
    }
}

private extension Relay {
    struct WeakContainer {
        weak var reference: ReactiveItemReference!
    }

    enum Storage {
        case constant(Value)
        case weak(WeakContainer)
    }
}

//extension Relay where Value: OptionalType {
//    public subscript<T>(dynamicMember keyPath: KeyPath<Value.Wrapped, Optional<T>>) -> Relay<Optional<T>> {
//        return self.map {
//            $0.value?[keyPath: keyPath]
//        }
//    }
//}

public extension Relay {
    @available(*, deprecated, message: "no substitute")
    func connect(to relay: Relay<Value>) {
        relay.sync {
            self.wrappedValue = $0
        }
    }
}

public extension Relay {
    @available(*, deprecated, message: "no substitute")
    // swiftlint:disable line_length
    func bind<Object, ObjectValue>(_ keyPath: KeyPath<Object, ObjectValue>) -> Relay<ObjectValue?> where Value == Object? {
        return self.map {
            guard let object = $0 else {
                return nil
            }

            return object[keyPath: keyPath]
        }
    }

    @available(*, deprecated, message: "no substitute")
    func bind<ObjectValue>(_ keyPath: KeyPath<Value, ObjectValue>) -> Relay<ObjectValue?> {
        return self.map {
            $0[keyPath: keyPath]
        }
    }

    @available(*, deprecated, message: "no substitute")
    func bind<ObjectValue>(_ keyPath: KeyPath<Value, ObjectValue>) -> Relay<ObjectValue> {
        return self.map {
            $0[keyPath: keyPath]
        }
    }
}

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    /// Cast `Optional<Wrapped>` to `Wrapped?`
    public var value: Wrapped? {
        return self
    }
}

public extension Relay where Value: OptionalType {
    // Lazy bind
    func bind(to relay: Relay<Value>) {
        self.sync {
            relay.wrappedValue = $0
        }
    }
}

public extension Relay {
    // Lazy bind
    func bind(to relay: Relay<Value>) {
        self.sync {
            relay.wrappedValue = $0
        }
    }

    // Lazy bind
    func bind(to relay: Relay<Value?>) {
        self.sync {
            relay.wrappedValue = $0
        }
    }
}

/// Sync from left
infix operator <->
/// Sync from left
public func <-> <T>(left: Relay<T>, right: Relay<T>) {
    var isLocked = false

    left.sync {
        guard !isLocked else {
            return
        }

        isLocked = true
        right.wrappedValue = $0
        isLocked = false
    }

    right.next {
        guard !isLocked else {
            return
        }

        isLocked = true
        left.wrappedValue = $0
        isLocked = false
    }
}

/// Sync from left
public func <-> <T>(left: Relay<T>?, right: Relay<T>) {
    guard let left = left else {
        return
    }

    left <-> right
}

/// Sync from left
public func <-> <T>(left: Relay<T>?, right: Relay<T>?) {
    guard let left = left, let right = right else {
        return
    }

    left <-> right
}

/// Lazy operator
infix operator <~>

/// Lazy operator
public func <~> <T>(left: Relay<T>, right: Relay<T>) {
    var isLocked = false

    left.next {
        guard !isLocked else {
            return
        }

        isLocked = true
        right.wrappedValue = $0
        isLocked = false
    }

    right.next {
        guard !isLocked else {
            return
        }

        isLocked = true
        left.wrappedValue = $0
        isLocked = false
    }
}

/// Lazy operator
public func <~> <T>(left: Relay<T>?, right: Relay<T>) {
    guard let left = left else {
        return
    }

    left <~> right
}

/// Lazy operator
public func <~> <T>(left: Relay<T>?, right: Relay<T>?) {
    guard let left = left, let right = right else {
        return
    }

    left <~> right
}

public prefix func ! (_ relay: Relay<Bool>) -> Relay<Bool> {
    relay.map { !$0 }
}

public func && (_ left: Relay<Bool>, _ right: Relay<Bool>) -> Relay<Bool> {
    let value = Value(wrappedValue: left.wrappedValue && right.wrappedValue)

    left.next {
        value.wrappedValue = $0 && right.wrappedValue
    }

    right.next {
        value.wrappedValue = left.wrappedValue && $0
    }

    return value.projectedValue
}

public func || (_ left: Relay<Bool>, _ right: Relay<Bool>) -> Relay<Bool> {
    let value = Value(wrappedValue: left.wrappedValue || right.wrappedValue)

    left.next {
        value.wrappedValue = $0 || right.wrappedValue
    }

    right.next {
        value.wrappedValue = left.wrappedValue || $0
    }

    return value.projectedValue
}

public func || (_ left: Bool, _ right: Relay<Bool>) -> Relay<Bool> {
    let value = Value(wrappedValue: left || right.wrappedValue)

    right.next {
        value.wrappedValue = left || $0
    }

    return value.projectedValue
}

public func || (_ left: Relay<Bool>, _ right: Bool) -> Relay<Bool> {
    let value = Value(wrappedValue: left.wrappedValue || right)

    left.next {
        value.wrappedValue = $0 || right
    }

    return value.projectedValue
}

public func && (_ left: Bool, _ right: Relay<Bool>) -> Relay<Bool> {
    let value = Value(wrappedValue: left && right.wrappedValue)

    right.next {
        value.wrappedValue = left && $0
    }

    return value.projectedValue
}

public func && (_ left: Relay<Bool>, _ right: Bool) -> Relay<Bool> {
    let value = Value(wrappedValue: left.wrappedValue && right)

    left.next {
        value.wrappedValue = $0 && right
    }

    return value.projectedValue
}
