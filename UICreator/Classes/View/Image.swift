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

public class ImageView: UIImageView {
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

public class Image: UIViewCreator {
    public typealias View = ImageView

    public init(mode: View.ContentMode = .scaleToFill) {
        self.uiView = View.init(image: nil, highlightedImage: nil)
        self.uiView.contentMode = mode
    }

    public init(image: UIImage?, highlightedImage: UIImage? = nil) {
        self.uiView = View.init(image: image, highlightedImage: nil)
    }

    public init() {
        self.uiView = View.init(image: nil, highlightedImage: nil)
    }
}

public extension UIViewCreator where View: UIImageView {

    @available(iOS 13, tvOS 13.0, *)
    func applySymbolConfiguration(_ configuration: UIImage.SymbolConfiguration) -> Self {
        self.onNotRendered {
            ($0 as? View)?.image = ($0 as? View)?.image?.applyingSymbolConfiguration(configuration)
        }
    }

    @available(iOS 13, tvOS 13.0, *)
    func preferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration) -> Self {
        self.onNotRendered {
            ($0 as? View)?.preferredSymbolConfiguration = configuration
        }
    }

    func content(mode: View.ContentMode) -> Self {
        self.onNotRendered {
            ($0 as? View)?.contentMode = mode
        }
    }

    func image(_ image: UIImage?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.image = image
        }
    }

    func tint(color: UIColor?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.tintColor = color
        }
    }

    func rendering(mode: UIImage.RenderingMode) -> Self {
        return self.onRendered {
            ($0 as? View)?.image = ($0 as? View)?.image?.withRenderingMode(mode)
        }
    }
}

#if os(tvOS)
public extension UIViewCreator where View: UIImageView {
    @available(tvOS 13, *)
    func adjustsImageWhenAncestorFocused(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.adjustsImageWhenAncestorFocused = flag
        }
    }
}
#endif
