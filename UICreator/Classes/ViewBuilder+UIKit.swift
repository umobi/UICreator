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

public extension UIViewCreator {
    func background(color: UIColor?) -> Self {
        return self.onNotRendered {
            $0.backgroundColor = color
        }
    }

    func tintColor(_ color: UIColor?) -> Self {
        self.onNotRendered {
            $0.tintColor = color
        }
    }

    func contentScaleFactor(_ scale: CGFloat) -> Self {
        self.onNotRendered {
            $0.contentScaleFactor = scale
        }
    }

    func zIndex(_ zIndex: CGFloat) -> Self {
        self.onNotRendered {
            $0.layer.zPosition = zIndex
        }
    }

    func border(color: UIColor?) -> Self {
        return self.onNotRendered {
            $0.layer.borderColor = color?.cgColor
        }
    }

    func border(width: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.borderWidth = width
        }
    }

    func corner(radius: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.cornerRadius = radius
        }
    }

    func alpha(_ constant: CGFloat) -> Self {
        return self.onNotRendered {
            $0.alpha = constant
        }
    }

    func `as`<UIElement: UIView>(_ reference: inout UIElement!) -> Self {
        reference = self.uiView as? UIElement
        return self
    }
}

public extension UIViewCreator {
    func shadow(radius: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.shadowRadius = radius
        }
    }

    func shadow(offset: CGSize) -> Self {
        return self.onNotRendered {
            $0.layer.shadowOffset = offset
        }
    }

    func shadow(ocupacity alpha: CGFloat) -> Self {
        return self.onNotRendered {
            $0.layer.shadowOpacity = Float(alpha)
        }
    }

    func shadow(color: UIColor?) -> Self {
        return self.onNotRendered {
            $0.layer.shadowColor = color?.cgColor
        }
    }

    func clips(toBounds flag: Bool) -> Self {
        return self.onInTheScene {
            $0.clipsToBounds = flag
        }
    }

    func isOpaque(_ flag: Bool) -> Self {
        return self.onInTheScene {
            $0.isOpaque = flag
        }
    }

    func isHidden(_ flag: Bool) -> Self {
        return self.onInTheScene {
            $0.isHidden = flag
        }
    }
}
