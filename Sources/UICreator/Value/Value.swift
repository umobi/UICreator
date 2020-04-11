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
public struct Value<Value>: Getter, IDGetter {
    private class ID: IDGetter {
        var identifier: String {
            "\(ObjectIdentifier(self))"
        }

        var value: Value {
            didSet {
                ReactiveCenter.shared.valueDidChange(self.identifier, newValue: self.value)
            }
        }

        init(_ value: Value) {
            self.value = value

            ReactiveCenter.shared.start(self.identifier)
            ReactiveCenter.shared.valueDidChange(self.identifier, newValue: value)

            ReactiveCenter.shared.privateResquestLatestValue(self.identifier) { [weak self] in
                guard let self = self else {
                    return
                }

                ReactiveCenter.shared.privateLatestValue(self.identifier, newValue: self.value)
            }
        }

        deinit {
            ReactiveCenter.shared.remove(self.identifier)
        }
    }

    private let id: ID
    var identifier: String {
        self.id.identifier
    }

    public var projectedValue: UICreator.Value<Value> { return self }

    public var wrappedValue: Value {
        get { self.id.value }
        nonmutating
        set { self.id.value = newValue }
    }

    public init(wrappedValue value: Value) {
        self.id = .init(value)
    }

}

public extension Value {
    var asRelay: Relay<Value> {
        return .init(self.id)
    }
}

public extension Value {
    func bind<Object, ObjectValue>(_ keyPath: KeyPath<Object, ObjectValue>) -> Relay<ObjectValue?> where Value == Optional<Object> {
        return self.asRelay.map {
            guard let object = $0 else {
                return nil
            }

            return object[keyPath: keyPath]
        }
    }

    func bind<ObjectValue>(_ keyPath: KeyPath<Value, ObjectValue>) -> Relay<ObjectValue?> {
        return self.asRelay.map {
            $0[keyPath: keyPath]
        }
    }

    func bind<ObjectValue>(_ keyPath: KeyPath<Value, ObjectValue>) -> Relay<ObjectValue> {
        return self.asRelay.map {
            $0[keyPath: keyPath]
        }
    }
}
