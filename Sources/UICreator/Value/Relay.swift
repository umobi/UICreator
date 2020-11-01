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
@frozen
public struct Relay<Value> {
    private var storage: Storage

    @usableFromInline
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

    @inline(__always)
    public var projectedValue: Relay<Value> { self }

    public func next(_ handler: @escaping (Value) -> Void) {
        switch self.storage {
        case .constant:
            break
        case .weak(let container):
            container.reference?.reactive.valueDidChange(handler: handler)
        }
    }

    public func sync(_ handler: @escaping (Value) -> Void) {
        self.next(handler)
        
        handler(self.wrappedValue)
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
    @usableFromInline
    internal class FlatMapToken {

        @usableFromInline
        init() {}
    }

    @inlinable
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
    @inlinable
    func withLatest<Other>(_ otherRelay: Relay<Other>) -> Relay<Other> {
        self.flatMap { _ in otherRelay }
    }

    @inlinable
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
    @inlinable
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

extension Relay {
    @usableFromInline
    struct WeakContainer {
        weak var reference: ReactiveItemReference!
    }

    @usableFromInline
    enum Storage {
        case constant(Value)
        case weak(WeakContainer)
    }
}
