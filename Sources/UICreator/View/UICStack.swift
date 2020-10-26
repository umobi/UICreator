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

public class StackView: UIStackView {

    public enum Axis {
        case vertical
        case horizontal

        var uiAxis: NSLayoutConstraint.Axis {
            switch self {
            case .horizontal:
                return .horizontal
            case .vertical:
                return .vertical
            }
        }
    }

    init() {
        super.init(frame: .zero)
        self.makeSelfImplemented()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
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

public struct UICStack: UIViewCreator {
    public typealias View = StackView

    @Relay var axis: View.Axis
    @Relay var spacing: CGFloat
    let content: () -> ViewCreator

    public init(
        axis: Relay<View.Axis>,
        spacing: CGFloat = .zero,
        @UICViewBuilder _ content: @escaping () -> ViewCreator) {

        self._axis = axis
        self.content = content
        self._spacing = .constant(spacing)
    }

    public init(
        axis: Relay<View.Axis>,
        spacing: Relay<CGFloat>,
        @UICViewBuilder _ content: @escaping () -> ViewCreator) {

        self._axis = axis
        self.content = content
        self._spacing = spacing
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return StackView()
            .onNotRendered {
                weak var view = $0 as? View

                _self.$axis.sync {
                    view?.axis = $0.uiAxis
                }
            }
            .onNotRendered {
                weak var view = $0 as? View

                _self.$spacing.sync {
                    view?.spacing = $0
                }
            }
            .onNotRendered {
                weak var view: View! = $0 as? View

                _self.content().zip.forEach {
                    if let forEachShared = $0 as? ForEachEnviromentShared {
                        let stackManager = StackManager(view)
                        view.strongStackManager(stackManager)
                        forEachShared.enviroment.setManager(stackManager)
                    }

                    UIView.CBSubview(view).addArrangedSubview($0.releaseUIView())
                }
            }
    }
}

public extension UIViewCreator where View: UIStackView {

    func distribution(_ distribution: View.Distribution) -> UICModifiedView<View> {
        return self.onNotRendered {
            ($0 as? View)?.distribution = distribution
        }
    }

    func alignment(_ alignment: View.Alignment) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.alignment = alignment
        }
    }
}

internal class StackManager: SupportForEach {
    private weak var stackView: UIStackView!

    @WeakBox var firstView: UIView!
    @WeakBox var lastView: UIView!

    init(_ stackView: UIStackView) {
        self.stackView = stackView
    }

    func viewsDidChange(_ placeholderView: UIView!, _ dynamicContent: Relay<[() -> ViewCreator]>) {
        self.firstView = placeholderView
        self.lastView = placeholderView

        dynamicContent.map {
            $0.map { $0().releaseUIView() }
        }.sync { views in
            DispatchQueue.main.async { [unowned self] in
                guard let stackView = stackView else {
                    return
                }

                let startIndex = stackView.arrangedSubviews.enumerated().first(where: {
                    $0.element === firstView
                })?.offset ?? 0

                let endIndex = stackView.arrangedSubviews.enumerated().first(where: {
                    $0.element === lastView
                })?.offset ?? 0

                if firstView != nil {
                    stackView.arrangedSubviews[startIndex...endIndex].forEach {
                        $0.removeFromSuperview()
                    }
                }

                views.enumerated().forEach {
                    UIView.CBSubview(stackView).insertArrangedSubview(
                        $0.element,
                        at: startIndex + $0.offset
                    )
                }

                firstView = views.first
                lastView = views.last
            }
//            OperationQueue.main.addOperation {

//            }
        }
    }
}
