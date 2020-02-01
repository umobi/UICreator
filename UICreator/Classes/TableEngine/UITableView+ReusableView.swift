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

extension UITableView {
    struct WeakCell {
        private(set) weak var view: ReusableView!
        init(_ view: ReusableView) {
            self.view = view
        }
    }
}

private var kLoadedCells: UInt = 0
extension UITableView {
    private var reusableCells: [WeakCell] {
        get { objc_getAssociatedObject(self, &kLoadedCells) as? [WeakCell] ?? [] }
        set { objc_setAssociatedObject(self, &kLoadedCells, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    func appendReusable(cell: ReusableView) {
        guard !self.reusableCells.contains(where: { $0.view === cell }) else {
            return
        }

        self.reusableCells.append(.init(cell))
        self.reusableCells = self.reusableCells.filter {
            $0.view != nil
        }
    }

    func reusableView(at indexPath: IndexPath) -> ReusableView? {
        self.reusableCells.first(where: {
            $0.view?.cellLoaded.cell.rowManager.indexPath == indexPath
        })?.view
    }
}
