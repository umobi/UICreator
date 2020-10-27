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

@frozen
public struct UICImageView: UIViewCreator {
    public typealias View = UIImageView

    @Relay private var image: UICImage?
    @Relay private var highlighted: UICImage?
    private let placeholder: UICImage?

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

    @inline(__always)
    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return Views.ImageView()
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
    @inlinable
    func preferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.preferredSymbolConfiguration = configuration
        }
    }

    @inlinable
    func isHighlighted(_ dynamicFlag: Relay<Bool>) -> UICModifiedView<View> {
        self.onNotRendered {
            weak var view = $0 as? View

            dynamicFlag.distinctSync {
                view?.isHighlighted = $0
            }
        }
    }

    @inlinable
    func contentMode(_ contentMode: ContentMode) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.contentMode = contentMode.uiContentMode
        }
    }
}

public extension UIViewCreator where View: UIImageView {

    @inlinable
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

#if os(tvOS)
public extension UIViewCreator where View: UIImageView {

    @available(tvOS 13, *)
    @inlinable
    func adjustsImageWhenAncestorFocused(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.adjustsImageWhenAncestorFocused = flag
        }
    }
}
#endif
