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

public class _GradientView: GradientView {
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self).willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self).didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self).didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self).layoutSubviews()
    }
}

public class UICGradient: UIViewCreator {
    public typealias View = _GradientView

    public init(_ colors: [UIColor], direction: View.Direction = .right) {
        self.uiView = View.init(builder: self)
        self.uiView.updateBuilder(self)
        (self.uiView as? View)?.colors = colors
        (self.uiView as? View)?.direction = direction
    }

    public convenience init(_ colors: UIColor..., direction: View.Direction = .right) {
        self.init(colors, direction: direction)
    }
}

public extension UIViewCreator where View: GradientView {

    func colors(_ colors: UIColor...) -> Self {
        self.onNotRendered {
            ($0 as? View)?.colors = colors
        }
    }

    func colors(_ colors: [UIColor]) -> Self {
        self.onNotRendered {
            ($0 as? View)?.colors = colors
        }
    }

    func direction(_ direction: View.Direction) -> Self {
        self.onNotRendered {
            ($0 as? View)?.direction = direction
        }
    }

    func animation(_ layerHandler: @escaping (CAGradientLayer) -> Void) -> Self {
        self.onRendered {
            ($0 as? View)?.animates {
                layerHandler($0)
            }
        }
    }
}
