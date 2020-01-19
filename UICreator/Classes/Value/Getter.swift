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

public protocol Getter: class {
    associatedtype Value

    var value: Value { get }
}

internal var kGetterValue: UInt = 0
public extension Getter {
    internal var identifier: String {
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

internal func transform<Value>(_ any: Any?) -> Value {
    var a: Value! {
        return any as? Value
    }

    return a
}
