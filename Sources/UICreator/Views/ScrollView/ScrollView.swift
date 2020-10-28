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
    class ScrollView: UIScrollView, UICViewContent {

        private weak var contentView: CBView!

        var axis: UICScroll.Axis {
            didSet {
                if self.axis != oldValue {
                    self.reloadContentLayout()
                }
            }
        }

        var verticalMargin: UICScroll.Margin = .safeArea {
            didSet {
                self.reloadContentLayout()
            }
        }

        var horizontalMargin: UICScroll.Margin = .bounds {
            didSet {
                self.reloadContentLayout()
            }
        }

        override var contentInset: UIEdgeInsets {
            didSet {
                self.reloadContentLayout()
            }
        }

        init(_ axis: UICScroll.Axis) {
            self.axis = axis
            super.init(frame: .zero)
            self.makeSelfImplemented()
        }

        required init?(coder: NSCoder) {
            Fatal.Builder("init(coder:) has not been implemented").die()
        }

        override var isHidden: Bool {
            get { super.isHidden }
            set {
                super.isHidden = newValue
                self.renderManager.isHidden(newValue)
            }
        }

        override var frame: CGRect {
            get { super.frame }
            set {
                super.frame = newValue
                self.renderManager.frame(newValue)
            }
        }

        override func willMove(toSuperview newSuperview: UIView?) {
            super.willMove(toSuperview: newSuperview)
            self.renderManager.willMove(toSuperview: newSuperview)
        }

        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            self.renderManager.didMoveToSuperview()
        }

        override func didMoveToWindow() {
            super.didMoveToWindow()
            self.renderManager.didMoveToWindow()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            self.renderManager.layoutSubviews()
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            self.renderManager.traitDidChange()
        }
    }
}

extension Views.ScrollView {

    func addContent(_ view: CBView) {
        let contentView = ContentView(view)
        CBSubview(self).addSubview(contentView)
        self.contentView = contentView

        Constraintable.activate {
            contentView.cbuild
                .edges
        }

        self.reloadContentLayout()
    }

    func reloadContentLayout() {
        Constraintable.deactivate {
            self.contentView.cbuild.width.equalTo(self.cbuild.width)
            self.contentView.cbuild.height.equalTo(self.cbuild.height)
        }

        switch axis {
        case .vertical:
            Constraintable.activate {
                contentView.cbuild
                    .width
                    .equalTo(self.widthMarginAnchor)
                    .priority(.required)
                    .constant(-self.horizontalOffset)

                contentView.cbuild
                    .height
                    .equalTo(self.heightMarginAnchor)
                    .priority(.fittingSizeLevel)
                    .constant(-self.verticalOffset)
            }
        case .horizontal:
            Constraintable.activate {
                contentView.cbuild
                    .width
                    .equalTo(self.widthMarginAnchor)
                    .priority(.fittingSizeLevel)
                    .constant(-self.horizontalOffset)

                contentView.cbuild
                    .height
                    .equalTo(self.heightMarginAnchor)
                    .priority(.required)
                    .constant(-self.verticalOffset)
            }

        case .auto(let vertical, let horizontal):
            Constraintable.activate {
                contentView.cbuild
                    .width
                    .equalTo(self.widthMarginAnchor)
                    .priority(horizontal)
                    .constant(-self.horizontalOffset)

                contentView.cbuild
                    .height
                    .equalTo(self.heightMarginAnchor)
                    .priority(vertical)
                    .constant(-self.verticalOffset)
            }
        }
    }
}

private extension Views.ScrollView {
    var heightMarginAnchor: ConstraintDimension {
        switch self.verticalMargin {
        case .bounds:
            return self.cbuild.height
        case .safeArea:
            if #available(iOS 11, tvOS 11, *) {
                return self.safeAreaLayoutGuide.cbuild.height
            }

            if case .vertical = self.axis {
                return self.layoutMarginsGuide.cbuild.height
            }

            return self.cbuild.height
        }
    }

    var widthMarginAnchor: ConstraintDimension {
        switch self.verticalMargin {
        case .bounds:
            return self.cbuild.width
        case .safeArea:
            if #available(iOS 11, tvOS 11, *) {
                return self.safeAreaLayoutGuide.cbuild.width
            }

            if case .horizontal = self.axis {
                return self.layoutMarginsGuide.cbuild.width
            }

            return self.cbuild.width
        }
    }
}

private extension Views.ScrollView {
    
    @inline(__always)
    var verticalOffset: CGFloat {
        self.contentInset.top + self.contentInset.bottom
    }

    @inline(__always)
    var horizontalOffset: CGFloat {
        self.contentInset.left + self.contentInset.right
    }
}
