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

public class ImageView: UIImageView {

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            self.renderManager.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            self.renderManager.frame(newValue)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.renderManager.willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.renderManager.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.renderManager.didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.renderManager.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.renderManager.traitDidChange()
    }

    override public func removeConstraint(_ constraint: NSLayoutConstraint) {
        super.removeConstraint(constraint)
    }

    override public func removeConstraints(_ constraints: [NSLayoutConstraint]) {
        super.removeConstraints(constraints)
    }
}

public class UICImage: UIViewCreator {
    public typealias View = ImageView

    public init(contentMode: ContentMode) {
        self.loadView { [unowned self] in
            return View.init(builder: self)
        }
        .onNotRendered {
            ($0 as? View)?.contentMode = contentMode.uiContentMode
        }
    }

    public init(image: UIImage?, highlightedImage: UIImage? = nil) {
        self.loadView { [unowned self] in
            return View.init(builder: self)
        }
        .onNotRendered {
            ($0 as? View)?.image = image
            ($0 as? View)?.highlightedImage = highlightedImage
            ($0 as? View)?.contentMode = .scaleToFill
        }
    }

    public init() {
        self.loadView { [unowned self] in
            return View.init(builder: self)
        }
        .onNotRendered {
            ($0 as? View)?.contentMode = .scaleToFill
        }
    }

    public convenience init(_ imageRelay: Relay<UIImage?>) {
        self.init(image: nil)

        _ = self.onInTheScene {
            weak var view = $0 as? View
            imageRelay.sync {
                view?.image = $0
            }
        }
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

    func contentMode(_ contentMode: ContentMode) -> Self {
        self.onNotRendered {
            ($0 as? View)?.contentMode = contentMode.uiContentMode
        }
    }

    func image(_ image: UIImage?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.image = image
        }
    }

    func rendering(mode: UIImage.RenderingMode) -> Self {
        self.onRendered {
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

public extension UICImage {
    convenience init(image: Relay<UIImage?>, placeholder: UIImage? = nil) {
        self.init(image: nil)

        self.onNotRendered { view in
            weak var view = view as? View
            image.sync {
                view?.image = $0 ?? placeholder
            }
        }
    }
}
