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

public struct UICWeakResized {
    weak var superview: UIView!
    weak var subview: UIView!

    fileprivate let height: UILayoutPriority?
    fileprivate let width: UILayoutPriority?
    fileprivate let addHandler: ((UIView) -> Void)?

    init(_ superview: UIView!, subview: UIView!, _ addHandler: ((UIView) -> Void)?) {
        self.superview = superview
        self.subview = subview
        self.height = nil
        self.width = nil
        self.addHandler = addHandler
    }

    private init(
        _ original: UICWeakResized,
        height: UILayoutPriority?,
        width: UILayoutPriority?) {

        self.superview = original.superview
        self.subview = original.subview
        self.height = height ?? original.height
        self.width = width ?? original.width
        self.addHandler = original.addHandler
    }

    public func height(_ priority: UILayoutPriority) -> Self {
        .init(self, height: priority, width: nil)
    }

    public func width(_ priority: UILayoutPriority) -> Self {
        .init(self, height: nil, width: priority)
    }
}

public extension UICWeakResized {
    private struct Copy {
        let subview: UIView
        let superview: UIView
        let height: UILayoutPriority?
        let width: UILayoutPriority?
        let addHandler: ((UIView) -> Void)?

        init?(_ original: UICWeakResized) {
            guard let superview = original.superview, let subview = original.subview else {
                return nil
            }

            guard subview.superview === superview, superview.subviews.contains(subview) else {
                return nil
            }

            self.superview = original.superview
            self.subview = original.subview
            self.height = original.height
            self.width = original.width
            self.addHandler = original.addHandler
        }
    }

    private func copy() -> Copy? {
        return Copy(self)
    }

    mutating func dealloac() {
        self.subview = nil
        self.superview = nil
    }

    func watch(in resizableView: UIView!) {
        var muttable: UICWeakResized? = self

        muttable?.subview.onLayout { [self] in
            guard let copy = self.copy() else {
                muttable?.dealloac()
                return
            }

            guard copy.superview.frame.size != $0.frame.size else {
                return
            }

            copy.superview.frame.size = $0.frame.size
            copy.addHandler?(copy.superview)
        }

        muttable?.superview.autoresizingMask = []

        if let muttable = muttable {
            if let width = self.width {
                Constraintable.activate(
                    muttable.subview.cbuild
                        .width
                        .equalTo(resizableView.cbuild.width)
                        .priority(width)
                )

                muttable.superview.autoresizingMask.insert(.flexibleWidth)
            }

            if let height = self.height {
                Constraintable.activate(
                    muttable.subview.cbuild
                        .height
                        .equalTo(resizableView.cbuild.height)
                        .priority(height)
                )

                muttable.superview.autoresizingMask.insert(.flexibleHeight)
            }
        }

        if resizableView.frame.size != .zero {
            muttable?.subview?.setNeedsLayout()
        }
    }
}
