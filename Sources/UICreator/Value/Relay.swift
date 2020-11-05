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

@propertyWrapper @frozen
public struct Relay<Value> {
    @usableFromInline
    enum Content {
        case getAndSet(get: () -> Value, set: (Value) -> Void)
        case dynamic(ObjectIdentifier)
    }

    let content: Content

    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.content = .getAndSet(get: get, set: set)
    }

    public static func constant(_ value: Value) -> Relay<Value> {
        .init(get: { value }, set: { _ in })
    }

    internal init(_ id: ObjectIdentifier) {
        self.content = .dynamic(id)
    }

    public var wrappedValue: Value {
        get {
            switch content {
            case .getAndSet(let get, _):
                return get()
            case .dynamic(let id):
                return (StateRegistered.shared[id]?.object as! UICreator.Value<Value>.Box).get()
            }
        }
        nonmutating
        set {
            switch content {
            case .getAndSet(_, let set):
                return set(newValue)
            case .dynamic(let id):
                (StateRegistered.shared[id]?.object as! UICreator.Value<Value>.Box).set(newValue)
            }
        }
    }

    public var projectedValue: Relay<Value> { self }

    public func sync(_ syncHandler: @escaping (Value) -> Void) {
        syncHandler(wrappedValue)

        guard case .dynamic(let id) = content else {
            return
        }

        (StateRegistered.shared[id]?.object as! UICreator.Value<Value>.Box).onNext(syncHandler)
    }

    public func next(_ nextHandler: @escaping (Value) -> Void) {
        guard case .dynamic(let id) = content else {
            return
        }

        (StateRegistered.shared[id]?.object as! UICreator.Value<Value>.Box).onNext(nextHandler)
    }

    public func map<Other>(_ handler: @escaping (Value) -> Other) -> Relay<Other> {
        switch content {
        case .getAndSet(let get, _):
            return .constant(handler(get()))
        case .dynamic:
            let value = UICreator.Value<Other>(wrappedValue: handler(self.wrappedValue))
            self.next {
                value.wrappedValue = handler($0)
            }

            return value.projectedValue
        }
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
