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
    struct WeakCell {
        private(set) weak var view: ReusableView!
        init(_ view: ReusableView) {
            self.view = view
        }
    }
}

struct TableLoadManager {
    let reusableCells: Mutable<[UITableView.WeakCell]> = .init(value: [])
    let manager: Mutable<ListCollectionManager?> = .init(value: nil)
    let cellHandler: Mutable<((UITableViewCell) -> Void)?> = .init(value: nil)
}

private var kTableLoadManager: UInt = 0

extension UITableView {
    var loadManager: TableLoadManager {
        OBJCSet(self, &kTableLoadManager, policity: .strong) {
            .init()
        }
    }
}

extension UITableView {
    var manager: ListCollectionManager? {
        get { self.loadManager.manager.value }
        set { self.loadManager.manager.value = newValue }
    }
}

extension UITableView {
    private var reusableCells: [WeakCell] {
        get { self.loadManager.reusableCells.value }
        set { self.loadManager.reusableCells.value = newValue }
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
