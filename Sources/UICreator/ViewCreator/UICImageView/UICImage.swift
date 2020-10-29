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
public struct UICImage: UIViewCreator {
    public typealias View = UIImageView

    private let content: Content
    private let contentMode: ContentMode

    public init(uiImage: UIImage) {
        self.content = .uiImage(uiImage)
        self.contentMode = .fit
    }

    public init(ciImage: CIImage) {
        self.content = .ciImage(ciImage)
        self.contentMode = .fit
    }

    public init(cgImage: CGImage) {
        self.content = .cgImage(cgImage)
        self.contentMode = .fit
    }

    public init(contentsOfFile path: String) {
        self.content = .contentsOfFile(path)
        self.contentMode = .fit
    }

    public init(data: Data) {
        self.content = .data(data)
        self.contentMode = .fit
    }

    public init(named: String) {
        self.content = .named(named)
        self.contentMode = .fit
    }

    public init(named: String, bundle: Bundle? = nil, colorScheme: ColorScheme) {
        self.content = .namedWithScheme(named, bundle, colorScheme)
        self.contentMode = .fit
    }

    @available(iOS 13, tvOS 13, *)
    public init(named: String, bundle: Bundle? = nil, configuration: UIImage.Configuration) {
        self.content = .namedWithConfiguration(named, bundle, configuration)
        self.contentMode = .fit
    }

    @available(iOS 13, tvOS 13, *)
    public init(systemName: String) {
        self.content = .systemName(systemName)
        self.contentMode = .fit
    }

    @available(iOS 13, tvOS 13, *)
    public init(systemName: String, colorScheme: ColorScheme) {
        self.content = .systemNameWithScheme(systemName, colorScheme)
        self.contentMode = .fit
    }

    @available(iOS 13, tvOS 13, *)
    public init(systemName: String, configuration: UIImage.Configuration) {
        self.content = .systemNameWithConfiguration(systemName, configuration)
        self.contentMode = .fit
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return Views.ImageView()
            .onNotRendered {
                ($0 as? View)?.image = _self.content.uiImage
                ($0 as? View)?.contentMode = _self.contentMode.uiContentMode
            }
    }
}

extension UICImage {

    @usableFromInline
    init(uiImage: UIImage, contentMode: ContentMode) {
        self.content = .uiImage(uiImage)
        self.contentMode = contentMode
    }

    @usableFromInline
    func modify(_ edit: (UIImage) -> UIImage?) -> UICImage {
        guard let uiImage = edit(self.uiImage) else {
            return self
        }

        return .init(uiImage: uiImage)
    }
}

public extension UICImage {

    @inlinable
    func contentMode(_ contentMode: ContentMode) -> Self {
        .init(
            uiImage: self.uiImage,
            contentMode: contentMode
        )
    }

    @inline(__always)
    var uiImage: UIImage {
        self.content.uiImage
    }
}

public extension UICImage {

    @available(iOS 13, tvOS 13.0, *)
    @inlinable
    func applySymbolConfiguration(_ configuration: UIImage.SymbolConfiguration) -> Self {
        self.modify {
            $0.applyingSymbolConfiguration(configuration)
        }
    }

    @inlinable
    func renderingMode(_ mode: UIImage.RenderingMode) -> Self {
        self.modify {
            $0.withRenderingMode(mode)
        }
    }

    @available(iOS 13, tvOS 13, *)
    @inlinable
    func tintColor(_ color: UIColor) -> Self {
        self.modify {
            $0.withTintColor(color)
        }
    }

    @available(iOS 13, tvOS 13, *)
    @inlinable
    func tintColor(_ color: UIColor, renderingMode: UIImage.RenderingMode) -> Self {
        self.modify {
            $0.withTintColor(color, renderingMode: renderingMode)
        }
    }

    @inlinable
    func flippedForRightToLeftLayoutDirection() -> Self {
        self.modify {
            $0.imageFlippedForRightToLeftLayoutDirection()
        }
    }

    @inlinable
    func horizontallyFlippedOrientation() -> Self {
        self.modify {
            $0.withHorizontallyFlippedOrientation()
        }
    }

    @available(iOS 13, tvOS 13, *)
    @inlinable
    func withoutBaseline() -> Self {
        self.modify {
            $0.imageWithoutBaseline()
        }
    }

    @available(iOS 13, tvOS 13, *)
    @inlinable
    func configuration(_ configuration: UIImage.Configuration) -> Self {
        self.modify {
            $0.withConfiguration(configuration)
        }
    }

    @inlinable
    func resizableWithCapInsets(_ insets: UIEdgeInsets) -> Self {
        self.modify {
            $0.resizableImage(withCapInsets: insets)
        }
    }

    @inlinable
    func resizableWithCapInsets(_ insets: UIEdgeInsets, resizingMode: UIImage.ResizingMode) -> Self {
        self.modify {
            $0.resizableImage(withCapInsets: insets, resizingMode: resizingMode)
        }
    }

    @inlinable
    func stretchableWith(leftCapWidth: Int, topCapHeight: Int) -> Self {
        self.modify {
            $0.stretchableImage(withLeftCapWidth: leftCapWidth, topCapHeight: topCapHeight)
        }
    }

    @inlinable
    func alignmentRectInsets(_ insets: UIEdgeInsets) -> Self {
        self.modify {
            $0.withAlignmentRectInsets(insets)
        }
    }

    @available(iOS 13, tvOS 13, *)
    @inlinable
    func baselineOffsets(fromBottom offset: CGFloat) -> Self {
        self.modify {
            $0.withBaselineOffset(fromBottom: offset)
        }
    }
}

@available(iOS 13, tvOS 13, *)
public extension UICImage {

    @inline(__always)
    static var actions: Self {
        .init(uiImage: .actions)
    }

    @inline(__always)
    static var add: Self {
        .init(uiImage: .add)
    }

    @inline(__always)
    static var checkmark: Self {
        .init(uiImage: .checkmark)
    }

    @inline(__always)
    static var remove: Self {
        .init(uiImage: .remove)
    }

    @inline(__always)
    static var strokedCheckmark: Self {
        .init(uiImage: .strokedCheckmark)
    }
}
