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

struct Trait {
    private weak var view: CBView!

    @MutableBox fileprivate var traitHandler: ((CBView) -> Void)?

    private init(_ view: CBView) {
        self.view = view
    }

    static func create(_ view: CBView) -> Self {
        .init(view)
    }

    private func pop() {
        self.traitHandler?(self.view)
    }

    func commit() {
        guard self.view.isSelfImplemented else {
            return
        }

        ([self.view] + self.view.thatNeedsTrait())
            .reversed()
            .forEach {
                $0.trait.pop()
            }
    }
}

private extension CBView {
    func thatNeedsTrait() -> [CBView] {
        guard !self.isSelfImplemented else {
            return []
        }

        return [self] + self.subviews.reduce([]) {
            $0 + $1.thatNeedsTrait()
        }
    }
}

private extension Trait {
    func onTrait(_ handler: @escaping (CBView) -> Void) {
        handler(self.view)

        let oldHandler = self.traitHandler
        self.traitHandler = {
            oldHandler?($0)
            handler($0)
        }
    }
}

public extension CBView {
    @discardableResult
    func onTrait(_ handler: @escaping (CBView) -> Void) -> Self {
        self.trait.onTrait(handler)
        return self
    }
}
