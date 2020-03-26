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
import EasyAnchor

extension Anchor {
    class ConstraintFinalize {
        private var constraint: NSLayoutConstraint?
        private var anchor: Anchor

        init(original: Anchor, _ constraint: NSLayoutConstraint) {
            self.constraint = constraint
            self.anchor = original
        }

        init(_ anchor: Anchor) {
            self.constraint = nil
            self.anchor = anchor
        }

        private func activateIfNeeded() {
            if let constraint = self.constraint {
                if !constraint.isActive {
                    NSLayoutConstraint.activate([constraint])
                }
            } else {
                activate(anchor)
            }
        }

        @discardableResult
        func constant(_ constant: CGFloat) -> Self {
            self.constraint?.constant = constant
            self.anchor = self.anchor.constant(constant)
            return self
        }

        private func desactivate() {
            NSLayoutConstraint.deactivate([self.constraint].compactMap { $0 })
            self.constraint = nil
        }

        @discardableResult
        func multiplier(_ multiplier: CGFloat) -> Self {
            self.desactivate()
            self.anchor = self.anchor.multiplier(multiplier)
            return self
        }

        @discardableResult
        func priority(_ priority: UILayoutPriority) -> Self {
            self.constraint?.priority = priority
            self.anchor = self.anchor.priority(priority.rawValue)
            return self
        }

        @discardableResult
        func priority(_ priority: Float) -> Self {
            if #available(iOS 13, tvOS 13, *) {
                self.constraint?.priority = .init(priority)
            } else {
                self.desactivate()
            }
            self.anchor = self.anchor.priority(priority)
            return self
        }

        deinit {
            self.activateIfNeeded()
        }
    }

    func orCreate() -> ConstraintFinalize {
        if let constraint = self.find().first {
            let finalize = ConstraintFinalize(original: self, constraint)
            return finalize
        }

        return .init(self)
    }
}
