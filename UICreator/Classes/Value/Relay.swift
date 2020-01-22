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

public final class Relay<Value> {
    let identifier: String

    init(identifier: String) {
        self.identifier = identifier
        self.handler = nil
    }

    public func next(_ handler: @escaping (Value) -> Void) {
        Self.collapse(self)() { value in
            handler(value)
        }
    }

    public func sync(_ handler: @escaping (Value) -> Void) {
        Self.collapse(self)() { value in
            handler(value)
        }
        
        ReactiveCenter.shared.privateResquestLatestValue(self.identifier)
    }

    private static func collapse<Value>(_ relay: Relay<Value>) -> ((@escaping (Value) -> Void) -> Void) {
        let identifier = relay.identifier
        let handler = relay.handler

        return  { externalHandler in
            if let selfHandler = handler {
                selfHandler() {
                    externalHandler($0)
                }

                return
            }

            ReactiveCenter.shared.valueDidChange(identifier) {
                externalHandler($0)
            }

            ReactiveCenter.shared.privateValueDidChange(identifier) {
                externalHandler($0)
            }

            ReactiveCenter.shared.privateLatestValue(identifier) {
                externalHandler($0)
            }
        }
    }

    let handler: ((@escaping  (Value) -> Void) -> Void)?
    init(_ identifier: String, handler: @escaping ((@escaping (Value) -> Void) -> Void)) {
        self.identifier = identifier
        self.handler = handler
        print("[Relay] init")
    }

    public func map<Other>(_ handler: @escaping  (Value) -> Other) -> Relay<Other> {
        let callbase = Self.collapse(self)
        return Relay<Other>.init(self.identifier, handler: { function in
            return callbase() {
                function(handler($0))
            }
        })
    }

    func `post`(_ value: Value) {
        ReactiveCenter.shared.privateValueDidChange(self.identifier, newValue: value)
    }
}
