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
    fileprivate var realSuperview: UIView? {
        guard let superview = self.superview else {
            return nil
        }

        return sequence(first: superview, next: { (UIViewWrapper($0)?.safe ?? $0).superview }).first(where: {
            !($0 is RootView)
        })
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
    func safeArea(topEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .top
                    .equalTo(view.safeAreaCompatibleGuide.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(topGreaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .top
                    .greaterThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(topLessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .top
                    .lessThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(bottomEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .bottom
                    .equalTo(view.safeAreaCompatibleGuide.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(bottomGreaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .bottom
                    .greaterThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(bottomLessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .bottom
                    .lessThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(leadingEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .leading
                    .equalTo(view.safeAreaCompatibleGuide.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(leadingGreaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .leading
                    .greaterThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(leadingLessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .leading
                    .lessThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(trailingEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .trailing
                    .equalTo(view.safeAreaCompatibleGuide.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(trailingGreaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .trailing
                    .greaterThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(trailingLessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .trailing
                    .lessThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeAreaInsets(equalTo value: CGFloat = 0, priority: UILayoutPriority = .required) -> Self {
        return self.safeArea(topEqualTo: value, priority: priority)
            .safeArea(bottomEqualTo: value, priority: priority)
            .safeArea(leadingEqualTo: value, priority: priority)
            .safeArea(trailingEqualTo: value, priority: priority)
    }

    func top(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .top
                    .equalTo(view.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func top(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .top
                    .greaterThanOrEqualTo(view.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func top(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .top
                    .lessThanOrEqualTo(view.cbuild.top)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func bottom(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .bottom
                    .equalTo(view.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func bottom(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .bottom
                    .greaterThanOrEqualTo(view.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func bottom(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .bottom
                    .lessThanOrEqualTo(view.cbuild.bottom)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func leading(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .leading
                    .equalTo(view.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func leading(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .leading
                    .greaterThanOrEqualTo(view.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func leading(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .leading
                    .lessThanOrEqualTo(view.cbuild.leading)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func trailing(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .trailing
                    .equalTo(view.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func trailing(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .trailing
                    .greaterThanOrEqualTo(view.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func trailing(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .trailing
                    .lessThanOrEqualTo(view.cbuild.trailing)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func height(equalToSuperview multiplier: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .height
                    .equalTo(view.cbuild.height)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            )
        }
    }

    func height(greaterThanOrEqualToSuperview multiplier: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .height
                    .greaterThanOrEqualTo(view.cbuild.height)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            )
        }
    }

    func height(lessThanOrEqualToSuperview multiplier: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .height
                    .lessThanOrEqualTo(view.cbuild.height)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            )
        }
    }

    typealias ConstraintRelatedView = () -> UIView

    func width(equalToSuperview multiplier: CGFloat, priority: UILayoutPriority = .required, orView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .width
                    .equalTo(view.cbuild.width)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            )
        }
    }

    func width(greaterThanOrEqualToSuperview multiplier: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .width
                    .greaterThanOrEqualTo(view.cbuild.width)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            )
        }
    }

    func width(lessThanOrEqualToSuperview multiplier: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .width
                    .lessThanOrEqualTo(view.cbuild.width)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            )
        }
    }
}

public extension ViewCreator {
    func insets(equalTo value: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
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
        return self.onNotRendered {
            let view = (UIViewWrapper($0)?.safe ?? $0)

            Constraintable.update(
                view.cbuild
                    .height
                    .equalTo(view.cbuild.width)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            )
        }
    }

    func aspectRatio(heightGreaterThanOrEqualTo multiplier: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            let view = (UIViewWrapper($0)?.safe ?? $0)

            Constraintable.update(
                view.cbuild
                    .height
                    .greaterThanOrEqualTo(view.cbuild.width)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            )
        }
    }

    func aspectRatio(heightLessThanOrEqualTo multiplier: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            let view = (UIViewWrapper($0)?.safe ?? $0)

            Constraintable.update(
                view.cbuild
                    .height
                    .lessThanOrEqualTo(view.cbuild.width)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            )
        }
    }

    func aspectRatio(widthEqualTo multiplier: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            let view = (UIViewWrapper($0)?.safe ?? $0)

            Constraintable.update(
                view.cbuild
                    .width
                    .equalTo(view.cbuild.height)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            )
        }
    }

    func aspectRatio(widthGreaterThanOrEqualTo multiplier: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            let view = (UIViewWrapper($0)?.safe ?? $0)

            Constraintable.update(
                view.cbuild
                    .width
                    .greaterThanOrEqualTo(view.cbuild.height)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            )
        }
    }

    func aspectRatio(widthLessThanOrEqualTo multiplier: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            let view = (UIViewWrapper($0)?.safe ?? $0)

            Constraintable.update(
                view.cbuild
                    .width
                    .lessThanOrEqualTo(view.cbuild.height)
                    .update()
                    .multiplier(multiplier)
                    .priority(priority)
            )
        }
    }
}

public extension ViewCreator {
    func height(equalTo constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .height
                    .equalTo(constant)
                    .update()
                    .priority(priority)
            )
        }
    }

    func height(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .height
                    .greaterThanOrEqualTo(constant)
                    .update()
                    .priority(priority)
            )
        }
    }

    func height(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .height
                    .lessThanOrEqualTo(constant)
                    .update()
                    .priority(priority)
            )
        }
    }

    func width(equalTo constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .width
                    .equalTo(constant)
                    .update()
                    .priority(priority)
            )
        }
    }

    func width(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .width
                    .greaterThanOrEqualTo(constant)
                    .update()
                    .priority(priority)
            )
        }
    }

    func width(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        return self.onNotRendered {
            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .width
                    .lessThanOrEqualTo(constant)
                    .update()
                    .priority(priority)
            )
        }
    }
}

public extension ViewCreator {
    func center(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .center
                    .equalTo(view.cbuild.center)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func center(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .center
                    .greaterThanOrEqualTo(view.cbuild.center)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func center(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .center
                    .lessThanOrEqualTo(view.cbuild.center)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func centerX(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .centerX
                    .equalTo(view.cbuild.centerX)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func centerX(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .centerX
                    .greaterThanOrEqualTo(view.cbuild.centerX)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func centerX(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .centerX
                    .lessThanOrEqualTo(view.cbuild.centerX)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func centerY(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .centerY
                    .equalTo(view.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func centerY(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .centerY
                    .greaterThanOrEqualTo(view.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func centerY(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .centerY
                    .lessThanOrEqualTo(view.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }
}

public extension ViewCreator {
    func safeArea(centerEqualTo constant: CGFloat = 0, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .center
                    .equalTo(view.safeAreaCompatibleGuide.cbuild.center)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(centerGreaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .center
                    .greaterThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.center)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(centerLessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .center
                    .lessThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.center)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(centerXEqualTo constant: CGFloat = 0, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .centerX
                    .equalTo(view.safeAreaCompatibleGuide.cbuild.centerX)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(centerXGreaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .centerX
                    .greaterThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.centerX)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(centerXLessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .centerX
                    .lessThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.centerX)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(centerYEqualTo constant: CGFloat = 0, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .centerY
                    .equalTo(view.safeAreaCompatibleGuide.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(centerYGreaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .centerY
                    .greaterThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func safeArea(centerYLessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, orRelatedView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .centerY
                    .lessThanOrEqualTo(view.safeAreaCompatibleGuide.cbuild.centerY)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }
}

public extension ViewCreator {
    func hugging(vertical verticalPriority: UILayoutPriority = .defaultLow, horizontal horizontalPriority: UILayoutPriority = .defaultLow) -> Self {
        return self.onNotRendered {
            (UIViewWrapper($0)?.safe ?? $0).setContentHuggingPriority(verticalPriority, for: .vertical)
            (UIViewWrapper($0)?.safe ?? $0).setContentHuggingPriority(horizontalPriority, for: .horizontal)
        }
    }

    func compression(vertical verticalPriority: UILayoutPriority = .defaultHigh, horizontal horizontalPriority: UILayoutPriority = .defaultHigh) -> Self {
        return self.onNotRendered {
            (UIViewWrapper($0)?.safe ?? $0).setContentCompressionResistancePriority(verticalPriority, for: .vertical)
            (UIViewWrapper($0)?.safe ?? $0).setContentCompressionResistancePriority(horizontalPriority, for: .horizontal)
        }
    }

    func vertical(hugging huggingPriority: UILayoutPriority = .defaultLow, compression compressionPriority: UILayoutPriority = .defaultHigh) -> Self {
        return self.onNotRendered {
            (UIViewWrapper($0)?.safe ?? $0).setContentHuggingPriority(huggingPriority, for: .vertical)
            (UIViewWrapper($0)?.safe ?? $0).setContentCompressionResistancePriority(compressionPriority, for: .vertical)
        }
    }

    func horizontal(hugging huggingPriority: UILayoutPriority = .defaultLow, compression compressionPriority: UILayoutPriority = .defaultHigh) -> Self {
        return self.onNotRendered {
            (UIViewWrapper($0)?.safe ?? $0).setContentHuggingPriority(huggingPriority, for: .horizontal)
            (UIViewWrapper($0)?.safe ?? $0).setContentCompressionResistancePriority(compressionPriority, for: .horizontal)
        }
    }
}

public extension ViewCreator {
    func topMargin(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .top
                    .equalTo(view.cbuild.topMargin)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func topMargin(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .top
                    .greaterThanOrEqualTo(view.cbuild.topMargin)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func topMargin(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .top
                    .lessThanOrEqualTo(view.cbuild.topMargin)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func bottomMargin(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .bottom
                    .equalTo(view.cbuild.bottomMargin)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func bottomMargin(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .bottom
                    .greaterThanOrEqualTo(view.cbuild.bottomMargin)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func bottomMargin(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .bottom
                    .lessThanOrEqualTo(view.cbuild.bottomMargin)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func leadingMargin(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .leading
                    .equalTo(view.cbuild.leadingMargin)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func leadingMargin(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .leading
                    .greaterThanOrEqualTo(view.cbuild.leadingMargin)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func leadingMargin(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .leading
                    .lessThanOrEqualTo(view.cbuild.leadingMargin)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func trailingMargin(equalTo constant: CGFloat = 0, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .trailing
                    .equalTo(view.cbuild.trailingMargin)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func trailingMargin(greaterThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .trailing
                    .greaterThanOrEqualTo(view.cbuild.trailingMargin)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }

    func trailingMargin(lessThanOrEqualTo constant: CGFloat, priority: UILayoutPriority = .required, toView view: ConstraintRelatedView? = nil) -> Self {
        return self.onInTheScene {
            guard let view = view?() ?? (UIViewWrapper($0)?.safe ?? $0).realSuperview else {
                return
            }

            Constraintable.update(
                (UIViewWrapper($0)?.safe ?? $0).cbuild
                    .trailing
                    .lessThanOrEqualTo(view.cbuild.trailingMargin)
                    .update()
                    .constant(constant)
                    .priority(priority)
            )
        }
    }
}
