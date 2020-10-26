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
import ConstraintBuilder

public class ImageView: UIImageView {

    init() {
        super.init(frame: .zero)
        self.makeSelfImplemented()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(image: UIImage?) {
        fatalError("init(image:) has not been implemented")
    }

    override public init(image: UIImage?, highlightedImage: UIImage?) {
        fatalError("init(image:, highlightedImage:) has not been implemented")
    }

    override public init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

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

public struct UICImageView: UIViewCreator {
    public typealias View = UIImageView

    @Relay var image: UICImage?
    @Relay var highlighted: UICImage?
    let placeholder: UICImage?

    public init(_ image: UICImage) {
        self._image = .constant(image)
        self._highlighted = .constant(nil)
        self.placeholder = nil
    }

    public init(_ image: UICImage, highlighted: UICImage) {
        self._image = .constant(image)
        self._highlighted = .constant(highlighted)
        self.placeholder = nil
    }

    public init(_ image: Relay<UICImage?>) {
        self._image = image
        self._highlighted = .constant(nil)
        self.placeholder = nil
    }

    public init(_ image: Relay<UICImage?>, highlighted: Relay<UICImage?>) {
        self._image = image
        self._highlighted = highlighted
        self.placeholder = nil
    }

    public init(_ image: Relay<UICImage?>, placeholder: UICImage) {
        self._image = image
        self._highlighted = .constant(nil)
        self.placeholder = placeholder
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return ImageView()
            .onNotRendered {
                weak var view = $0 as? View

                _self.$highlighted.sync {
                    view?.highlightedImage = $0?.uiImage
                }
            }
            .onNotRendered {
                weak var view = $0 as? View

                _self.$image.sync {
                    view?.image = ($0 ?? _self.placeholder)?.uiImage
                }
            }
    }
}

public extension UIViewCreator where View: UIImageView {
    @available(iOS 13, tvOS 13.0, *)
    func preferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.preferredSymbolConfiguration = configuration
        }
    }

    func isHighlighted(_ dynamicFlag: Relay<Bool>) -> UICModifiedView<View> {
        self.onNotRendered {
            weak var view = $0 as? View

            dynamicFlag.distinctSync {
                view?.isHighlighted = $0
            }
        }
    }
}

public extension UIViewCreator where View: UIImageView {
    func isAnimating(_ dynamicFlag: Relay<Bool>) -> UICModifiedView<View> {
        self.onNotRendered {
            weak var view = $0 as? View

            dynamicFlag.distinctSync {
                if $0 {
                    view?.startAnimating()
                    return
                }

                view?.stopAnimating()
            }
        }
    }
}
