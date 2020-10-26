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

public struct UICImage: UIViewCreator {
    public typealias View = ImageView

    enum Content {
        case uiImage(UIImage)
        case cgImage(CGImage)
        case ciImage(CIImage)

        case contentsOfFile(String)
        case data(Data)

        case named(String)
        case namedWithScheme(String, Bundle?, ColorScheme)
        @available(iOS 13, tvOS 13, *)
        case namedWithConfiguration(String, Bundle?, UIImage.Configuration)

        @available(iOS 13, tvOS 13, *)
        case systemName(String)
        @available(iOS 13, tvOS 13, *)
        case systemNameWithScheme(String, ColorScheme)
        @available(iOS 13, tvOS 13, *)
        case systemNameWithConfiguration(String, UIImage.Configuration)

        var uiImage: UIImage! {
            if #available(iOS 13, tvOS 13, *) {
                switch self {
                case .namedWithConfiguration(let string, let bundle, let configuration):
                    return UIImage(named: string, in: bundle, with: configuration)

                case .systemName(let string):
                    return UIImage(systemName: string)
                case .systemNameWithScheme(let string, let colorScheme):
                    return UIImage(
                        systemName: string,
                        compatibleWith: .init(userInterfaceStyle: colorScheme.uiUserInterfaceStyle)
                    )
                case .systemNameWithConfiguration(let string, let configuration):
                    return UIImage(
                        systemName: string,
                        withConfiguration: configuration
                    )
                default:
                    break
                }
            }

            switch self {
            case .uiImage(let uiImage):
                return uiImage
            case .cgImage(let cgImage):
                return UIImage(cgImage: cgImage)
            case .ciImage(let ciImage):
                return UIImage(ciImage: ciImage)

            case .contentsOfFile(let path):
                return UIImage(contentsOfFile: path)
            case .data(let data):
                return UIImage(data: data)

            case .named(let string):
                return UIImage(named: string)
            case .namedWithScheme(let string, let bundle, let colorScheme):
                if #available(iOS 12, tvOS 12, *) {
                    return UIImage(
                        named: string,
                        in: bundle,
                        compatibleWith: .init(userInterfaceStyle: colorScheme.uiUserInterfaceStyle)
                    )
                }

                return UIImage(
                    named: string,
                    in: bundle,
                    compatibleWith: nil
                )
            default:
                fatalError()
            }
        }
    }

    let content: Content
    let contentMode: ContentMode

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

    public var uiImage: UIImage {
        self.content.uiImage
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return ImageView()
            .onNotRendered {
                ($0 as? View)?.image = _self.content.uiImage
                ($0 as? View)?.contentMode = _self.contentMode.uiContentMode
            }
    }

    private init(uiImage: UIImage, contentMode: ContentMode) {
        self.content = .uiImage(uiImage)
        self.contentMode = contentMode
    }

    public func contentMode(_ contentMode: ContentMode) -> Self {
        .init(
            uiImage: self.uiImage,
            contentMode: contentMode
        )
    }

    fileprivate func modify(_ edit: (UIImage) -> UIImage?) -> UICImage {
        guard let uiImage = edit(self.uiImage) else {
            return self
        }

        return .init(uiImage: uiImage)
    }
}

public extension UICImage {

    @available(iOS 13, tvOS 13.0, *)
    func applySymbolConfiguration(_ configuration: UIImage.SymbolConfiguration) -> Self {
        self.modify {
            $0.applyingSymbolConfiguration(configuration)
        }
    }

    func renderingMode(_ mode: UIImage.RenderingMode) -> Self {
        self.modify {
            $0.withRenderingMode(mode)
        }
    }

    @available(iOS 13, tvOS 13, *)
    func tintColor(_ color: UIColor) -> Self {
        self.modify {
            $0.withTintColor(color)
        }
    }

    @available(iOS 13, tvOS 13, *)
    func tintColor(_ color: UIColor, renderingMode: UIImage.RenderingMode) -> Self {
        self.modify {
            $0.withTintColor(color, renderingMode: renderingMode)
        }
    }

    func flippedForRightToLeftLayoutDirection() -> Self {
        self.modify {
            $0.imageFlippedForRightToLeftLayoutDirection()
        }
    }

    func horizontallyFlippedOrientation() -> Self {
        self.modify {
            $0.withHorizontallyFlippedOrientation()
        }
    }

    @available(iOS 13, tvOS 13, *)
    func withoutBaseline() -> Self {
        self.modify {
            $0.imageWithoutBaseline()
        }
    }

    @available(iOS 13, tvOS 13, *)
    func configuration(_ configuration: UIImage.Configuration) -> Self {
        self.modify {
            $0.withConfiguration(configuration)
        }
    }

    func resizableWithCapInsets(_ insets: UIEdgeInsets) -> Self {
        self.modify {
            $0.resizableImage(withCapInsets: insets)
        }
    }

    func resizableWithCapInsets(_ insets: UIEdgeInsets, resizingMode: UIImage.ResizingMode) -> Self {
        self.modify {
            $0.resizableImage(withCapInsets: insets, resizingMode: resizingMode)
        }
    }

    func stretchableWith(leftCapWidth: Int, topCapHeight: Int) -> Self {
        self.modify {
            $0.stretchableImage(withLeftCapWidth: leftCapWidth, topCapHeight: topCapHeight)
        }
    }

    func alignmentRectInsets(_ insets: UIEdgeInsets) -> Self {
        self.modify {
            $0.withAlignmentRectInsets(insets)
        }
    }

    @available(iOS 13, tvOS 13, *)
    func baselineOffsets(fromBottom offset: CGFloat) -> Self {
        self.modify {
            $0.withBaselineOffset(fromBottom: offset)
        }
    }
}

@available(iOS 13, tvOS 13, *)
public extension UICImage {
    static var actions: Self {
        .init(uiImage: .actions)
    }

    static var add: Self {
        .init(uiImage: .add)
    }

    static var checkmark: Self {
        .init(uiImage: .checkmark)
    }

    static var remove: Self {
        .init(uiImage: .remove)
    }

    static var strokedCheckmark: Self {
        .init(uiImage: .strokedCheckmark)
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
