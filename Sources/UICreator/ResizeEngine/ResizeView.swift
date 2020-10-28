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
public struct ResizeView {

    @usableFromInline
    let superview: CBView
    @usableFromInline
    let addHandler: ((CBView) -> Void)?

    public init(_ superview: CBView) {
        self.superview = superview
        self.addHandler = nil
    }

    public init(size: CGSize? = nil, superview: CBView? = nil) {
        if let superview = superview {
            superview.frame = {
                if let size = size {
                    return .init(origin: .zero, size: size)
                }

                return .zero
            }()
            self.addHandler = nil
            self.superview = superview
            return
        }

        self.superview = CBView(frame: .init(origin: .zero, size: size ?? .zero))
        self.addHandler = nil
    }

    @usableFromInline
    init(_ original: ResizeView, addHandler: @escaping (CBView) -> Void) {
        self.superview = original.superview
        self.addHandler = addHandler
    }

    @inlinable
    public func onAdd(_ handler: @escaping (CBView) -> Void) -> Self {
        .init(self, addHandler: handler)
    }

    @inlinable
    public func addSubview(_ subview: CBView) -> ResizeWeakView {
        CBView.CBSubview(self.superview)?.addSubview(subview)

        self.superview.translatesAutoresizingMaskIntoConstraints = true
        self.superview.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        Constraintable.activate {
            subview.cbuild
                .center
                .equalTo(self.superview.cbuild.center)
        }

        self.addHandler?(self.superview)

        return .init(self.superview, subview: subview, self.addHandler)
    }
}
