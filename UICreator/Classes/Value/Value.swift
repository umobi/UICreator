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

public final class Value<Value>: Getter, Setter {
    private var _value: Value
    public var value: Value {
        get { return self._value }
        set {
            self._value = newValue
            ReactiveCenter.shared.valueDidChange(self.identifier, newValue: newValue)
        }
    }

    required public init(value: Value) {
        self._value = value
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
        ReactiveCenter.shared.privateDeinit(self.identifier)
        ReactiveCenter.shared.unregister(self.identifier)
    }
}

public extension Value {
    var asRelay: Relay<Value> {
        return .init(identifier: self.identifier)
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
