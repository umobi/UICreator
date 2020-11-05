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

extension CBView {
    @usableFromInline
    var safeAreaCompatibleGuide: UILayoutGuide {
        if #available(iOS 11, tvOS 11, *) {
            return self.safeAreaLayoutGuide
        }

        return self.layoutMarginsGuide
    }
}

public extension UIViewCreator {

    @inlinable
    func safeArea<OtherView>(
        topEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        topGreaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        topLessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        bottomEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        bottomGreaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        bottomLessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        leadingEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        leadingGreaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        leadingLessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        trailingEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        trailingGreaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        trailingLessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inline(__always) @inlinable
    func safeAreaInsets(
        equalTo value: CGFloat = 0,
        priority: CBLayoutPriority = .required) -> UICInTheSceneModifier<View> {

        self.safeArea(topEqualTo: value, priority: priority)
            .safeArea(bottomEqualTo: value, priority: priority)
            .safeArea(leadingEqualTo: value, priority: priority)
            .safeArea(trailingEqualTo: value, priority: priority)
    }

    @inlinable
    func top<OtherView>(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func top<OtherView>(
        greaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func top<OtherView>(
        lessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func bottom<OtherView>(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func bottom<OtherView>(
        greaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func bottom<OtherView>(
        lessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func leading<OtherView>(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func leading<OtherView>(
        greaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func leading<OtherView>(
        lessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func trailing<OtherView>(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func trailing<OtherView>(
        greaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func trailing<OtherView>(
        lessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func height<OtherView>(
        equalToSuperview multiplier: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func height<OtherView>(
        greaterThanOrEqualToSuperview multiplier: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func height<OtherView>(
        lessThanOrEqualToSuperview multiplier: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func width<OtherView>(
        equalToSuperview multiplier: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func width<OtherView>(
        greaterThanOrEqualToSuperview multiplier: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func width<OtherView>(
        lessThanOrEqualToSuperview multiplier: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inline(__always) @inlinable
    func insets<OtherView>(
        equalTo value: CGFloat = .zero,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.top(equalTo: value, priority: priority, outlet)
            .bottom(equalTo: value, priority: priority, outlet)
            .leading(equalTo: value, priority: priority, outlet)
            .trailing(equalTo: value, priority: priority, outlet)
    }
}

public extension UIViewCreator {

    @inline(__always) @inlinable
    func aspectRatio(
        equalTo multiplier: CGFloat = 1,
        priority: CBLayoutPriority = .required) -> UICNotRenderedModifier<View> {

        self.aspectRatio(heightEqualTo: multiplier, priority: priority)
    }

    @inlinable
    func aspectRatio(
        heightEqualTo multiplier: CGFloat,
        priority: CBLayoutPriority = .required) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func aspectRatio(
        heightGreaterThanOrEqualTo multiplier: CGFloat,
        priority: CBLayoutPriority = .required) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func aspectRatio(
        heightLessThanOrEqualTo multiplier: CGFloat,
        priority: CBLayoutPriority = .required) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func aspectRatio(
        widthEqualTo multiplier: CGFloat,
        priority: CBLayoutPriority = .required) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func aspectRatio(
        widthGreaterThanOrEqualTo multiplier: CGFloat,
        priority: CBLayoutPriority = .required) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func aspectRatio(
        widthLessThanOrEqualTo multiplier: CGFloat,
        priority: CBLayoutPriority = .required) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func height(
        equalTo constant: CGFloat,
        priority: CBLayoutPriority = .required) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func height(
        greaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func height(
        lessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func width(
        equalTo constant: CGFloat,
        priority: CBLayoutPriority = .required) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func width(
        greaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func width(
        lessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func center<OtherView>(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func center<OtherView>(
        greaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func center<OtherView>(
        lessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func centerX<OtherView>(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func centerX<OtherView>(
        greaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func centerX<OtherView>(
        lessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func centerY<OtherView>(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func centerY<OtherView>(
        greaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func centerY<OtherView>(
        lessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        centerEqualTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        centerGreaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        centerLessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        centerXEqualTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        centerXGreaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        centerXLessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        centerYEqualTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        centerYGreaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func safeArea<OtherView>(
        centerYLessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func hugging(
        vertical verticalPriority: CBLayoutPriority = .defaultLow,
        horizontal horizontalPriority: CBLayoutPriority = .defaultLow) -> UICNotRenderedModifier<View> {
        
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
    

    @inlinable
    func compression(
        vertical verticalPriority: CBLayoutPriority = .defaultHigh,
        horizontal horizontalPriority: CBLayoutPriority = .defaultHigh) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func vertical(
        hugging huggingPriority: CBLayoutPriority = .defaultLow,
        compression compressionPriority: CBLayoutPriority = .defaultHigh) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func horizontal(
        hugging huggingPriority: CBLayoutPriority = .defaultLow,
        compression compressionPriority: CBLayoutPriority = .defaultHigh) -> UICNotRenderedModifier<View> {

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

    @inlinable
    func topMargin<OtherView>(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func topMargin<OtherView>(
        greaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func topMargin<OtherView>(
        lessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func bottomMargin<OtherView>(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func bottomMargin<OtherView>(
        greaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func bottomMargin<OtherView>(
        lessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func leadingMargin<OtherView>(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func leadingMargin<OtherView>(
        greaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func leadingMargin<OtherView>(
        lessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func trailingMargin<OtherView>(
        equalTo constant: CGFloat = 0,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func trailingMargin<OtherView>(
        greaterThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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

    @inlinable
    func trailingMargin<OtherView>(
        lessThanOrEqualTo constant: CGFloat,
        priority: CBLayoutPriority = .required,
        _ outlet: UICOutlet<OtherView>? = nil) -> UICInTheSceneModifier<View> where OtherView: UIView {

        self.onInTheScene { view in
            guard let superview = outlet?.wrappedValue ?? view.layoutSuperview else {
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
