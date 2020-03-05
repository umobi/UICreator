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
import EasyAnchor

extension UIView {
    fileprivate var realSuperview: UIView? {
        guard let superview = self.superview else {
            return nil
        }

        return sequence(first: superview, next: { $0.superview }).first(where: {
            !($0 is RootView)
        })
    }
}

extension Anchor {
    class ConstraintFinalize {
        private var constraint: NSLayoutConstraint?
        private var anchor: Anchor

        init(original: Anchor, _ constraint: NSLayoutConstraint) {
            self.constraint = constraint
            self.anchor = original
        }

        init(_ anchor: Anchor) {
            self.constraint = nil
            self.anchor = anchor
        }

        private func activateIfNeeded() {
            if let constraint = self.constraint {
                if !constraint.isActive {
                    NSLayoutConstraint.activate([constraint])
                }
            } else {
                activate(anchor)
            }
        }

        func constant(_ constant: CGFloat) -> Self {
            self.constraint?.constant = constant
            self.anchor = self.anchor.constant(constant)
            return self
        }

        func multiplier(_ multiplier: CGFloat) -> Self {
            NSLayoutConstraint.deactivate([self.constraint].compactMap { $0 })
            self.constraint = nil
            self.anchor = self.anchor.multiplier(multiplier)
            return self
        }

        func priority(_ priority: UILayoutPriority) -> Self {
            self.constraint?.priority = priority
            self.anchor = self.anchor.priority(priority.rawValue)
            return self
        }

        func priority(_ priority: Float) -> Self {
            self.constraint?.priority = .init(priority)
            self.anchor = self.anchor.priority(priority)
            return self
        }

        deinit {
            self.activateIfNeeded()
        }
    }

    func orCreate() -> ConstraintFinalize {
        if let constraint = self.findByContent().first {
            let finalize = ConstraintFinalize(original: self, constraint)
            return finalize
        }

        return .init(self)
    }
}

public extension ViewCreator {
    func safeArea(topEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.anchor
                    .top
                    .equal.to(view.safeAreaLayoutGuide.anchor.topMargin)
                    .orCreate()
                    .constant(constant)
                    .priority(priority)
                return
            }

