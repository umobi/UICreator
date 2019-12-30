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

public class StackView: UIStackView {
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.commitNotRendered()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }

    public override var watchingViews: [UIView] {
        return self.arrangedSubviews
    }
}

public class Stack: UIViewCreator {
    public typealias View = StackView

    public init(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0,_ subviews: Subview) {
        self.uiView = View.init(arrangedSubviews: subviews.views.map {
            $0.uiView
        })
        (self.uiView as? View)?.axis = axis
        (self.uiView as? View)?.spacing = spacing
    }

    public init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, _ views: ViewCreator...) {
        self.uiView = View.init(arrangedSubviews: views.map {
            $0.uiView
        })
        (self.uiView as? View)?.axis = axis
        (self.uiView as? View)?.spacing = spacing
    }

    public init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, _ views: [ViewCreator]) {
        self.uiView = View.init(arrangedSubviews: views.map {
            $0.uiView
        })
        (self.uiView as? View)?.axis = axis
        (self.uiView as? View)?.spacing = spacing
    }
}

public func HStack(spacing: CGFloat = 0, _ subviews: Subview) -> Stack {
    return .init(axis: .horizontal, spacing: spacing, subviews)
}

public func VStack(spacing: CGFloat = 0, _ subviews: Subview) -> Stack {
    return .init(axis: .vertical, spacing: spacing, subviews)
}

public func HStack(spacing: CGFloat = 0, _ subviews: ViewCreator...) -> Stack {
    return .init(axis: .horizontal, spacing: spacing, subviews)
}

public func VStack(spacing: CGFloat = 0, _ subviews: ViewCreator...) -> Stack {
    return .init(axis: .vertical, spacing: spacing, subviews)
}

public func HStack(spacing: CGFloat = 0, _ subviews: [ViewCreator]) -> Stack {
    return .init(axis: .horizontal, spacing: spacing, subviews)
}

public func VStack(spacing: CGFloat = 0, _ subviews: [ViewCreator]) -> Stack {
    return .init(axis: .vertical, spacing: spacing, subviews)
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
