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

protocol ReusableView: class {
    var hostedView: ViewCreator! { get }
    var contentView: UIView { get }
//    var builder: ViewCreator! { get nonmutating set }
    func prepareCell(_ cell: UICCell)

    var cellLoaded: UICCell.Loaded! { get set }
}

private var kHostedView: UInt = 0
extension ReusableView {
    fileprivate(set) weak var hostedView: ViewCreator! {
        get { objc_getAssociatedObject(self, &kHostedView) as? ViewCreator }
        set { objc_setAssociatedObject(self, &kHostedView, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
}

extension ReusableView {
    func addView() {
        guard let cellLoaded = self.cellLoaded else {
            return
        }

        self.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }

        let host = UICHost(content: cellLoaded.cell.rowManager.payload.content)
        self.hostedView = host
        self.contentView.add(priority: .init(500), host.releaseUIView())
    }

    func reuseCell(_ cell: UICCell) {
        if self.cellLoaded == nil {
            self.cellLoaded = cell.load
            self.addView()
            return
        }

        guard self.cellLoaded?.cell.rowManager !== cell.rowManager else {
            return
        }

        self.cellLoaded = cell.load

        OperationQueue.main.addOperation { [cell] in
            guard self.cellLoaded?.cell.rowManager === cell.rowManager else {
                return
            }

            self.addView()
        }
    }

    func prepareCell(_ cell: UICCell) {
        self.reuseCell(cell)
    }
}
