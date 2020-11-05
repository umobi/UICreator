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
    let deinitable: Reference

    public init(wrappedValue: Value) {
        let ref = StateRegistered.Reference()
        let id = ObjectIdentifier(ref)
        StateRegistered.shared[id] = .init(ref: ref, object: Box(wrappedValue))

        self.id = id
        self.deinitable = .init(id)
    }

    public var wrappedValue: Value {
        get { (StateRegistered.shared[id]?.object as! Box).get() }
        nonmutating
        set { (StateRegistered.shared[id]?.object as! Box).set(newValue) }
    }

    @inline(__always)
    public var projectedValue: Relay<Value> {
        .init(id)
    }
}

extension Value {
    @usableFromInline
    class Reference {
        let id: ObjectIdentifier

        init(_ id: ObjectIdentifier) {
            self.id = id
        }

        deinit {
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
    class Reference {}
    struct Payload {
        let ref: Reference
        let object: AnyObject
    }

    static var shared: StateRegistered = .init()

    private var registered: [ObjectIdentifier: Payload] = [:]

    subscript(_ key: ObjectIdentifier) -> Payload? {
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
        StateRegistered.shared[identifier]?.object as? StateSource
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