            $0.anchor
                .top
                .equal.to(view.anchor.topMargin)
                .orCreate()
                .constant(constant)
                .priority(priority)
        }
    }

    func safeArea(topGreaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.anchor
                    .top
                    .greaterThanOrEqual.to(view.safeAreaLayoutGuide.anchor.topMargin)
                    .orCreate()
                    .constant(constant)
                    .priority(priority.rawValue)
                return
            }

            $0.anchor
                .top
                .greaterThanOrEqual.to(view.anchor.topMargin)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func safeArea(topLessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.anchor
                    .top
                    .lessThanOrEqual.to(view.anchor.topMargin)
                    .orCreate()
                    .constant(constant)
                    .priority(priority.rawValue)
                return
            }

            $0.anchor
                .top
                .lessThanOrEqual.to(view.anchor.topMargin)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func safeArea(bottomEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.anchor
                    .bottom
                    .equal.to(view.safeAreaLayoutGuide.anchor.bottomMargin)
                    .orCreate()
                    .constant(-constant)
                    .priority(priority.rawValue)
                return
            }

            $0.anchor
                .bottom
                .equal.to(view.anchor.bottomMargin)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func safeArea(bottomGreaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.anchor
                    .bottom
                    .greaterThanOrEqual.to(view.safeAreaLayoutGuide.anchor.bottomMargin)
                    .orCreate()
                    .constant(-constant)
                    .priority(priority.rawValue)
                return
            }

            $0.anchor
                .bottom
                .greaterThanOrEqual.to(view.anchor.bottomMargin)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func safeArea(bottomLessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.anchor
                    .bottom
                    .lessThanOrEqual.to(view.safeAreaLayoutGuide.anchor.bottomMargin)
                    .orCreate()
                    .constant(-constant)
                    .priority(priority.rawValue)
                return
            }

            $0.anchor
                .bottom
                .lessThanOrEqual.to(view.anchor.bottomMargin)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func safeArea(leadingEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.anchor
                    .leading
                    .equal.to(view.safeAreaLayoutGuide.anchor.leadingMargin)
                    .orCreate()
                    .constant(constant)
                    .priority(priority.rawValue)
                return
            }

            $0.anchor
                .leading
                .equal.to(view.anchor.leadingMargin)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func safeArea(leadingGreaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.anchor
                    .leading
                    .greaterThanOrEqual.to(view.safeAreaLayoutGuide.anchor.leadingMargin)
                    .orCreate()
                    .constant(constant)
                    .priority(priority.rawValue)
                return
            }

            $0.anchor
                .leading
                .greaterThanOrEqual.to(view.anchor.leadingMargin)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func safeArea(leadingLessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.anchor
                    .leading
                    .lessThanOrEqual.to(view.safeAreaLayoutGuide.anchor.leadingMargin)
                    .orCreate()
                    .constant(constant)
                    .priority(priority.rawValue)
                return
            }

            $0.anchor
                .leading
                .lessThanOrEqual.to(view.anchor.leadingMargin)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func safeArea(trailingEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.anchor
                    .trailing
                    .equal.to(view.safeAreaLayoutGuide.anchor.trailingMargin)
                    .orCreate()
                    .constant(-constant)
                    .priority(priority.rawValue)
                return
            }

            $0.anchor
                .trailing
                .equal.to(view.anchor.trailingMargin)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func safeArea(trailingGreaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.anchor
                    .trailing
                    .greaterThanOrEqual.to(view.safeAreaLayoutGuide.anchor.trailingMargin)
                    .orCreate()
                    .constant(-constant)
                    .priority(priority.rawValue)
                return
            }

            $0.anchor
                .trailing
                .greaterThanOrEqual.to(view.anchor.trailingMargin)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func safeArea(trailingLessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.anchor
                    .trailing
                    .lessThanOrEqual.to(view.safeAreaLayoutGuide.anchor.trailingMargin)
                    .orCreate()
                    .constant(-constant)
                    .priority(priority.rawValue)
                return
            }

            $0.anchor
                .trailing
                .lessThanOrEqual.to(view.anchor.trailingMargin)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func safeAreaInsets(equalTo value: CGFloat = 0, priority: UILayoutPriority = .required) -> Self {
        return self.safeArea(topEqualTo: value, priority: priority)
            .safeArea(bottomEqualTo: value, priority: priority)
            .safeArea(leadingEqualTo: value, priority: priority)
            .safeArea(trailingEqualTo: value, priority: priority)
    }

    func top(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .top
                .equal.to(view.anchor.top)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func top(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .top
                .greaterThanOrEqual.to(view.anchor.top)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func top(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .top
                .lessThanOrEqual.to(view.anchor.top)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func bottom(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .bottom
                .equal.to(view.anchor.bottom)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func bottom(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .bottom
                .greaterThanOrEqual.to(view.anchor.bottom)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func bottom(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .bottom
                .lessThanOrEqual.to(view.anchor.bottom)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func leading(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .leading
                .equal.to(view.anchor.leading)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func leading(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .leading
                .greaterThanOrEqual.to(view.anchor.leading)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func leading(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .leading
                .lessThanOrEqual.to(view.anchor.leading)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func trailing(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .trailing
                .equal.to(view.anchor.trailing)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func trailing(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .trailing
                .greaterThanOrEqual.to(view.anchor.trailing)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func trailing(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .trailing
                .lessThanOrEqual.to(view.anchor.trailing)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func height(equalToSuperview multiplier: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .height
                .equal.to(view.anchor.height)
                .orCreate()
                .multiplier(multiplier)
                .priority(priority.rawValue)
        }
    }

    func height(greaterThanOrEqualToSuperview multiplier: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .height
                .greaterThanOrEqual.to(view.anchor.height)
                .orCreate()
                .multiplier(multiplier)
                .priority(priority.rawValue)
        }
    }

    func height(lessThanOrEqualToSuperview multiplier: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .height
                .lessThanOrEqual.to(view.anchor.height)
                .orCreate()
                .multiplier(multiplier)
                .priority(priority.rawValue)
        }
    }

    func width(equalToSuperview multiplier: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .width
                .equal.to(view.anchor.width)
                .orCreate()
                .multiplier(multiplier)
                .priority(priority.rawValue)
        }
    }

    func width(greaterThanOrEqualToSuperview multiplier: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .width
                .greaterThanOrEqual.to(view.anchor.width)
                .orCreate()
                .multiplier(multiplier)
                .priority(priority.rawValue)
        }
    }

    func width(lessThanOrEqualToSuperview multiplier: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .width
                .lessThanOrEqual.to(view.anchor.width)
                .orCreate()
                .multiplier(multiplier)
                .priority(priority.rawValue)
        }
    }
}

public extension ViewCreator {
    func insets(equalTo value: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.top(equalTo: value, priority: priority, toView: view)
            .bottom(equalTo: value, priority: priority, toView: view)
            .leading(equalTo: value, priority: priority, toView: view)
            .trailing(equalTo: value, priority: priority, toView: view)
    }
}

public extension ViewCreator {
    func aspectRatio(equalTo multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> Self {
        return self.aspectRatio(heightEqualTo: multiplier, priority: priority)
    }

    func aspectRatio(heightEqualTo multiplier: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered { view in
            view.anchor
                .height
                .equal.to(view.anchor.width)
                .orCreate()
                .multiplier(multiplier)
                .priority(priority.rawValue)
        }
    }

    func aspectRatio(heightGreaterThanOrEqualTo multiplier: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered { view in
            view.anchor
                .height
                .greaterThanOrEqual.to(view.anchor.width)
                .orCreate()
                .multiplier(multiplier)
                .priority(priority.rawValue)
        }
    }

    func aspectRatio(heightLessThanOrEqualTo multiplier: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered { view in
            view.anchor
                .height
                .lessThanOrEqual.to(view.anchor.width)
                .orCreate()
                .multiplier(multiplier)
                .priority(priority.rawValue)
        }
    }

    func aspectRatio(widthEqualTo multiplier: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered { view in
            view.anchor
                .width
                .equal.to(view.anchor.height)
                .orCreate()
                .multiplier(multiplier)
                .priority(priority.rawValue)
        }
    }

    func aspectRatio(widthGreaterThanOrEqualTo multiplier: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered { view in
            view.anchor
                .width
                .greaterThanOrEqual.to(view.anchor.height)
                .orCreate()
                .multiplier(multiplier)
                .priority(priority.rawValue)
        }
    }

    func aspectRatio(widthLessThanOrEqualTo multiplier: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered { view in
            view.anchor
                .width
                .lessThanOrEqual.to(view.anchor.height)
                .orCreate()
                .multiplier(multiplier)
                .priority(priority.rawValue)
        }
    }
}

public extension ViewCreator {
    func height(equalTo constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            $0.anchor
                .height
                .equal.to(constant)
                .orCreate()
                .priority(priority.rawValue)
        }
    }

    func height(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            $0.anchor
                .height
                .greaterThanOrEqual.to(constant)
                .orCreate()
                .priority(priority.rawValue)
        }
    }

    func height(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            $0.anchor
                .height
                .lessThanOrEqual.to(constant)
                .orCreate()
                .priority(priority.rawValue)
        }
    }

    func width(equalTo constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            $0.anchor
                .width
                .equal.to(constant)
                .orCreate()
                .priority(priority.rawValue)
        }
    }

    func width(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            $0.anchor
                .width
                .greaterThanOrEqual.to(constant)
                .orCreate()
                .priority(priority.rawValue)
        }
    }

    func width(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            $0.anchor
                .width
                .lessThanOrEqual.to(constant)
                .orCreate()
                .priority(priority.rawValue)
        }
    }
}

