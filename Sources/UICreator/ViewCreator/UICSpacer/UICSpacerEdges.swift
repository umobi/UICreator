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

public extension UICSpacer {

    @frozen
    struct Edges {
        public let top: CGFloat
        public let bottom: CGFloat
        public let leading: CGFloat
        public let trailing: CGFloat

        @inlinable
        public init(top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) {
            self.top = top
            self.bottom = bottom
            self.leading = leading
            self.trailing = trailing
        }

        @inlinable
        public init(vertical: CGFloat, horizontal: CGFloat) {
            self.init(top: vertical, bottom: vertical, leading: horizontal, trailing: horizontal)
        }

        @inlinable
        public init(spacing: CGFloat) {
            self.init(top: spacing, bottom: spacing, leading: spacing, trailing: spacing)
        }

        @inlinable
        public static var zero: Edges {
            .init(top: 0, bottom: 0, leading: 0, trailing: 0)
        }
    }
}

extension UICSpacer.Edges: Equatable {

    @inline(__always)
    public static func ==(rhs: UICSpacer.Edges, lhs: UICSpacer.Edges) -> Bool {
        rhs.top == lhs.top
            && rhs.leading == lhs.leading
            && rhs.trailing == lhs.trailing
            && rhs.bottom == lhs.bottom
    }
}

public extension UICSpacer.Edges {
    
    @inlinable
    func top(_ constant: CGFloat) -> Self {
        .init(
            top: constant,
            bottom: self.bottom,
            leading: self.leading,
            trailing: self.trailing
        )
    }

    @inlinable
    func bottom(_ constant: CGFloat) -> Self {
        .init(
            top: self.top,
            bottom: constant,
            leading: self.leading,
            trailing: self.trailing
        )
    }

    @inlinable
    func leading(_ constant: CGFloat) -> Self {
        .init(
            top: self.top,
            bottom: self.bottom,
            leading: constant,
            trailing: self.trailing
        )
    }

    @inlinable
    func trailing(_ constant: CGFloat) -> Self {
        .init(
            top: self.top,
            bottom: self.bottom,
            leading: self.leading,
            trailing: constant
        )
    }
}
