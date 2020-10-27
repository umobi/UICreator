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
    //swiftlint:disable file_length
    @usableFromInline
    class SpacerView: CBView {
        private weak var view: CBView?
        private(set) var margin: UICSpacer.Edges {
            didSet {
                if self.margin != oldValue {
                    self.layout()
                }
            }
        }

        init() {
            self.margin = .zero
            super.init(frame: .zero)
            self.makeSelfImplemented()
        }

        override init(frame: CGRect) {
            Fatal.Builder("init(frame:) has not been implemented").die()
        }

        required init?(coder: NSCoder) {
            Fatal.Builder("init(coder:) has not been implemented").die()
        }

        @discardableResult
        @usableFromInline
        func setMargin(_ margin: UICSpacer.Edges) -> Self {
            self.margin = margin
            return self
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

        override func willMove(toSuperview newSuperview: CBView?) {
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

private extension Views.SpacerView {
    func layout() {
        guard let view = self.view else {
            return
        }

        Constraintable.update {
            view.cbuild
                .top
                .equalTo(self)
                .update()
                .constant(self.margin.top)

            view.cbuild
                .bottom
                .equalTo(self)
                .update()
                .constant(self.margin.bottom)

            view.cbuild
                .trailing
                .equalTo(self)
                .update()
                .constant(self.margin.trailing)

            view.cbuild
                .leading
                .equalTo(self)
                .update()
                .constant(self.margin.leading)
        }
    }
}

extension Views.SpacerView {

    @discardableResult
    func addContent(_ view: CBView) -> Self {
        self.view = view
        CBSubview(self).addSubview(view)
        self.layout()
        return self
    }

    func reloadContentLayout() {
        guard self.view != nil else {
            return
        }

        self.layout()
    }
}

extension Views.SpacerView {
    @usableFromInline
    func updatePaddingEdges(_ constant: CGFloat, _ edges: PaddingEdges) {
        self.setMargin({
            switch edges {
            case .all:
                return $0.top(constant)
                    .bottom(constant)
                    .leading(constant)
                    .trailing(constant)

            case .vertical:
                return $0.top(constant)
                    .bottom(constant)

            case .horizontal:
                return $0.leading(constant)
                    .trailing(constant)

            case .top:
                return $0.top(constant)
            case .bottom:
                return $0.bottom(constant)
            case .left:
                return $0.leading(constant)
            case .right:
                return $0.trailing(constant)
            }
        }(self.margin))
    }
}
