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

public class _DashedView: DashedView {
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
}

public class UICDashed: UIViewCreator {
    public typealias View = _DashedView

    public init(color: UIColor, pattern: [NSNumber] = [2, 3], content: () -> ViewCreator) {
        self.uiView = View.init(content().releaseUIView(), dash: pattern)
            .apply(strokeColor: color)
            .apply(lineWidth: 1)
        self.uiView.updateBuilder(self)
    }
}

extension UIViewCreator where View: DashedView {

    public func dash(color: UIColor) -> Self {
        self.onNotRendered {
            ($0 as? View)?.apply(strokeColor: color)
                .refresh()
        }
    }

    public func dash(lineWidth width: CGFloat) -> Self {
        self.onNotRendered {
            ($0 as? View)?.apply(lineWidth: width)
                .refresh()
        }
    }

    public func dash(pattern: [NSNumber]) -> Self {
        self.onNotRendered {
            _ = ($0 as? View)?.apply(dashPattern: pattern)
                .refresh()
        }
    }
}
