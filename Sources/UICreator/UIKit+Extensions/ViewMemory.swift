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

private var kViewMemory: UInt = 0
private extension CBView {
    struct Memory {
        @MutableBox var render: Render
        @MutableBox var layout: Layout
        @MutableBox var appear: Appear
        @MutableBox var trait: Trait

        @MutableBox var isSelfImplemented: Bool

        init(_ view: UIView) {
            self._render = .init(wrappedValue: .create(view))
            self._layout = .init(wrappedValue: .create(view))
            self._appear = .init(wrappedValue: .create(view))
            self._trait = .init(wrappedValue: .create(view))

            self._isSelfImplemented = .init(wrappedValue: false)
        }
    }

    var memory: Memory {
        OBJCSet(
            self,
            &kViewMemory,
            policity: .OBJC_ASSOCIATION_COPY,
            orLoad: { [unowned self] in .init(self) }
        )
    }
}

extension CBView {
    @objc var dynamicView: CBView {
        return self
    }

    private var adaptorOrView: CBView! {
        if self.superview is ViewAdaptor {
            return self.superview
        }

        return self
    }

    var layoutSuperview: CBView? {
        guard let superview = self.superview else {
            return nil
        }

        return sequence(first: superview, next: { $0.adaptorOrView.superview })
            .first(where: { !($0 is ViewCreatorNoLayoutConstraints)})
    }
}

extension CBView {
    var render: Render {
        self.memory.render
    }

    var layout: Layout {
        self.memory.layout
    }

    var appear: Appear {
        self.memory.appear
    }

    var trait: Trait {
        self.memory.trait
    }

    var isSelfImplemented: Bool {
        get { self.memory.isSelfImplemented }
        set { self.memory.isSelfImplemented = newValue }
    }
}

extension CBView {

    @discardableResult
    func makeSelfImplemented() -> Self {
        self.isSelfImplemented = true
        return self
    }
}
