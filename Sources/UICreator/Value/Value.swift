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
public struct Value<Value> {

    let id: ObjectIdentifier
    let ref: Reference

    public init(wrappedValue: Value) {
        let ref = Reference()
        let id = ObjectIdentifier(ref)
        StateRegistered.shared[id] = Box(wrappedValue)

        self.id = id
        self.ref = ref
    }

    public var wrappedValue: Value {
        get { (StateRegistered.shared[id] as! Box).get() }
        nonmutating
        set { (StateRegistered.shared[id] as! Box).set(newValue) }
    }

    public var projectedValue: Relay<Value> {
        .init(id)
    }
}

extension Value {
    @usableFromInline
    class Reference {
        deinit {
            let id = ObjectIdentifier(self)
            DispatchQueue.concurrent.async(flags: .barrier) { [id] in
                StateRegistered.shared[id] = nil
            }
        }
    }
}

extension Value {
    class Box {
        private var value: Value
        private var nextHandler: ((Value) -> Void)? = nil

        init(_ value: Value) {
            self.value = value
        }

        func set(_ value: Value) {
            self.value = value
            self.next()
        }

        func get() -> Value {
            self.value
        }

        private func next() {
            self.nextHandler?(value)
        }

        func onNext(_ handler: @escaping (Value) -> Void) {
            let old = nextHandler
            nextHandler = {
                old?($0)
                handler($0)
            }
        }
    }
}

struct StateObservable {
    weak var observable: NSObjectProtocol!

    init(_ observable: NSObjectProtocol) {
        self.observable = observable
    }
}

class StateRegistered {
    static var shared: StateRegistered = .init()

    private var registered: [ObjectIdentifier: AnyObject] = [:]

    subscript(_ key: ObjectIdentifier) -> AnyObject? {
        get { registered[key] }
        set { registered[key] = newValue }
    }
}

private extension OperationQueue {
    static let deinitSync: OperationQueue = .init()
}

private extension DispatchQueue {
    static let concurrent = DispatchQueue(label: "messages.queue", attributes: .concurrent)
}

class StateSource<Value> {
    private var observables: [StateObservable] = []

    @inline(__always)
    var id: ObjectIdentifier {
        .init(self)
    }

    var value: Value {
        didSet {
            reactive.valueDidChange(self.value)
        }
    }

    @usableFromInline
    init(value: Value) {
        self.value = value

        reactive.valueSetter { [weak self] in
            self?.value = $0
        }

        reactive.valueGetter { [weak self] in
            self?.value
        }
    }

    @usableFromInline
    func append(_ observable: NSObjectProtocol) {
        self.observables.append(.init(observable))
    }

    static func restore(_ identifier: ObjectIdentifier) -> StateSource? {
        StateRegistered.shared[identifier] as? StateSource
    }

    deinit {
        self.observables.forEach { observable in
            OperationQueue.deinitSync.addOperation {
                observable.unregister()
            }
        }
    }
}

extension StateObservable {
    func unregister() {
        if let observable = self.observable {
            OperationQueue.deinitSync.addOperation {
                ReactiveCenter.shared.removeObserver(observable)
            }
        }
    }
}

@propertyWrapper
public struct _Value<Value> {
    let reference: Reference

    public init(wrappedValue: Value) {
        self.reference = .init()
        StateRegistered.shared[reference.id] = StateSource(value: wrappedValue)
    }

    public var wrappedValue: Value {
        get { (StateRegistered.shared[reference.id] as! StateSource).value }
        nonmutating
        set { (StateRegistered.shared[reference.id] as? StateSource)?.value = newValue }
    }

    public var projectedValue: Relay<Value> {
        .init(self.reference.id)
    }
}

extension _Value {
    class Reference {
        var id: ObjectIdentifier {
            ObjectIdentifier(self)
        }

        deinit {
            StateRegistered.shared[id] = nil
        }
    }
}

public protocol DynamicObject: class {}

class ObjectRegistered {
    static var shared: ObjectRegistered = .init()

    private var registered: [ObjectIdentifier: AnyObject] = [:]

    subscript(_ key: ObjectIdentifier) -> AnyObject? {
        get { registered[key] }
        set { registered[key] = newValue }
    }
}

@propertyWrapper @frozen
public struct WatchObject<Object> where Object: DynamicObject {
    @usableFromInline
    class Reference {
        deinit {
            ObjectRegistered.shared[ObjectIdentifier(self)] = nil
        }
    }

    private let reference: Reference

    public var wrappedValue: Object {
        get { ObjectRegistered.shared[ObjectIdentifier(reference)] as! Object }
        set { ObjectRegistered.shared[ObjectIdentifier(reference)] = newValue }
    }

    public init(wrappedValue: Object) {
        reference = .init()
        ObjectRegistered.shared[.init(reference)] = wrappedValue
    }

    @dynamicMemberLookup
    public struct Wrapped {
        private let reference: ObjectIdentifier

        fileprivate init(_ reference: ObjectIdentifier) {
            self.reference = reference
        }

        public subscript<Value>(dynamicMember dynamicMember: KeyPath<Object, Value>) -> Value {
            (ObjectRegistered.shared[reference] as! Object)[keyPath: dynamicMember]
        }
    }

    public var projectedValue: WatchObject.Wrapped {
        .init(.init(reference))
    }
}

@propertyWrapper
public struct Release<Object> {
    @MutableBox var box: Object!

    public init(wrappedValue: Object) {
        self._box = .init(wrappedValue: wrappedValue)
    }

    public var wrappedValue: Object {
        get {
            let value: Object! = box
            box = nil
            return value
        }

        set { box = newValue }
    }
}
