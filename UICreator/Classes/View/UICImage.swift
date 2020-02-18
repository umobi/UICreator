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

public class _ImageView: UIImageView {

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            RenderManager(self).isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            RenderManager(self).frame(newValue)
        }
    }

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

public class UICImage: UIViewCreator {
    public typealias View = _ImageView

    public init(mode: View.ContentMode = .scaleToFill) {
        self.uiView = View.init(image: nil, highlightedImage: nil)
        self.uiView.updateBuilder(self)
        self.uiView.contentMode = mode
    }

    public init(image: UIImage?, highlightedImage: UIImage? = nil) {
        self.uiView = View.init(image: image, highlightedImage: nil)
        self.uiView.updateBuilder(self)
    }

    public init() {
        self.uiView = View.init(image: nil, highlightedImage: nil)
        self.uiView.updateBuilder(self)
    }

    private var imageRelay: Relay<UIImage?>? = nil
    public convenience init(_ imageRelay: Relay<UIImage?>) {
        self.init(image: nil)

        self.imageRelay = imageRelay
        self.context.image.connect(to: imageRelay)
    }
}

public extension Value {
    func connect(to relay: Relay<Value>) {
        relay.sync { [weak self] in
            self?.value = $0
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

extension UICImage: UIViewContext {
    public func bindContext(_ context: UICImage.Context) {
        context.image.sync { [weak self] in
            (self?.uiView as? View)?.image = $0
        }
    }

    public class Context: UICreator.Context {
        let image: Value<UIImage?> = .init(value: nil)
    }
}
