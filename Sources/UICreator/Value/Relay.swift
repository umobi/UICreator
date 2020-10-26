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

                container.reference?.reactive.requestValueGetter(handler: { (requestedValue: Value) in
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
                container.reference?.reactive.requestValueSetter(newValue)
            }
        }
    }

    public var projectedValue: Relay<Value> { self }

    public func next(_ handler: @escaping (Value) -> Void) {
        switch self.storage {
        case .constant(let value):
            handler(value)
        case .weak(let container):
            container.reference?.reactive.valueDidChange(handler: handler)
        }
    }

    public func sync(_ handler: @escaping (Value) -> Void) {
        self.next(handler)

        if case .weak(let container) = self.storage {
            container.reference?.reactive.requestValueGetter(handler: handler)
        }
    }

    public func map<Other>(_ handler: @escaping (Value) -> Other) -> Relay<Other> {
        switch self.storage {
        case .constant(let value):
            return .constant(handler(value))
        case .weak:
            let value = UICreator.Value<Other>(wrappedValue: handler(self.wrappedValue))
            self.next {
                value.wrappedValue = handler($0)
            }

            return value.projectedValue
        }
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

public extension Relay {
    func withLatest<Other>(_ otherRelay: Relay<Other>) -> Relay<Other> {
        self.flatMap { _ in otherRelay }
    }

    func withLatest<Other, Result>(
        _ otherRelay: Relay<Other>,
        _ map: @escaping (Value, Other) -> Result) -> Relay<Result> {

        self.flatMap {
            let value = $0
            return otherRelay.map {
                map(value, $0)
            }
        }
    }
}

public extension Relay where Value: Equatable {
    func distinctSync(_ handler: @escaping (Value) -> Void) {
        var actual = self.wrappedValue
        handler(actual)

        self.sync {
            if $0 != actual {
                actual = $0
                handler($0)
            }
        }
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

public func == <Value>(_ left: Relay<Value>, _ right: Relay<Value>) -> Relay<Bool> where Value: Equatable {
    left.withLatest(right) {
        $0 == $1
    }
}

public func == <Value>(_ left: Relay<Value>, _ right: Value) -> Relay<Bool> where Value: Equatable {
    left.map {
        $0 == right
    }
}

public func != <Value>(_ left: Relay<Value>, _ right: Relay<Value>) -> Relay<Bool> where Value: Equatable {
    left.withLatest(right) {
        $0 == $1
    }
}

public func != <Value>(_ left: Relay<Value>, _ right: Value) -> Relay<Bool> where Value: Equatable {
    left.map {
        $0 != right
    }
}

public func < <Value>(_ left: Relay<Value>, _ right: Relay<Value>) -> Relay<Bool> where Value: Comparable {
    left.withLatest(right) {
        $0 < $1
    }
}

public func < <Value>(_ left: Relay<Value>, _ right: Value) -> Relay<Bool> where Value: Comparable {
    left.map {
        $0 < right
    }
}

public func <= <Value>(_ left: Relay<Value>, _ right: Relay<Value>) -> Relay<Bool> where Value: Comparable {
    left.withLatest(right) {
        $0 <= $1
    }
}

public func <= <Value>(_ left: Relay<Value>, _ right: Value) -> Relay<Bool> where Value: Comparable {
    left.map {
        $0 <= right
    }
}

public func >= <Value>(_ left: Relay<Value>, _ right: Relay<Value>) -> Relay<Bool> where Value: Comparable {
    left.withLatest(right) {
        $0 >= $1
    }
}

public func >= <Value>(_ left: Relay<Value>, _ right: Value) -> Relay<Bool> where Value: Comparable {
    left.map {
        $0 >= right
    }
}

public func > <Value>(_ left: Relay<Value>, _ right: Relay<Value>) -> Relay<Bool> where Value: Comparable {
    left.withLatest(right) {
        $0 > $1
    }
}

public func > <Value>(_ left: Relay<Value>, _ right: Value) -> Relay<Bool> where Value: Comparable {
    left.map {
        $0 > right
    }
}

public func + <Value>(_ left: Relay<Value>, _ right: Relay<Value>) -> Relay<Value> where Value: Numeric {
    left.withLatest(right) {
        $0 + $1
    }
}

public func + <Value>(_ left: Relay<Value>, _ right: Value) -> Relay<Value> where Value: Numeric {
    left.map {
        $0 + right
    }
}

public func - <Value>(_ left: Relay<Value>, _ right: Relay<Value>) -> Relay<Value> where Value: Numeric {
    left.withLatest(right) {
        $0 - $1
    }
}

public func - <Value>(_ left: Relay<Value>, _ right: Value) -> Relay<Value> where Value: Numeric {
    left.map {
        $0 - right
    }
}

public func * <Value>(_ left: Relay<Value>, _ right: Relay<Value>) -> Relay<Value> where Value: Numeric {
    left.withLatest(right) {
        $0 * $1
    }
}

public func * <Value>(_ left: Relay<Value>, _ right: Value) -> Relay<Value> where Value: Numeric {
    left.map {
        $0 * right
    }
}

public func / <Value>(_ left: Relay<Value>, _ right: Relay<Value>) -> Relay<Value> where Value: FloatingPoint {
    left.withLatest(right) {
        $0 / $1
    }
}

public func / <Value>(_ left: Relay<Value>, _ right: Value) -> Relay<Value> where Value: FloatingPoint {
    left.map {
        $0 / right
    }
}
