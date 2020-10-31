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
    class CollectionViewCell: UICollectionViewCell, ReusableView, ListReusableView {
        weak var hostedView: CBView!
        var cellLoaded: UICCell.Loaded!
        var row: Row!

        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = .clear
            self.makeSelfImplemented()
        }

        required init?(coder: NSCoder) {
            Fatal.Builder("init(coder:) has not been implemented").die()
        }

        override open var isHidden: Bool {
            get { super.isHidden }
            set {
                super.isHidden = newValue
                self.renderManager.isHidden(newValue)
            }
        }

        override open var frame: CGRect {
            get { super.frame }
            set {
                super.frame = newValue
                self.renderManager.frame(newValue)
            }
        }

        override public func willMove(toSuperview newSuperview: UIView?) {
            super.willMove(toSuperview: newSuperview)
            self.renderManager.willMove(toSuperview: newSuperview)
        }

        override public func didMoveToSuperview() {
            super.didMoveToSuperview()
            self.renderManager.didMoveToSuperview()
        }

        override public func didMoveToWindow() {
            super.didMoveToWindow()
            self.renderManager.didMoveToWindow()
        }

        override public func layoutSubviews() {
            super.layoutSubviews()
            self.renderManager.layoutSubviews()
        }

        override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            self.renderManager.traitDidChange()
        }
    }
}
