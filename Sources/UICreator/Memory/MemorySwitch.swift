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

struct WeakOpaque {
    fileprivate weak var object: Opaque?

    fileprivate init(_ object: Opaque?) {
        self.object = object
    }
}

struct StrongOpaque {
    fileprivate var object: Opaque?

    fileprivate init(_ object: Opaque?) {
        self.object = object
    }
}

enum MemorySwitch: Memory {
    typealias Object = Opaque

    case weak(WeakOpaque)
    case strong(StrongOpaque)
    case `nil`

    static func weak(_ object: Opaque?) -> Self {
        return .weak(WeakOpaque(object))
    }

    static func strong(_ object: Opaque?) -> Self {
        return .strong(StrongOpaque(object))
    }
}

extension MemorySwitch {
    var isWeak: Bool {
        if case .weak = self {
            return true
        }

        return false
    }
}

extension MemorySwitch {
    var object: Object! {
        switch self {
        case .weak(let opaque):
            return opaque.object
        case .strong(let opaque):
            return opaque.object
        case .nil:
            return nil
        }
    }
}

extension MemorySwitch {
    func castedObject<T>() -> T? {
        return self.object as? T
    }
}

enum MemoryStoreType {
    case weak
    case strong
}
