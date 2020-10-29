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

@usableFromInline
class ReactiveItemReference: CustomStringConvertible {
    @usableFromInline
    struct NSWeakObjectProtocol {
        weak var observable: NSObjectProtocol!

        init(_ observable: NSObjectProtocol) {
            self.observable = observable
        }
    }

    private var observables: [NSWeakObjectProtocol] = []

    private var identifier: String {
        "\(ObjectIdentifier(self))"
    }

    @usableFromInline
    var description: String {
        self.identifier
    }

    @usableFromInline
    func append(_ observable: NSObjectProtocol) {
        self.observables.append(.init(observable))
    }

    deinit {
        self.observables.forEach {
            self.reactive.unregister($0.observable)
        }
    }
}

@propertyWrapper @frozen
public struct Value<Value> {
    private let mutableBox: Box

    public var projectedValue: Relay<Value> { .init(self.mutableBox.reference) }

    public var wrappedValue: Value {
        get { self.mutableBox.value }
        nonmutating
        set { self.mutableBox.value = newValue }
    }

    public init(wrappedValue value: Value) {
        self.mutableBox = .init(value: value)
    }
}

extension Value {
    @usableFromInline
    class Box {
        let reference = ReactiveItemReference()

        @inline(__always)
        var value: Value {
            didSet {
                self.reference.reactive.valueDidChange(self.value)
            }
        }

        @usableFromInline
        init(value: Value) {
            self.value = value

            self.reference.reactive.valueSetter { [weak self] in
                self?.value = $0
            }

            self.reference.reactive.valueGetter { [weak self] in
                self?.value
            }
        }
    }
}
