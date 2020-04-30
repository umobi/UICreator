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

public class UICDashedView: UIView, UICManagerContentView {

    weak var view: UIView?
    private(set) var strokeColor: UIColor = .clear
    private(set) var lineWidth: CGFloat = 1
    private(set) var dashPattern: [NSNumber]

    private var shape: CAShapeLayer!

    public required init(_ view: UIView, dash pattern: [NSNumber]) {
        self.dashPattern = pattern
        super.init(frame: .zero)
        self.addContent(view)
    }

    public required init(dash pattern: [NSNumber]) {
        self.dashPattern = pattern
        super.init(frame: .zero)
    }

    public func addContent(_ view: UIView) {
        CBSubview(self).addSubview(view)

        Constraintable.activate(
            view.cbuild
                .edges
        )

        self.view = view
    }

    public func reloadContentLayout() {
        self.shape = self.shape ?? self.createShape()

        self.shape.strokeColor = strokeColor.cgColor
        self.shape.lineWidth = self.lineWidth
        self.shape.lineDashPattern = self.dashPattern
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    func refreshView() {
        guard let view = self.view else {
            return
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
            RenderManager(self)?.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            RenderManager(self)?.frame(newValue)
        }
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self)?.willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self)?.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self)?.didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.refreshView()
        RenderManager(self)?.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.reloadContentLayout()
        RenderManager(self)?.traitDidChange()
    }
}

public extension UICDashedView {

    func apply(strokeColor: UIColor) -> Self {
        self.strokeColor = strokeColor
        return self
    }

    func apply(lineWidth: CGFloat) -> Self {
        self.lineWidth = lineWidth
        return self
    }

    func apply(dashPattern: [NSNumber]) -> Self {
        self.dashPattern = dashPattern
        return self
    }

    func refresh() {
        self.reloadContentLayout()
    }
}

public class UICDashed: UIViewCreator {
    public typealias View = UICDashedView

    public init(color: UIColor, pattern: [NSNumber] = [2, 3], content: @escaping () -> ViewCreator) {
        let content = content()
        self.tree.append(content)

        self.onNotRendered {
            ($0 as? View)?.addContent(content.releaseUIView())
        }
        .dash(color: color)
        .dash(lineWidth: 1)
        .loadView { [unowned self] in
            let view = View.init(dash: pattern)
            view.updateBuilder(self)
            return view
        }
    }
}

extension UIViewCreator where View: UICDashedView {

    public func dash(color: UIColor) -> Self {
        self.onNotRendered {
            ($0 as? View)?.apply(strokeColor: color)
                .refresh()
        }
    }

    public func dash(lineWidth width: CGFloat) -> Self {
        self.onNotRendered {
            ($0 as? View)?.apply(lineWidth: width)
                .refresh()
        }
    }

    public func dash(pattern: [NSNumber]) -> Self {
        self.onNotRendered {
            _ = ($0 as? View)?.apply(dashPattern: pattern)
                .refresh()
        }
    }
}
