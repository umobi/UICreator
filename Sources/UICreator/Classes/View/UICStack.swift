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
import UIContainer

public class StackView: UIStackView {

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
        RenderManager(self)?.layoutSubviews()
    }
}

public class UICStack: UIViewCreator {
    public typealias View = StackView

    private func prepare(axis: NSLayoutConstraint.Axis, spacing: CGFloat, _ content: @escaping () -> [ViewCreator]) {
        let content = content()
        content.forEach {
            self.tree.append($0)
        }

        self.loadView { [unowned self] in
            View.init(builder: self)
        }
        .onNotRendered {
            ($0 as? View)?.axis = axis
            ($0 as? View)?.spacing = spacing
        }
        .onNotRendered { view in
            content.forEach {
                if let forEachCreator = $0 as? ForEachCreator {
                    forEachCreator.manager = self
                }

                AddSubview(view as? View)?.addArrangedSubview($0.releaseUIView())
            }
        }
    }

    public init(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0,_ contents: @escaping () -> [ViewCreator]) {
        self.prepare(axis: axis, spacing: spacing, contents)
    }
}

public func UICHStack(spacing: CGFloat = 0, _ contents: @escaping () -> [ViewCreator]) -> UICStack {
    return .init(axis: .horizontal, spacing: spacing, contents)
}

public func UICVStack(spacing: CGFloat = 0, _ contents: @escaping () -> [ViewCreator]) -> UICStack {
    return .init(axis: .vertical, spacing: spacing, contents)
}

public extension UIViewCreator where View: UIStackView {

    func spacing(_ constant: CGFloat) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.spacing = constant
        }
    }

    func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.axis = axis
        }
    }

    func distribution(_ distribution: View.Distribution) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.distribution = distribution
        }
    }

    func alignment(_ alignment: View.Alignment) -> Self {
        self.onNotRendered {
            ($0 as? View)?.alignment = alignment
        }
    }
}

extension UICStack: SupportForEach {
    private func newViewsDidChange(placeholderView: UIView!, _ sequence: Relay<[() -> ViewCreator]>) {
        self.onRendered { [sequence, weak placeholderView] in
            weak var firstView: UIView? = placeholderView
            weak var lastView: UIView? = placeholderView

            weak var view = $0 as? View
            sequence.map {
                $0.map { $0() }
            }.sync { views in
                let startIndex = view?.arrangedSubviews.enumerated().first(where: {
                    $0.element == firstView
                })?.offset ?? 0
                let endIndex = view?.arrangedSubviews.enumerated().first(where: {
                    $0.element == lastView
                })?.offset ?? 0

                if firstView != nil {
                    if (startIndex + views.count) <= endIndex {
                        view?.arrangedSubviews[(startIndex + views.count)...endIndex].forEach {
                            $0.removeFromSuperview()
                        }
                    }
                }

                views.enumerated().forEach { newView in
                    guard newView.offset <= endIndex - startIndex, let viewCreator = view?.arrangedSubviews[startIndex..<(view?.arrangedSubviews ?? []).count].enumerated().first(where: { $0.offset == newView.offset })?.element.viewCreator else {
                        AddSubview(view)?.insertArrangedSubview(newView.element.releaseUIView(), at: startIndex + newView.offset)
                        return
                    }

                    if !ReplacementTree(viewCreator).replace(with: newView.element) {
                        (view?.arrangedSubviews ?? [])[startIndex + newView.offset].removeFromSuperview()
                        AddSubview(view)?.insertArrangedSubview(newView.element.releaseUIView(), at: startIndex + newView.offset)
                    }
                }

                firstView = views.first?.uiView
                lastView = views.last?.uiView
            }
        }
    }
    
    func viewsDidChange(placeholderView: UIView!, _ sequence: Relay<[() -> ViewCreator]>) {
        self.onRendered { [sequence, weak placeholderView] in
            weak var firstView: UIView? = placeholderView
            weak var lastView: UIView? = placeholderView

            weak var view = $0 as? View
            sequence.map {
                $0.map { $0() }
            }.sync { views in
                let startIndex = view?.arrangedSubviews.enumerated().first(where: {
                    $0.element == firstView
                })?.offset ?? 0
                let endIndex = view?.arrangedSubviews.enumerated().first(where: {
                    $0.element == lastView
                })?.offset ?? 0

                if firstView != nil {
                    view?.arrangedSubviews[startIndex...endIndex].forEach {
                        $0.removeFromSuperview()
                    }
                }

                views.enumerated().forEach {
                    AddSubview(view)?.insertArrangedSubview($0.element.releaseUIView(), at: startIndex + $0.offset)
                }

                firstView = views.first?.uiView
                lastView = views.last?.uiView
            }
        }
    }
}
