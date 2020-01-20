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
import SnapKit

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

public extension ViewCreator {
    func safeArea(topEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.snp.makeConstraints {
                    $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
                        .offset(constant)
                        .priority(priority)
                }
                return
            }

            $0.snp.makeConstraints {
                $0.top.equalTo(view.snp.topMargin)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(topGreaterThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.snp.makeConstraints {
                    $0.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.topMargin)
                        .offset(constant)
                        .priority(priority)
                }
                return
            }

            $0.snp.makeConstraints {
                $0.top.greaterThanOrEqualTo(view.snp.topMargin)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(topLessThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.snp.makeConstraints {
                    $0.top.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.topMargin)
                        .offset(constant)
                        .priority(priority)
                }
                return
            }

            $0.snp.makeConstraints {
                $0.top.lessThanOrEqualTo(view.snp.topMargin)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(bottomEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.snp.makeConstraints {
                    $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
                        .offset(constant)
                        .priority(priority)
                }
                return
            }

            $0.snp.makeConstraints {
                $0.bottom.equalTo(view.snp.bottomMargin)
                    .offset(constant)
                    .priority(priority)
            }

        }
    }

    func safeArea(bottomGreaterThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }
            
            if #available(iOS 11, tvOS 11, *) {
                $0.snp.makeConstraints {
                    $0.bottom.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottomMargin)
                        .offset(constant)
                        .priority(priority)
                }
                return
            }


            $0.snp.makeConstraints {
                $0.bottom.greaterThanOrEqualTo(view.snp.bottomMargin)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func safeArea(bottomLessThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.snp.makeConstraints {
                    $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottomMargin)
                        .offset(constant)
                        .priority(priority)
                }
            } else {
                $0.snp.makeConstraints {
                    $0.bottom.lessThanOrEqualTo(view.snp.bottomMargin)
                        .offset(constant)
                        .priority(priority)
                }
            }
        }
    }

    func safeArea(leadingEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.snp.makeConstraints {
                    $0.leading.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.leadingMargin)
                        .offset(constant)
                        .priority(priority)
                }
            } else {
                $0.snp.makeConstraints {
                    $0.leading.lessThanOrEqualTo(view.snp.leadingMargin)
                        .offset(constant)
                        .priority(priority)
                }
            }
        }
    }

    func safeArea(leadingGreaterThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.snp.makeConstraints {
                    $0.leading.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.leadingMargin)
                        .offset(constant)
                        .priority(priority)
                }
            } else {
                $0.snp.makeConstraints {
                    $0.leading.greaterThanOrEqualTo(view.snp.leadingMargin)
                        .offset(constant)
                        .priority(priority)
                }
            }
        }
    }

    func safeArea(leadingLessThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.snp.makeConstraints {
                    $0.leading.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.leadingMargin)
                        .offset(constant)
                        .priority(priority)
                }
            } else {
                $0.snp.makeConstraints {
                    $0.leading.lessThanOrEqualTo(view.snp.leadingMargin)
                        .offset(constant)
                        .priority(priority)
                }
            }
        }
    }

    func safeArea(trailingEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.snp.makeConstraints {
                    $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin)
                        .offset(constant)
                        .priority(priority)
                }
            } else {
                $0.snp.makeConstraints {
                    $0.trailing.equalTo(view.snp.trailingMargin)
                        .offset(constant)
                        .priority(priority)
                }
            }
        }
    }

    func safeArea(trailingGreaterThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.snp.makeConstraints {
                    $0.trailing.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.trailingMargin)
                        .offset(constant)
                        .priority(priority)
                }
            } else {
                $0.snp.makeConstraints {
                    $0.trailing.greaterThanOrEqualTo(view.snp.trailingMargin)
                        .offset(constant)
                        .priority(priority)
                }
            }
        }
    }

    func safeArea(trailingLessThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            if #available(iOS 11, tvOS 11, *) {
                $0.snp.makeConstraints {
                    $0.trailing.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.trailingMargin)
                        .offset(constant)
                        .priority(priority)
                }
            } else {
                $0.snp.makeConstraints {
                    $0.trailing.lessThanOrEqualTo(view.snp.trailingMargin)
                        .offset(constant)
                        .priority(priority)
                }
            }
        }
    }

    func safeAreaInsets(equalTo value: CGFloat = 0, priority: ConstraintPriority = .required) -> Self {
        return self.safeArea(topEqualTo: value, priority: priority)
            .safeArea(bottomEqualTo: value, priority: priority)
            .safeArea(leadingEqualTo: value, priority: priority)
            .safeArea(trailingEqualTo: value, priority: priority)
    }

    func top(equalTo constant: CGFloat = 0, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.top.equalTo(view.snp.top)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func top(greaterThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.top.greaterThanOrEqualTo(view.snp.top)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func top(lessThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.top.lessThanOrEqualTo(view.snp.top)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func bottom(equalTo constant: CGFloat = 0, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.bottom.equalTo(view.snp.bottom)
                    .offset(-constant)
                    .priority(priority)
            }
        }
    }

    func bottom(greaterThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.bottom.greaterThanOrEqualTo(view.snp.bottom)
                    .offset(-constant)
                    .priority(priority)
            }
        }
    }

    func bottom(lessThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.bottom.lessThanOrEqualTo(view.snp.bottom)
                    .offset(-constant)
                    .priority(priority)
            }
        }
    }

    func leading(equalTo constant: CGFloat = 0, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.leading.equalTo(view.snp.leading)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func leading(greaterThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.leading.greaterThanOrEqualTo(view.snp.leading)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func leading(lessThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.leading.lessThanOrEqualTo(view.snp.leading)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func trailing(equalTo constant: CGFloat = 0, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.trailing.equalTo(view.snp.trailing)
                    .offset(-constant)
                    .priority(priority)
            }
        }
    }

    func trailing(greaterThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.trailing.greaterThanOrEqualTo(view.snp.trailing)
                    .offset(-constant)
                    .priority(priority)
            }
        }
    }

    func trailing(lessThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, toView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.trailing.lessThanOrEqualTo(view.snp.trailing)
                .offset(-constant)
                .priority(priority)
            }
        }
    }

    func height(equalToSuperview multiplier: CGFloat, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.height.equalTo(view.snp.height)
                    .multipliedBy(multiplier)
                    .priority(priority)
            }
        }
    }

    func height(greaterThanOrEqualToSuperview multiplier: CGFloat, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(view.snp.height)
                    .multipliedBy(multiplier)
                    .priority(priority)
            }
        }
    }

    func height(lessThanOrEqualToSuperview multiplier: CGFloat, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.height.lessThanOrEqualTo(view.snp.height)
                    .multipliedBy(multiplier)
                    .priority(priority)
            }
        }
    }

    func width(equalToSuperview multiplier: CGFloat, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.width.equalTo(view.snp.width)
                    .multipliedBy(multiplier)
                    .priority(priority)
            }
        }
    }

    func width(greaterThanOrEqualToSuperview multiplier: CGFloat, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.width.greaterThanOrEqualTo(view.snp.width)
                    .multipliedBy(multiplier)
                    .priority(priority)
            }
        }
    }

    func width(lessThanOrEqualToSuperview multiplier: CGFloat, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.width.lessThanOrEqualTo(view.snp.width)
                    .multipliedBy(multiplier)
                    .priority(priority)
            }
        }
    }
}

