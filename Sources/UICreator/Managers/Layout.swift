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
import UIKit
import ConstraintBuilder

@usableFromInline
struct Layout {
    private weak var view: CBView!

    @MutableBox fileprivate var layoutHandler: ((CBView) -> Void)?

    private init(_ view: CBView) {
        self.view = view
    }

    @inline(__always)
    static func create(_ view: CBView) -> Self {
        .init(view)
    }

    @inline(__always)
    private func pop() {
        self.layoutHandler?(self.view)
    }

    func commit() {
        guard self.view.isSelfImplemented else {
            return
        }

        ([self.view] + self.view.thatNeedsLayout())
            .reversed()
            .forEach {
                $0.layout.pop()
            }
    }
}

private extension CBView {
    func thatNeedsLayout() -> [CBView] {
        guard !self.isSelfImplemented else {
            return []
        }

        return [self] + self.subviews.reduce([]) {
            $0 + $1.thatNeedsLayout()
        }
    }
}

extension Layout {
    
    @usableFromInline
    func onLayout(_ handler: @escaping (CBView) -> Void) {
        if self.view.frame != .zero {
            handler(self.view)
        }

        let oldHandler = self.layoutHandler
        self.layoutHandler = {
            oldHandler?($0)
            handler($0)
        }
    }
}

public extension CBView {
    @inline(__always) @inlinable @discardableResult
    func onLayout(_ handler: @escaping (CBView) -> Void) -> Self {
        self.layout.onLayout(handler)
        return self
    }
}
