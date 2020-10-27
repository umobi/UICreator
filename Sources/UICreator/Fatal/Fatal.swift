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
struct Fatal {
    @inline(__always) @usableFromInline
    static func die(_ type: FatalType) -> Never {
        fatalError(type.error)
    }

    @inline(__always) @usableFromInline
    static func warning(_ type: FatalType) {
        print("[WARNING] \(type.error)")
    }
}

@usableFromInline
protocol FatalType {
    var error: String { get }
    func die() -> Never
    func warning()
}

extension FatalType where Self: RawRepresentable, RawValue == String {

    @inline(__always) @usableFromInline
    var error: String {
        self.rawValue
    }
}

extension FatalType {
    @inline(__always) @usableFromInline
    func die() -> Never {
        Fatal.die(self)
    }

    @inline(__always) @usableFromInline
    func warning() {
        Fatal.warning(self)
    }
}

extension Fatal {
    @usableFromInline
    struct Builder: FatalType {
        @inline(__always) @usableFromInline
        let error: String

        @inline(__always) @usableFromInline
        init(_ string: String) {
            self.error = string
        }
    }
}