public extension ViewCreator {
    func insets(equalTo value: CGFloat = 0, priority: ConstraintPriority = .required) -> Self {
        return self.top(equalTo: value, priority: priority)
            .bottom(equalTo: value, priority: priority)
            .leading(equalTo: value, priority: priority)
            .trailing(equalTo: value, priority: priority)
    }
}

public extension ViewCreator {
    func aspectRatio(equalTo multiplier: CGFloat = 1, priority: ConstraintPriority = .required) -> Self {
        return self.aspectRatio(heightEqualTo: multiplier, priority: priority)
    }

    func aspectRatio(heightEqualTo multiplier: CGFloat, priority: ConstraintPriority = .required) -> Self {
        return self.onNotRendered { view in
            view.snp.makeConstraints {
                $0.height.equalTo(view.snp.width)
                    .multipliedBy(multiplier)
                    .priority(priority)
            }
        }
    }

    func aspectRatio(heightGreaterThanOrEqualTo multiplier: CGFloat, priority: ConstraintPriority = .required) -> Self {
        return self.onNotRendered { view in
            view.snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(view.snp.width)
                    .multipliedBy(multiplier)
                    .priority(priority)
            }
        }
    }

    func aspectRatio(heightLessThanOrEqualTo multiplier: CGFloat, priority: ConstraintPriority = .required) -> Self {
        return self.onNotRendered { view in
            view.snp.makeConstraints {
                $0.height.lessThanOrEqualTo(view.snp.width)
                    .multipliedBy(multiplier)
                    .priority(priority)
            }
        }
    }

    func aspectRatio(widthEqualTo multiplier: CGFloat, priority: ConstraintPriority = .required) -> Self {
        return self.onNotRendered { view in
            view.snp.makeConstraints {
                $0.width.equalTo(view.snp.height)
                    .multipliedBy(multiplier)
                    .priority(priority)
            }
        }
    }

    func aspectRatio(widthGreaterThanOrEqualTo multiplier: CGFloat, priority: ConstraintPriority = .required) -> Self {
        return self.onNotRendered { view in
            view.snp.makeConstraints {
                $0.width.greaterThanOrEqualTo(view.snp.height)
                    .multipliedBy(multiplier)
                    .priority(priority)
            }
        }
    }

    func aspectRatio(widthLessThanOrEqualTo multiplier: CGFloat, priority: ConstraintPriority = .required) -> Self {
        return self.onNotRendered { view in
            view.snp.makeConstraints {
                $0.width.lessThanOrEqualTo(view.snp.height)
                    .multipliedBy(multiplier)
                    .priority(priority)
            }
        }
    }
}

