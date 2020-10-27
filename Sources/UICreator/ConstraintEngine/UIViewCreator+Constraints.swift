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

extension UIView {
    var safeAreaCompatibleGuide: UILayoutGuide {
        if #available(iOS 11, tvOS 11, *) {
            return self.safeAreaLayoutGuide
        }

        return self.layoutMarginsGuide
    }
}

public extension UIViewCreator {
    func safeArea(
        topEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.safeArea(topEqualTo: value, priority: priority)
            .safeArea(bottomEqualTo: value, priority: priority)
            .safeArea(leadingEqualTo: value, priority: priority)
            .safeArea(trailingEqualTo: value, priority: priority)
    }

    func top(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
                    .width
                    .lessThanOrEqualTo(superview.cbuild.width)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            }
        }
    }
}

public extension UIViewCreator {
    func insets(
        equalTo value: CGFloat = .zero,
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.top(equalTo: value, priority: priority, toView: relatedView)
            .bottom(equalTo: value, priority: priority, toView: relatedView)
            .leading(equalTo: value, priority: priority, toView: relatedView)
            .trailing(equalTo: value, priority: priority, toView: relatedView)
    }
}

public extension UIViewCreator {
    func aspectRatio(
        equalTo multiplier: CGFloat = 1,
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.aspectRatio(heightEqualTo: multiplier, priority: priority)
    }

    func aspectRatio(
        heightEqualTo multiplier: CGFloat,
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.onNotRendered { view in
            let superview = view.dynamicView

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
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.onNotRendered { view in
            let superview = view.dynamicView

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
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.onNotRendered { view in
            let superview = view.dynamicView

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
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.onNotRendered { view in
            let superview = view.dynamicView

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
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.onNotRendered { view in
            let superview = view.dynamicView

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
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.onNotRendered { view in
            let superview = view.dynamicView

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

public extension UIViewCreator {
    func height(
        equalTo constant: CGFloat,
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.onNotRendered { view in
            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.onNotRendered { view in
            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.onNotRendered { view in
            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.onNotRendered { view in
            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.onNotRendered { view in
            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required) -> UICModifiedView<View> {

        self.onNotRendered { view in
            Constraintable.update {
                view.dynamicView.cbuild
                    .width
                    .lessThanOrEqual
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }
}

public extension UIViewCreator {
    func center(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
                    .centerY
                    .lessThanOrEqualTo(superview.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }
}

public extension UIViewCreator {
    func safeArea(
        centerEqualTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        orRelatedView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
                    .centerY
                    .lessThanOrEqualTo(superview.safeAreaCompatibleGuide.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }
}

public extension UIViewCreator {
    func hugging(
        vertical verticalPriority: CBLayoutPriority = .defaultLow,
        horizontal horizontalPriority: CBLayoutPriority = .defaultLow) -> UICModifiedView<View> {
        
        self.onNotRendered {
            $0.dynamicView
                .setContentHuggingPriority(
                    verticalPriority,
                    for: .vertical
                )
            
            $0.dynamicView
                .setContentHuggingPriority(
                    horizontalPriority,
                    for: .horizontal
                )
        }
    }
    
    func compression(
        vertical verticalPriority: CBLayoutPriority = .defaultHigh,
        horizontal horizontalPriority: CBLayoutPriority = .defaultHigh) -> UICModifiedView<View> {

        self.onNotRendered {
            $0.dynamicView
                .setContentCompressionResistancePriority(
                    verticalPriority,
                    for: .vertical
                )

            $0.dynamicView
                .setContentCompressionResistancePriority(
                    horizontalPriority,
                    for: .horizontal
                )
        }
    }

    func vertical(
        hugging huggingPriority: CBLayoutPriority = .defaultLow,
        compression compressionPriority: CBLayoutPriority = .defaultHigh) -> UICModifiedView<View> {

        self.onNotRendered {
            $0.dynamicView
                .setContentHuggingPriority(
                    huggingPriority,
                    for: .vertical
                )

            $0.dynamicView
                .setContentCompressionResistancePriority(
                    compressionPriority,
                    for: .vertical
                )
        }
    }

    func horizontal(
        hugging huggingPriority: CBLayoutPriority = .defaultLow,
        compression compressionPriority: CBLayoutPriority = .defaultHigh) -> UICModifiedView<View> {

        self.onNotRendered {
            $0.dynamicView
                .setContentHuggingPriority(
                    huggingPriority,
                    for: .horizontal
                )

            $0.dynamicView
                .setContentCompressionResistancePriority(
                    compressionPriority,
                    for: .horizontal
                )
        }
    }
}

public extension UIViewCreator {
    func topMargin(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
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
        priority: CBLayoutPriority = .required,
        toView relatedView: ConstraintRelatedView? = nil) -> UICModifiedView<View> {

        self.onInTheScene { view in
            guard let superview = relatedView?() ?? view.layoutSuperview else {
                return
            }

            Constraintable.update {
                view.dynamicView.cbuild
                    .trailing
                    .lessThanOrEqualTo(superview.layoutMarginsGuide.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            }
        }
    }
}
