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

extension UIFont {
    @usableFromInline
    static func stylizedFont(_ style: TextStyle, _ weight: Weight) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        var attributes = descriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        traits[.weight] = weight
        attributes[.traits] = traits
        return .init(descriptor: descriptor.addingAttributes(attributes), size: .zero)
    }
}

public extension UIFont {
    #if os(iOS)
    @inline(__always) @inlinable @available(iOS 11.0, *)
    static var largeTitle: UIFont {
        stylizedFont(.largeTitle, .regular)
    }
    #endif

    @inline(__always) @inlinable
    static var title1: UIFont {
        .stylizedFont(.title1, .regular)
    }

    @inline(__always) @inlinable
    static var title2: UIFont {
        stylizedFont(.title2, .regular)
    }

    @inline(__always) @inlinable
    static var title3: UIFont {
        stylizedFont(.title3, .regular)
    }

    @inline(__always) @inlinable
    static var headline: UIFont {
        stylizedFont(.headline, .regular)
    }

    @inline(__always) @inlinable
    static var subheadline: UIFont {
        stylizedFont(.subheadline, .regular)
    }

    @inline(__always) @inlinable
    static var body: UIFont {
        stylizedFont(.body, .regular)
    }

    @inline(__always) @inlinable
    static var callout: UIFont {
        stylizedFont(.callout, .regular)
    }

    @inline(__always) @inlinable
    static var footnote: UIFont {
        stylizedFont(.footnote, .regular)
    }

    @inline(__always) @inlinable
    static var caption1: UIFont {
        stylizedFont(.caption1, .regular)
    }

    @inline(__always) @inlinable
    static var caption2: UIFont {
        stylizedFont(.caption2, .regular)
    }
}

public extension UIFont {
    #if os(iOS)
    @inline(__always) @inlinable @available(iOS 11.0, *)
    static func largeTitle(weight: Weight) -> UIFont {
        stylizedFont(.largeTitle, weight)
    }
    #endif

    @inline(__always) @inlinable
    static func title1(weight: Weight) -> UIFont {
        stylizedFont(.title1, weight)
    }

    @inline(__always) @inlinable
    static func title2(weight: Weight) -> UIFont {
        stylizedFont(.title2, weight)
    }

    @inline(__always) @inlinable
    static func title3(weight: Weight) -> UIFont {
        stylizedFont(.title3, weight)
    }

    @inline(__always) @inlinable
    static func headline(weight: Weight) -> UIFont {
        stylizedFont(.headline, weight)
    }

    @inline(__always) @inlinable
    static func subheadline(weight: Weight) -> UIFont {
        stylizedFont(.subheadline, weight)
    }

    @inline(__always) @inlinable
    static func body(weight: Weight) -> UIFont {
        stylizedFont(.body, weight)
    }

    @inline(__always) @inlinable
    static func callout(weight: Weight) -> UIFont {
        stylizedFont(.callout, weight)
    }

    @inline(__always) @inlinable
    static func footnote(weight: Weight) -> UIFont {
        stylizedFont(.footnote, weight)
    }

    @inline(__always) @inlinable
    static func caption1(weight: Weight) -> UIFont {
        stylizedFont(.caption1, weight)
    }

    @inline(__always) @inlinable
    static func caption2(weight: Weight) -> UIFont {
        stylizedFont(.caption2, weight)
    }
}
