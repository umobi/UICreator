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
import ConstraintBuilder
import UIKit

@frozen
public struct UICHeader: ViewCreator {
    let content: () -> ViewCreator
    let height: CGFloat?

    public init(content: @escaping () -> ViewCreator) {
        self.content = content
        self.height = nil
    }

    private init(_ original: UICHeader, _ editable: Editable) {
        self.content = original.content
        self.height = editable.height
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        fatalError()
    }
}

public extension UICHeader {
    @inlinable
    func estimatedHeight(_ height: CGFloat) -> Self {
        self.edit {
            $0.height = height
        }
    }
}

public extension UICHeader {
    @inline(__always) @inlinable
    static var empty: UICHeader {
        UICHeader {
            UICEmptyView()
        }
        .estimatedHeight(0)
    }
}

extension UICHeader {
    @usableFromInline
    struct Editable {
        @MutableBox @usableFromInline
        var height: CGFloat?

        init(_ original: UICHeader) {
            self._height = .init(wrappedValue: original.height)
        }
    }

    @inline(__always) @usableFromInline
    func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable)
    }
}