public extension ViewCreator {
    func height(equalTo constant: CGFloat, priority: ConstraintPriority = .required) -> Self {
        return self.onNotRendered {
            $0.snp.makeConstraints {
                $0.height.equalTo(constant)
                    .priority(priority)
            }
        }
    }

    func height(greaterThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required) -> Self {
        return self.onNotRendered {
            $0.snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(constant)
                    .priority(priority)
            }
        }
    }

    func height(lessThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required) -> Self {
        return self.onNotRendered {
            $0.snp.makeConstraints {
                $0.height.lessThanOrEqualTo(constant)
                .priority(priority)
            }
        }
    }

    func width(equalTo constant: CGFloat, priority: ConstraintPriority = .required) -> Self {
        return self.onNotRendered {
            $0.snp.makeConstraints {
                $0.width.equalTo(constant)
                    .priority(priority)
            }
        }
    }

    func width(greaterThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required) -> Self {
        return self.onNotRendered {
            $0.snp.makeConstraints {
                $0.width.greaterThanOrEqualTo(constant)
                    .priority(priority)
            }
        }
    }

    func width(lessThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required) -> Self {
        return self.onNotRendered {
            $0.snp.makeConstraints {
                $0.width.lessThanOrEqualTo(constant)
                .priority(priority)
            }
        }
    }
}

public extension ViewCreator {
    func center(equalTo constant: CGFloat = 0, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.center.equalTo(view.snp.center)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func center(lessThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.center.lessThanOrEqualTo(view.snp.center)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func center(greaterThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.center.greaterThanOrEqualTo(view.snp.center)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func centerX(equalTo constant: CGFloat = 0, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.centerX.equalTo(view.snp.centerX)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func centerX(lessThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.centerX.lessThanOrEqualTo(view.snp.centerX)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func centerX(greaterThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.centerX.greaterThanOrEqualTo(view.snp.centerX)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func centerY(equalTo constant: CGFloat = 0, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.centerY.equalTo(view.snp.centerY)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func centerY(lessThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.centerY.lessThanOrEqualTo(view.snp.centerY)
                    .offset(constant)
                    .priority(priority)
            }
        }
    }

    func centerY(greaterThanOrEqualTo constant: CGFloat, priority: ConstraintPriority = .required, orRelatedView view: UIView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view ?? $0.realSuperview else {
                return
            }

            $0.snp.makeConstraints {
                $0.centerY.greaterThanOrEqualTo(view.snp.centerY)
                    .offset(constant)
                    .priority(priority)
            }
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
