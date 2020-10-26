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

public class GradientView: UIView {
    fileprivate let gradientLayer = CAGradientLayer()

    public var direction: Direction = .right {
        didSet {
            self.setupGradientLayer()
        }
    }

    public var colors: [UIColor] = [] {
        didSet {
            self.setupGradientLayer()
        }
    }

    init() {
        super.init(frame: .zero)
        self.makeSelfImplemented()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    var locations: [NSNumber] {
        guard self.colors.count > 1 else {
            return [0]
        }

        let lastIndex = self.colors.count - 1

        let points = self.direction.points
        let distance = points.0.distance(to: points.1)

        return self.colors.enumerated().map { color in
            return NSNumber(value: {
                let location = Double(color.offset) / Double(lastIndex)
                return location * Double(distance)
                }() as Double)
        }
    }

    private func setupGradientLayer() {
        if !(self.layer.sublayers ?? []).contains(where: { $0 === self.gradientLayer }) {
            self.layer.addSublayer(self.gradientLayer)
        }

        gradientLayer.frame = bounds

        gradientLayer.locations = self.locations
        gradientLayer.colors = self.colors.map { $0.cgColor }
        gradientLayer.startPoint = self.direction.points.0
        gradientLayer.endPoint = self.direction.points.1
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
        gradientLayer.frame = self.bounds
        self.renderManager.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupGradientLayer()
        self.renderManager.traitDidChange()
    }
}

public extension GradientView {
    enum Direction {
        case top
        case bottom
        case left
        case right
        case other(CGPoint, CGPoint)

        var points: (CGPoint, CGPoint) {
            switch self {
            case .top:
                return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1.0))
            case .bottom:
                return (CGPoint(x: 0, y: 1.0), CGPoint(x: 0, y: 0))
            case .left:
                return (CGPoint(x: 1.0, y: 0), CGPoint(x: 0, y: 0))
            case .right:
                return (CGPoint(x: 0.0, y: 0), CGPoint(x: 1.0, y: 0))
            case .other(let fromPoint, let toPoint):
                return (fromPoint, toPoint)
            }
        }
    }
}

public extension GradientView {
    // swiftlint:disable identifier_name
    static func Linear(colors: [UIColor], direction: Direction) -> UICGradient.View {
        let gradient = UICGradient.View()
        gradient.colors = colors
        gradient.direction = direction
        return gradient
    }

    func animates(animator handler: (CAGradientLayer) -> Void) {
        handler(self.gradientLayer)
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}

public struct UICGradient: UIViewCreator {
    public typealias View = GradientView

    private let colors: [UIColor]
    private let direction: View.Direction

    public init(_ colors: [UIColor], direction: View.Direction = .right) {
        self.colors = colors
        self.direction = direction
    }

    public init(_ colors: UIColor..., direction: View.Direction = .right) {
        self.colors = colors
        self.direction = direction
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return GradientView()
            .onNotRendered {
                ($0 as? View)?.direction = _self.direction
                ($0 as? View)?.colors = _self.colors
            }
    }
}

public extension UIViewCreator where View: GradientView {

    func animation(_ layerHandler: @escaping (CAGradientLayer) -> Void) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.animates(animator: layerHandler)
        }
    }
}
