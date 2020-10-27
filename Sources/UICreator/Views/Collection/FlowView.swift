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

extension Views {
    public class FlowView: UICollectionView, ListSupport, UICollectionViewLayoutCreator {
        public typealias CollectionLayout = UICollectionViewFlowLayout

        @inline(__always)
        init() {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumLineSpacing = .zero
            flowLayout.minimumInteritemSpacing = .zero
            super.init(frame: .zero, collectionViewLayout: flowLayout)
            self.makeSelfImplemented()
        }

        @inline(__always)
        public func provideDelegate() -> UICollectionViewDelegate {
            UICCollectionViewDelegateFlowLayout()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
            fatalError("init(frame:, collectionViewLayout:) has not been implemented")
        }

        public override var isHidden: Bool {
            get { super.isHidden }
            set {
                super.isHidden = newValue
                self.renderManager.isHidden(newValue)
            }
        }

        public override var frame: CGRect {
            get { super.frame }
            set {
                super.frame = newValue
                self.renderManager.frame(newValue)
            }
        }

        public override func willMove(toSuperview newSuperview: UIView?) {
            super.willMove(toSuperview: newSuperview)
            self.renderManager.willMove(toSuperview: newSuperview)
        }

        public override func didMoveToSuperview() {
            super.didMoveToSuperview()
            self.renderManager.didMoveToSuperview()
        }

        public override func didMoveToWindow() {
            super.didMoveToWindow()
            self.renderManager.didMoveToWindow()
        }

        public override func layoutSubviews() {
            super.layoutSubviews()
            self.renderManager.layoutSubviews()
        }

        public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            self.renderManager.traitDidChange()
        }

        public override func reloadData() {
            super.reloadData()
            self.invalidateLayoutMaker()
        }
    }
}
