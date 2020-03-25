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

struct ReusableObject {
    weak var viewCreator: ViewCreator!
    init(_ viewCreator: ViewCreator) {
        self.viewCreator = viewCreator
    }
}

private var kHostedView: UInt = 0
extension ReusableView {
    private var mutableReusableObject: Mutable<ReusableObject?> {
        OBJCSet(self, &kHostedView) {
            .init(value: nil)
        }
    }

    private var reusableObject: ReusableObject! {
        get { self.mutableReusableObject.value }
        set { self.mutableReusableObject.value = newValue }
    }
    
    fileprivate(set) weak var hostedView: ViewCreator! {
        get { self.reusableObject.viewCreator }
        set { self.reusableObject = .init(newValue) }
    }
}

extension ReusableView {
    func newAddView(_ hosted: UICHost) {
        self.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }

        self.hostedView = hosted
        self.contentView.add(priority: .init(500), hosted.releaseUIView())
    }

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

    func newReusableCell(_ cell: UICCell) {
        if self.cellLoaded == nil {
            let cellLoaded = cell.load
            let new = UICHost(content: cellLoaded.cell.rowManager.payload.content)
            self.cellLoaded = cellLoaded
            self.newAddView(new)
            return
        }

        guard self.cellLoaded?.cell.rowManager !== cell.rowManager else {
            return
        }

        let cellLoaded = cell.load
        let new = UICHost(content: cellLoaded.cell.rowManager.payload.content)
        let old = self.hostedView
        self.cellLoaded = cellLoaded

        if let old = old {
            if !ReplacementTree(old).replace(with: new) {
                self.newAddView(new)
            }
        } else {
            self.newAddView(new)
        }
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
        self.addView()
    }

    func prepareCell(_ cell: UICCell) {
        self.reuseCell(cell)
    }
}
