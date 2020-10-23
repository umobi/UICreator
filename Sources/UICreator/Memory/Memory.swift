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

protocol Memory {
    associatedtype Object

    var object: Object! { get }
}

private let memoryQueue = DispatchQueue(label: "memoryQueue", qos: .utility)

private struct Weak {
    weak var object: AnyObject?
}

private struct Strong {
    let object: AnyObject
}

private enum Storage {
    case weak(Weak)
    case strong(Strong)
    case `nil`

    var value: AnyObject? {
        switch self {
        case .nil:
            return nil
        case .strong(let strong):
            return strong.object
        case .weak(let weak):
            return weak.object
        }
    }
}

enum MemoryPolicity {
    case strong
    case weak
}

private class Payload {
    var objects: [UnsafeRawPointer: Storage]
    weak var reference: AnyObject?

    init(_ reference: AnyObject?) {
        self.reference = reference
        self.objects = [:]
    }
}

private class SwiftMemory {
    var stack: [String: Payload] = [:]

    func orCreate<Element>(_ object: Element) -> Payload where Element: AnyObject {
        let identifier = "\(ObjectIdentifier(object))"
        
        return memoryQueue.sync {
            if let payload = stack[identifier],
                payload.reference != nil && payload.reference === object {
                return payload
            }

            let payload = Payload(object)
            stack[identifier] = payload

            DispatchQueue.main.async {
                onDeinit(object) { [weak self] in
                    self?.stack[identifier] = nil
                }
            }

            return payload
        }
    }
}

private let swiftMemory = SwiftMemory()

func swift_getAssociatedObject(_ object: Any, _ key: UnsafeRawPointer) -> Any? {
    swiftMemory.orCreate(object as AnyObject).objects[key]?.value
}

func swift_setAssociatedObject(_ object: Any, _ key: UnsafeRawPointer, _ value: Any?, _ policity: MemoryPolicity) {
    let payload = swiftMemory.orCreate(object as AnyObject)

    guard let value = (value as AnyObject?) else {
        payload.objects[key] = .nil
        return
    }

    switch policity {
    case .weak:
        payload.objects[key] = .weak(.init(object: value))
    case .strong:
        payload.objects[key] = .strong(.init(object: value))
    }
}

private class Deinit {
    let handler: () -> Void

    init(_ handler: @escaping () -> Void) {
        self.handler = handler
    }

    deinit {
        Thread.detachNewThread { [handler] in
            memoryQueue.sync {
                handler()
            }
        }
    }
}

private var kDeinit = 0
private func onDeinit(_ object: AnyObject,_ handler: @escaping () -> Void) {
    objc_setAssociatedObject(object, &kDeinit, Deinit(handler), .OBJC_ASSOCIATION_RETAIN)
}
