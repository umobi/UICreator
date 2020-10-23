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

//struct Binary<Key, Value> where Key: Comparable {
//    private var array: [(Key, Value)]
//
//    init(_ key: Key, _ value: Value) {
//        self.array = [(key, value)]
//    }
//
//    init() {
//        self.array = []
//    }
//
//    private func search(_ key: Key) -> Int? {
//        var lowIndex = 0
//        var highIndex = self.array.count - 1
//
//        while lowIndex <= highIndex {
//            let mid = (lowIndex + highIndex) / 2
//            if self.array[mid].0 == key {
//                //print("Value found")
//                return mid
//            } else if self.array[mid].0 < key {
//                lowIndex = mid + 1
//            } else {
//                highIndex = mid - 1
//            }
//        }
//
//        return nil
//    }
//
//    private mutating func insert(_ key: Key, _ value: Value) -> Bool {
//        var lowIndex = 0
//        var highIndex = self.array.count - 1
//
//        while lowIndex <= highIndex {
//            let mid = (lowIndex + highIndex) / 2
//            if self.array[mid].0 == key {
//                //print("Value found")
//                self.array[mid] = (key, value)
//                return true
//            } else if self.array[mid].0 < key {
//                guard mid + 1 > highIndex || key < self.array[mid + 1].0 else {
//                    self.array.insert((key, value), at: mid)
//                    return true
//                }
//
//                lowIndex = mid + 1
//            } else {
//                highIndex = mid - 1
//            }
//        }
//
//        return mid
//    }
//
//    var isEmpty: Bool {
//        self.array.isEmpty
//    }
//
//    mutating func update(_ i: Int, _ newValue: Value) {
//        self.array[i] = (self.array[i].0, newValue)
//    }
//
//    subscript(_ key: Key) -> Value? {
//        get {
//            guard let i = self.search(key) else {
//                return nil
//            }
//
//            return self.array[i].1
//        }
//
//        mutating set {
//            if let i = self.search(key) {
//                guard let newValue = newValue else {
//                    self.array = Array(self.array[0..<i]) + Array(self.array[i+1..<self.array.count])
//                    return
//                }
//
//                self.update(i, newValue)
//            }
//
//            guard let newValue = newValue else {
//                return
//            }
//
//            for (offset, element) in self.array.enumerated() {
//                var i = self.array.count / 2
//
//                if element.0 > key {
//                    self.array.insert((key, newValue), at: offset)
//                    return
//                }
//            }
//
//            self.array += [(key, newValue)]
//        }
//    }
//}
//
//private let memoryQueue = DispatchQueue(label: "memoryQueue", qos: .utility)
//
//private struct Weak {
//    weak var object: AnyObject?
//
//    init(_ object: AnyObject) {
//        self.object = object
//    }
//}
//
//private struct Strong {
//    let object: AnyObject
//
//    init(_ object: AnyObject) {
//        self.object = object
//    }
//}
//
//private enum Storage {
//    case weak(Weak)
//    case strong(Strong)
//    case `nil`
//
//    var value: AnyObject? {
//        if case .weak(let object) = self {
//            return object.object
//        }
//
//        if case .strong(let object) = self {
//            return object.object
//        }
//
//        return nil
//    }
//}
//
//enum MemoryPolicity {
//    case strong
//    case weak
//}
//
//private struct Payload {
//    let objects: Binary<UnsafeRawPointer, Storage>
//    weak var reference: AnyObject?
//
//    init(_ reference: AnyObject, _ key: UnsafeRawPointer, _ value: Storage) {
//        self.objects = .init(key, value)
//        self.reference = reference
//    }
//
//    private init(_ original: Payload, _ key: UnsafeRawPointer, _ value: Storage) {
//        var objects = original.objects
//        objects[key] = value
//
//        self.objects = objects
//        self.reference = original.reference
//    }
//
//    func append(_ key: UnsafeRawPointer,_ value: Storage) -> Payload {
//        .init(self, key, value)
//    }
//}
//
//private class SwiftMemory {
//    private var stack: Binary<ObjectIdentifier, Payload> = .init()
//
//    func read(_ object: Any, _ key: UnsafeRawPointer) -> Storage {
//        let object = object as AnyObject
//        let identifier = ObjectIdentifier(object)
//
//        return memoryQueue.sync {
//            guard
//                let payload = self.stack[identifier],
//                payload.reference != nil && payload.reference === object
//            else { return .nil }
//
//            return payload.objects[key] ?? .nil
//        }
//    }
//
//    var isEmpty: Bool {
//        self.stack.isEmpty
//    }
//
//    func set(_ object: Any, _ key: UnsafeRawPointer, _ storage: Storage) {
//        let object = object as AnyObject
//        let identifier = ObjectIdentifier(object)
//
//        if let payload = self.stack[identifier], payload.reference != nil && payload.reference === object {
//            return memoryQueue.sync {
//                self.stack[identifier] = payload.append(key, storage)
//            }
//        }
//
//        let payload = Payload(object, key, storage)
//        memoryQueue.sync {
//            self.stack[identifier] = payload
//        }
//
//        onDeinit(object) { [weak self] in
//            self?.stack[identifier] = nil
//        }
//    }
//}
//
//var isMemoryEmpty: Bool {
//    swiftMemory.isEmpty
//}
//
//private let swiftMemory = SwiftMemory()
//
//func swift_getAssociatedObject(_ object: Any, _ key: UnsafeRawPointer) -> Any? {
//    swiftMemory.read(object, key).value
//}
//
//func swift_setAssociatedObject(_ object: Any, _ key: UnsafeRawPointer, _ value: Any?, _ policity: MemoryPolicity) {
//    guard let value = (value as AnyObject?) else {
//        swiftMemory.set(object, key, .nil)
//        return
//    }
//
//    switch policity {
//    case .weak:
//        swiftMemory.set(object, key, .weak(.init(value)))
//    case .strong:
//        swiftMemory.set(object, key, .strong(.init(value)))
//    }
//}
//
//private class Deinit {
//    let handler: () -> Void
//
//    init(_ handler: @escaping () -> Void) {
//        self.handler = handler
//    }
//
//    deinit {
////        memoryQueue.sync { [handler] in
////            handler()
////        }
//    }
//}
//
//private var kDeinit = 0
//private func onDeinit(_ object: AnyObject,_ handler: @escaping () -> Void) {
//    objc_setAssociatedObject(object, &kDeinit, Deinit(handler), .OBJC_ASSOCIATION_RETAIN)
//}
