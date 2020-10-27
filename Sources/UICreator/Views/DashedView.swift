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

public extension Views {
    class DashedView: UIView {

        @usableFromInline
        private(set) var strokeColor: UIColor = .clear

        @usableFromInline
        private(set) var lineWidth: CGFloat = 1

        @usableFromInline
        private(set) var dashPattern: [NSNumber]

        private var shape: CAShapeLayer!

        @usableFromInline
        weak var view: UIView?

        init() {
            self.dashPattern = []
            super.init(frame: .zero)
            self.makeSelfImplemented()
        }

        required public init?(coder: NSCoder) {
            Fatal.Builder("init(coder:) has not been implemented").die()
        }

        public override init(frame: CGRect) {
            Fatal.Builder("init(frame:) has not been implemented").die()
        }

        private func createShape() -> CAShapeLayer {
            guard let view = self.view else {
                return CAShapeLayer()
            }

            let shapeLayer: CAShapeLayer = CAShapeLayer()
            let frameSize = self.frame.size
            let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

            shapeLayer.bounds = shapeRect
            shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = strokeColor.cgColor
            shapeLayer.lineWidth = self.lineWidth
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
            shapeLayer.lineDashPattern = self.dashPattern
            shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: view.layer.cornerRadius).cgPath

            self.layer.addSublayer(shapeLayer)

            return shapeLayer
        }

        @usableFromInline
        func refreshView() {
            guard let view = self.view else {
                return
            }

            if self.shape == nil {
                self.reloadContentLayout()
            }

            view.setNeedsLayout()
            view.layoutIfNeeded()

            self.shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: view.layer.cornerRadius).cgPath
            self.shape.frame = self.bounds
            self.shape.cornerRadius = self.subviews.first!.layer.cornerRadius
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
            self.refreshView()
            self.renderManager.layoutSubviews()
        }

        override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            self.reloadContentLayout()
            self.renderManager.traitDidChange()
        }
    }
}

extension Views.DashedView: UICViewContent {

    @inlinable
    public func addContent(_ view: UIView) {
        CBSubview(self).addSubview(view)

        Constraintable.activate {
            view.cbuild
                .edges
        }

        self.view = view
    }

    public func reloadContentLayout() {
        self.shape = self.shape ?? self.createShape()

        self.shape.strokeColor = strokeColor.cgColor
        self.shape.lineWidth = self.lineWidth
        self.shape.lineDashPattern = self.dashPattern
    }
}

public extension Views.DashedView {

    @inlinable
    func apply(strokeColor: UIColor) -> Self {
        self.strokeColor = strokeColor
        return self
    }

    @inlinable
    func apply(lineWidth: CGFloat) -> Self {
        self.lineWidth = lineWidth
        return self
    }

    @inlinable
    func apply(dashPattern: [NSNumber]) -> Self {
        self.dashPattern = dashPattern
        return self
    }

    @inlinable
    func refresh() {
        self.reloadContentLayout()
    }
}
