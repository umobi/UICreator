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
import ConstraintBuilder
import UIKit

// swiftlint:disable file_length
extension UIView {
    fileprivate var realSuperview: UIView? {
        guard let superview = self.superview else {
            return nil
        }

        return sequence(first: superview, next: {
            (UIViewWrapper($0)?.safe ?? $0).superview })
            .first(where: {
                !($0 is ViewCreatorNoLayoutConstraints)
            }
        )
    }
}

extension UIView {
    var safeAreaCompatibleGuide: UILayoutGuide {
        if #available(iOS 11, tvOS 11, *) {
            return self.safeAreaLayoutGuide
        }

        return self.layoutMarginsGuide
    }
}

public extension ViewCreator {
    func safeArea(
        topEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .top
                    .equalTo(superview.safeAreaCompatibleGuide.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        topGreaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .top
                    .greaterThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        topLessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .top
                    .lessThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        bottomEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .bottom
                    .equalTo(superview.safeAreaCompatibleGuide.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        bottomGreaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .bottom
                    .greaterThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        bottomLessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .bottom
                    .lessThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        leadingEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .leading
                    .equalTo(superview.safeAreaCompatibleGuide.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        leadingGreaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .leading
                    .greaterThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        leadingLessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .leading
                    .lessThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        trailingEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .trailing
                    .equalTo(superview.safeAreaCompatibleGuide.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        trailingGreaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .trailing
                    .greaterThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        trailingLessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .trailing
                    .lessThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeAreaInsets(
        equalTo value: CGFloat = 0,
        priority: UILayoutPriority = .required) -> Self {

        return self.safeArea(topEqualTo: value, priority: priority)
            .safeArea(bottomEqualTo: value, priority: priority)
            .safeArea(leadingEqualTo: value, priority: priority)
            .safeArea(trailingEqualTo: value, priority: priority)
    }

    func top(
        equalTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .top
                    .equalTo(superview.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func top(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .top
                    .greaterThanOrEqualTo(superview.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func top(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .top
                    .lessThanOrEqualTo(superview.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func bottom(
        equalTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .bottom
                    .equalTo(superview.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func bottom(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .bottom
                    .greaterThanOrEqualTo(superview.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func bottom(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .bottom
                    .lessThanOrEqualTo(superview.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func leading(
        equalTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .leading
                    .equalTo(superview.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func leading(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .leading
                    .greaterThanOrEqualTo(superview.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func leading(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .leading
                    .lessThanOrEqualTo(superview.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func trailing(
        equalTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .trailing
                    .equalTo(superview.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func trailing(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .trailing
                    .greaterThanOrEqualTo(superview.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func trailing(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .trailing
                    .lessThanOrEqualTo(superview.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func height(
        equalToSuperview multiplier: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .height
                    .equalTo(superview.cbuild.height)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            }
        }
    }

    func height(
        greaterThanOrEqualToSuperview multiplier: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .height
                    .greaterThanOrEqualTo(superview.cbuild.height)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            }
        }
    }

    func height(
        lessThanOrEqualToSuperview multiplier: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .height
                    .lessThanOrEqualTo(superview.cbuild.height)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            }
        }
    }

    typealias ConstraintRelatedView = () -> UIView

    func width(
        equalToSuperview multiplier: CGFloat,
        priority: UILayoutPriority = .required,
        orView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .width
                    .equalTo(superview.cbuild.width)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            }
        }
    }

    func width(
        greaterThanOrEqualToSuperview multiplier: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .width
                    .greaterThanOrEqualTo(superview.cbuild.width)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            }
        }
    }

    func width(
        lessThanOrEqualToSuperview multiplier: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .width
                    .lessThanOrEqualTo(superview.cbuild.width)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            }
        }
    }
}

public extension ViewCreator {
    func insets(
        equalTo value: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.top(equalTo: value, priority: priority, toView: relatedView)
            .bottom(equalTo: value, priority: priority, toView: relatedView)
            .leading(equalTo: value, priority: priority, toView: relatedView)
            .trailing(equalTo: value, priority: priority, toView: relatedView)
    }
}

public extension ViewCreator {
    func aspectRatio(
        equalTo multiplier: CGFloat = 1,
        priority: UILayoutPriority = .required) -> Self {

        return self.aspectRatio(heightEqualTo: multiplier, priority: priority)
    }

    func aspectRatio(
        heightEqualTo multiplier: CGFloat,
        priority: UILayoutPriority = .required) -> Self {

        return self.onNotRendered { view in
            let superview = (UIViewWrapper(view)?.safe ?? view)

            Constraintable.update {
                view.cbuild
                    .height
                    .equalTo(superview.cbuild.width)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            }
        }
    }

    func aspectRatio(
        heightGreaterThanOrEqualTo multiplier: CGFloat,
        priority: UILayoutPriority = .required) -> Self {

        return self.onNotRendered { view in
            let superview = (UIViewWrapper(view)?.safe ?? view)

            Constraintable.update {
                view.cbuild
                    .height
                    .greaterThanOrEqualTo(superview.cbuild.width)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            }
        }
    }

    func aspectRatio(
        heightLessThanOrEqualTo multiplier: CGFloat,
        priority: UILayoutPriority = .required) -> Self {

        return self.onNotRendered { view in
            let superview = (UIViewWrapper(view)?.safe ?? view)

            Constraintable.update {
                view.cbuild
                    .height
                    .lessThanOrEqualTo(superview.cbuild.width)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            }
        }
    }

    func aspectRatio(
        widthEqualTo multiplier: CGFloat,
        priority: UILayoutPriority = .required) -> Self {

        return self.onNotRendered { view in
            let superview = (UIViewWrapper(view)?.safe ?? view)

            Constraintable.update {
                view.cbuild
                    .width
                    .equalTo(superview.cbuild.height)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            }
        }
    }

    func aspectRatio(
        widthGreaterThanOrEqualTo multiplier: CGFloat,
        priority: UILayoutPriority = .required) -> Self {

        return self.onNotRendered { view in
            let superview = (UIViewWrapper(view)?.safe ?? view)

            Constraintable.update {
                view.cbuild
                    .width
                    .greaterThanOrEqualTo(superview.cbuild.height)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            }
        }
    }

    func aspectRatio(
        widthLessThanOrEqualTo multiplier: CGFloat,
        priority: UILayoutPriority = .required) -> Self {

        return self.onNotRendered { view in
            let superview = (UIViewWrapper(view)?.safe ?? view)

            Constraintable.update {
                view.cbuild
                    .width
                    .lessThanOrEqualTo(superview.cbuild.height)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            }
        }
    }
}

public extension ViewCreator {
    func height(
        equalTo constant: CGFloat,
        priority: UILayoutPriority = .required) -> Self {

        return self.onNotRendered { view in
            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .height
                    .equal
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func height(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required) -> Self {

        return self.onNotRendered { view in
            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .height
                    .greaterThanOrEqual
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func height(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required) -> Self {

        return self.onNotRendered { view in
            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .height
                    .lessThanOrEqual
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func width(
        equalTo constant: CGFloat,
        priority: UILayoutPriority = .required) -> Self {

        return self.onNotRendered { view in
            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .width
                    .equal
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func width(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required) -> Self {

        return self.onNotRendered { view in
            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .width
                    .greaterThanOrEqual
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func width(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required) -> Self {

        return self.onNotRendered { view in
            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .width
                    .lessThanOrEqual
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }
}

public extension ViewCreator {
    func center(
        equalTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .center
                    .equalTo(superview.cbuild.center)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func center(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .center
                    .greaterThanOrEqualTo(superview.cbuild.center)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func center(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .center
                    .lessThanOrEqualTo(superview.cbuild.center)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func centerX(
        equalTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .centerX
                    .equalTo(superview.cbuild.centerX)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func centerX(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .centerX
                    .greaterThanOrEqualTo(superview.cbuild.centerX)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func centerX(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .centerX
                    .lessThanOrEqualTo(superview.cbuild.centerX)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func centerY(
        equalTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .centerY
                    .equalTo(superview.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func centerY(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .centerY
                    .greaterThanOrEqualTo(superview.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func centerY(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .centerY
                    .lessThanOrEqualTo(superview.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }
}

public extension ViewCreator {
    func safeArea(
        centerEqualTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .center
                    .equalTo(superview.safeAreaCompatibleGuide.cbuild.center)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        centerGreaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .center
                    .greaterThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.center)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        centerLessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .center
                    .lessThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.center)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        centerXEqualTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .centerX
                    .equalTo(superview.safeAreaCompatibleGuide.cbuild.centerX)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        centerXGreaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .centerX
                    .greaterThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.centerX)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        centerXLessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .centerX
                    .lessThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.centerX)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        centerYEqualTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .centerY
                    .equalTo(superview.safeAreaCompatibleGuide.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        centerYGreaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .centerY
                    .greaterThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(
        centerYLessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .centerY
                    .lessThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }
}

public extension ViewCreator {
    func hugging(
        vertical verticalPriority: UILayoutPriority = .defaultLow,
        horizontal horizontalPriority: UILayoutPriority = .defaultLow) -> Self {

        return self.onNotRendered {
            (UIViewWrapper($0)?.safe ?? $0)
                .setContentHuggingPriority(
                    verticalPriority,
                    for: .vertical
            )

            (UIViewWrapper($0)?.safe ?? $0)
                .setContentHuggingPriority(
                    horizontalPriority,
                    for: .horizontal
            )
        }
    }

    func compression(
        vertical verticalPriority: UILayoutPriority = .defaultHigh,
        horizontal horizontalPriority: UILayoutPriority = .defaultHigh) -> Self {

        return self.onNotRendered {
            (UIViewWrapper($0)?.safe ?? $0)
                .setContentCompressionResistancePriority(
                    verticalPriority,
                    for: .vertical
            )

            (UIViewWrapper($0)?.safe ?? $0)
                .setContentCompressionResistancePriority(
                    horizontalPriority,
                    for: .horizontal
            )
        }
    }

    func vertical(
        hugging huggingPriority: UILayoutPriority = .defaultLow,
        compression compressionPriority: UILayoutPriority = .defaultHigh) -> Self {

        return self.onNotRendered {
            (UIViewWrapper($0)?.safe ?? $0)
                .setContentHuggingPriority(
                    huggingPriority,
                    for: .vertical
            )
            (UIViewWrapper($0)?.safe ?? $0)
                .setContentCompressionResistancePriority(
                    compressionPriority,
                    for: .vertical
            )
        }
    }

    func horizontal(
        hugging huggingPriority: UILayoutPriority = .defaultLow,
        compression compressionPriority: UILayoutPriority = .defaultHigh) -> Self {

        return self.onNotRendered {
            (UIViewWrapper($0)?.safe ?? $0)
                .setContentHuggingPriority(
                    huggingPriority,
                    for: .horizontal
            )

            (UIViewWrapper($0)?.safe ?? $0)
                .setContentCompressionResistancePriority(
                    compressionPriority,
                    for: .horizontal
            )
        }
    }
}

public extension ViewCreator {
    func topMargin(
        equalTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .top
                    .equalTo(superview.layoutMarginsGuide.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func topMargin(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .top
                    .greaterThanOrEqualTo(superview.layoutMarginsGuide.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func topMargin(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .top
                    .lessThanOrEqualTo(superview.layoutMarginsGuide.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func bottomMargin(
        equalTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .bottom
                    .equalTo(superview.layoutMarginsGuide.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func bottomMargin(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .bottom
                    .greaterThanOrEqualTo(superview.layoutMarginsGuide.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func bottomMargin(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .bottom
                    .lessThanOrEqualTo(superview.layoutMarginsGuide.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func leadingMargin(
        equalTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .leading
                    .equalTo(superview.layoutMarginsGuide.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func leadingMargin(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .leading
                    .greaterThanOrEqualTo(superview.layoutMarginsGuide.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func leadingMargin(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .leading
                    .lessThanOrEqualTo(superview.layoutMarginsGuide.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func trailingMargin(
        equalTo constant: CGFloat = 0,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .trailing
                    .equalTo(superview.layoutMarginsGuide.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func trailingMargin(
        greaterThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .trailing
                    .greaterThanOrEqualTo(superview.layoutMarginsGuide.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }

    func trailingMargin(
        lessThanOrEqualTo constant: CGFloat,
        priority: UILayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> Self {

        return self.onInTheScene { view in
            guard let superview = relatedView?() ?? (UIViewWrapper(view)?.safe ?? view).realSuperview else {
                return
            }

            Constraintable.update {
                (UIViewWrapper(view)?.safe ?? view).cbuild
                    .trailing
                    .lessThanOrEqualTo(superview.layoutMarginsGuide.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }
}
