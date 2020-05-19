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

public extension UICLabel {
    class View: UILabel {

        override open var isHidden: Bool {
            get { super.isHidden }
            set {
                super.isHidden = newValue
                RenderManager(self)?.isHidden(newValue)
            }
        }

        override open var frame: CGRect {
            get { super.frame }
            set {
                super.frame = newValue
                RenderManager(self)?.frame(newValue)
            }
        }

        override public func willMove(toSuperview newSuperview: UIView?) {
            super.willMove(toSuperview: newSuperview)
            RenderManager(self)?.willMove(toSuperview: newSuperview)
        }

        override public func didMoveToSuperview() {
            super.didMoveToSuperview()
            RenderManager(self)?.didMoveToSuperview()
        }

        override public func didMoveToWindow() {
            super.didMoveToWindow()
            RenderManager(self)?.didMoveToWindow()
        }

        override public func layoutSubviews() {
            super.layoutSubviews()
            RenderManager(self)?.layoutSubviews()
        }

        override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            RenderManager(self)?.traitDidChange()
        }
    }
}

public class UICLabel: UIViewCreator, TextElement {

    required public init(_ text: String?) {
        self.loadView {
            View(builder: self)
        }
        .onNotRendered {
            ($0 as? View)?.text = text
        }
    }

    required public init(_ attributedText: NSAttributedString?) {
        self.loadView {
            View(builder: self)
        }
        .onNotRendered {
            ($0 as? View)?.attributedText = attributedText
        }
    }
}

public extension UIViewCreator where View: UILabel, Self: TextElement {
    init(_ text: Relay<String?>) {
        self.init(text.wrappedValue)
        self.onInTheScene {
            weak var view = $0 as? View
            text.sync {
                view?.text = $0
            }
        }
    }
}

public extension TextElement where View: UILabel {
    func text(_ string: String?) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.text = string
        }
    }

    func text(_ attributedText: NSAttributedString?) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.attributedText = attributedText
        }
    }

    func textColor(_ color: UIColor?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.textColor = color
        }
    }

    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.font = font
            ($0 as? View)?.adjustsFontForContentSizeCategory = isDynamicTextSize
        }
    }

    func textScale(_ scale: CGFloat) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.minimumScaleFactor = scale
            ($0 as? View)?.adjustsFontSizeToFitWidth = scale != 1
        }
    }

    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.textAlignment = alignment
        }
    }

    func numberOfLines(_ number: Int) -> Self {
        self.onNotRendered {
            ($0 as? View)?.numberOfLines = number
        }
    }
}

public extension TextElement where View: UILabel {
    func adjustsFontForContentSizeCategory(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontForContentSizeCategory = flag
        }
    }

    func adjustsFontSizeToFitWidth(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.adjustsFontSizeToFitWidth = flag
        }
    }
}

public extension UIViewCreator where View: UILabel, Self: TextElement {
    init(_ attributed: Relay<NSAttributedString?>) {
        self.init(NSAttributedString?(nil))

        attributed.sync { [weak self] in
            _ = self?.text($0)
        }
    }
}

public extension UIViewCreator where View: UILabel {
    func lineBreakMode(_ mode: NSLineBreakMode) -> Self {
        self.onNotRendered {
            ($0 as? View)?.lineBreakMode = mode
        }
    }
}