public extension ViewCreator {
    func center(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .center
                .equal.to(view.anchor.center)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func center(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .center
                .greaterThanOrEqual.to(view.anchor.center)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func center(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .center
                .lessThanOrEqual.to(view.anchor.center)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func centerX(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .centerX
                .equal.to(view.anchor.centerX)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func centerX(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .centerX
                .greaterThanOrEqual.to(view.anchor.centerX)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func centerX(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .centerX
                .lessThanOrEqual.to(view.anchor.centerX)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func centerY(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .centerY
                .equal.to(view.anchor.centerY)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func centerY(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .centerY
                .greaterThanOrEqual.to(view.anchor.centerY)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func centerY(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .centerY
                .lessThanOrEqual.to(view.anchor.centerY)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }
}

public extension ViewCreator {
    func hugging(vertical verticalPriority: UILayoutPriority = .defaultLow, horizontal horizontalPriority: UILayoutPriority = .defaultLow) -> Self {
        return self.onNotRendered {
            $0.setContentHuggingPriority(verticalPriority, for: .vertical)
            $0.setContentHuggingPriority(horizontalPriority, for: .horizontal)
        }
    }

    func compression(vertical verticalPriority: UILayoutPriority = .defaultHigh, horizontal horizontalPriority: UILayoutPriority = .defaultHigh) -> Self {
        return self.onNotRendered {
            $0.setContentCompressionResistancePriority(verticalPriority, for: .vertical)
            $0.setContentCompressionResistancePriority(horizontalPriority, for: .horizontal)
        }
    }

    func vertical(hugging huggingPriority: UILayoutPriority = .defaultLow, compression compressionPriority: UILayoutPriority = .defaultHigh) -> Self {
        return self.onNotRendered {
            $0.setContentHuggingPriority(huggingPriority, for: .vertical)
            $0.setContentCompressionResistancePriority(compressionPriority, for: .vertical)
        }
    }

    func horizontal(hugging huggingPriority: UILayoutPriority = .defaultLow, compression compressionPriority: UILayoutPriority = .defaultHigh) -> Self {
        return self.onNotRendered {
            $0.setContentHuggingPriority(huggingPriority, for: .horizontal)
            $0.setContentCompressionResistancePriority(compressionPriority, for: .horizontal)
        }
    }
}

public extension ViewCreator {
    func topMargin(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .top
                .equal.to(view.anchor.topMargin)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func topMargin(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .top
                .greaterThanOrEqual.to(view.anchor.topMargin)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func topMargin(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .top
                .lessThanOrEqual.to(view.anchor.topMargin)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func bottomMargin(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .bottom
                .equal.to(view.anchor.bottomMargin)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func bottomMargin(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .bottom
                .greaterThanOrEqual.to(view.anchor.bottomMargin)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func bottomMargin(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .bottom
                .lessThanOrEqual.to(view.anchor.bottomMargin)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func leadingMargin(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .leading
                .equal.to(view.anchor.leadingMargin)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func leadingMargin(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .leading
                .greaterThanOrEqual.to(view.anchor.leadingMargin)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func leadingMargin(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .leading
                .lessThanOrEqual.to(view.anchor.leadingMargin)
                .orCreate()
                .constant(constant)
                .priority(priority.rawValue)
        }
    }

    func trailingMargin(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .trailing
                .equal.to(view.anchor.trailingMargin)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func trailingMargin(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .trailing
                .greaterThanOrEqual.to(view.anchor.trailingMargin)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }

    func trailingMargin(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.anchor
                .trailing
                .lessThanOrEqual.to(view.anchor.trailingMargin)
                .orCreate()
                .constant(-constant)
                .priority(priority.rawValue)
        }
    }
}

public enum Margin: CaseIterable {
    case top
    case bottom
    case leading
    case trailing
}

public extension ViewCreator {
    func safeArea(priority: UILayoutPriority = .required,_ margins: Margin..., equalTo value: CGFloat = 0) -> Self {
        Set(margins.isEmpty ? Margin.allCases : margins).reduce(self) {
            switch $1 {
            case .top:
                return self.safeArea(topEqualTo: value, priority: priority)
            case .bottom:
                return self.safeArea(bottomEqualTo: value, priority: priority)
            case .leading:
                return self.safeArea(leadingEqualTo: value, priority: priority)
            case .trailing:
                return self.safeArea(trailingEqualTo: value, priority: priority)
            }
        }
    }

    func insets(priority: UILayoutPriority = .required,_ margins: Margin..., equalTo value: CGFloat = 0) -> Self {
        Set(margins.isEmpty ? Margin.allCases : margins).reduce(self) {
            switch $1 {
            case .top:
                return self.top(equalTo: value, priority: priority)
            case .bottom:
                return self.bottom(equalTo: value, priority: priority)
            case .leading:
                return self.leading(equalTo: value, priority: priority)
            case .trailing:
                return self.trailing(equalTo: value, priority: priority)
            }
        }
    }

    func margin(priority: UILayoutPriority = .required,_ margins: Margin..., equalTo value: CGFloat = 0) -> Self {
        Set(margins.isEmpty ? Margin.allCases : margins).reduce(self) {
            switch $1 {
            case .top:
                return self.topMargin(equalTo: value, priority: priority)
            case .bottom:
                return self.bottomMargin(equalTo: value, priority: priority)
            case .leading:
                return self.leadingMargin(equalTo: value, priority: priority)
            case .trailing:
                return self.trailingMargin(equalTo: value, priority: priority)
            }
        }
    }
}
