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

private var _reactive = NotificationCenter()
public extension NotificationCenter {
    static var reactive: NotificationCenter {
        return _reactive
    }
}

public protocol _Getter: class {
    associatedtype Value

    var value: Value { get }
}

public protocol _Setter: _Getter {
    var value: Value { get set }
    init(value: Value)
}

private var kGetterValue: UInt = 0

public extension _Getter {
    var value: Value {
        var a: Value! {
            return objc_getAssociatedObject(self, &kGetterValue) as? Value
        }

        return a
    }

    func onChange(_ onChange: @escaping (Value) -> Void) {
        NotificationCenter.reactive.addObserver(forName: Notification.Name(rawValue: "\(ObjectIdentifier(self)).valueChanged"), object: nil, queue: nil, using: { [weak self] _ in
            guard let self = self else {
                return
            }
            onChange(self.value)
        })
    }

    func sync(_ syncHandler: @escaping (Value) -> Void) {
        self.onChange {
            syncHandler($0)
        }

        syncHandler(self.value)
    }
}

public extension _Setter {
    var value: Value {
        get {
            var a: Value! {
                return objc_getAssociatedObject(self, &kGetterValue) as? Value
            }

            return a
        }
        set { setValue(newValue) }
    }

    private func setValue(_ newValue: Value) {
        objc_setAssociatedObject(self, &kGetterValue, newValue, .OBJC_ASSOCIATION_RETAIN)
        NotificationCenter.reactive.post(.init(name: Notification.Name(rawValue: "\(ObjectIdentifier(self)).valueChanged")))
    }
}

public class Getter<Value>: _Getter {}

final public class Value<Value>: Getter<Value>, _Setter {
    public init(value: Value) {
        super.init()
        self.value = value
        print("\(ObjectIdentifier(self))")
    }

    deinit {
        print("Killed")
        print("\(ObjectIdentifier(self))")
    }
}
