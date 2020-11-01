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

extension UITableView {
    struct Memory {
        @MutableBox var reusableCells: [WeakBox<AnyObject>] = []
        @MutableBox var modifier: ListModifier?
        @MutableBox var cellHandler: ((UITableViewCell) -> Void)?
    }
}

private var kTableMemory: UInt = 0
extension UITableView {
    var memory: Memory {
        OBJCSet(
            self,
            &kTableMemory,
            policity: .OBJC_ASSOCIATION_COPY,
            orLoad: Memory.init
        )
    }
}

extension UITableView {
    @inline(__always) @usableFromInline
    var modifier: ListModifier? {
        get { self.memory.modifier }
        set { self.memory.modifier = newValue }
    }
}

extension UITableView {
    @inline(__always)
    private var reusableViews: [WeakBox<AnyObject>] {
        get { self.memory.reusableCells }
        set { self.memory.reusableCells = newValue }
    }

    func append(_ reusableView: ListReusableView) {
        guard !self.reusableViews.contains(where: { $0.wrappedValue === reusableView }) else {
            return
        }

        self.reusableViews.append(.init(wrappedValue: reusableView))
        self.reusableViews = self.reusableViews.filter {
            $0.wrappedValue != nil
        }
    }

    func reusableView(at indexPath: IndexPath) -> ListReusableView? {
        self.reusableViews.first(where: {
            guard case .row(_, _, _, let rowIndexPath)? = ($0.wrappedValue as? ListReusableView)?.row.type else {
                return false
            }

            return rowIndexPath == indexPath
        })?.wrappedValue as? ListReusableView
    }
}
