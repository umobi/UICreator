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

private extension UIFont {
    static func stylizedFont(_ style: TextStyle,_ weight: Weight) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        var attributes = descriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        traits[.weight] = weight
        attributes[.traits] = traits
        return .init(descriptor: descriptor.addingAttributes(attributes), size: .zero)
    }
}

public extension UIFont {
    @available(iOS 11.0, *)
    static var largeTitle: UIFont {
        return .stylizedFont(.largeTitle, .regular)
    }

    @available(iOS 9.0, *)
    static var title1: UIFont {
        return .stylizedFont(.title1, .regular)
    }

    @available(iOS 9.0, *)
    static var title2: UIFont {
        return .stylizedFont(.title2, .regular)
    }

    @available(iOS 9.0, *)
    static var title3: UIFont {
        return .stylizedFont(.title3, .regular)
    }

    @available(iOS 7.0, *)
    static var headline: UIFont {
        return .stylizedFont(.headline, .regular)
    }

    @available(iOS 7.0, *)
    static var subheadline: UIFont {
        return .stylizedFont(.subheadline, .regular)
    }

    @available(iOS 7.0, *)
    static var body: UIFont {
        return .stylizedFont(.body, .regular)
    }

    @available(iOS 9.0, *)
    static var callout: UIFont {
        return .stylizedFont(.callout, .regular)
    }

    @available(iOS 7.0, *)
    static var footnote: UIFont {
        return .stylizedFont(.footnote, .regular)
    }

    @available(iOS 7.0, *)
    static var caption1: UIFont {
        return .stylizedFont(.caption1, .regular)
    }

    @available(iOS 7.0, *)
    static var caption2: UIFont {
        return .stylizedFont(.caption2, .regular)
    }
}


public extension UIFont {
    @available(iOS 11.0, *)
    static func largeTitle(weight: Weight) -> UIFont {
        return .stylizedFont(.largeTitle, weight)
    }

    @available(iOS 9.0, *)
    static func title1(weight: Weight) -> UIFont {
        return .stylizedFont(.title1, weight)
    }

    @available(iOS 9.0, *)
    static func title2(weight: Weight) -> UIFont {
        return .stylizedFont(.title2, weight)
    }

    @available(iOS 9.0, *)
    static func title3(weight: Weight) -> UIFont {
        return .stylizedFont(.title3, weight)
    }

    @available(iOS 7.0, *)
    static func headline(weight: Weight) -> UIFont {
        return .stylizedFont(.headline, weight)
    }

    @available(iOS 7.0, *)
    static func subheadline(weight: Weight) -> UIFont {
        return .stylizedFont(.subheadline, weight)
    }

    @available(iOS 7.0, *)
    static func body(weight: Weight) -> UIFont {
        return .stylizedFont(.body, weight)
    }

    @available(iOS 9.0, *)
    static func callout(weight: Weight) -> UIFont {
        return .stylizedFont(.callout, weight)
    }

    @available(iOS 7.0, *)
    static func footnote(weight: Weight) -> UIFont {
        return .stylizedFont(.footnote, weight)
    }

    @available(iOS 7.0, *)
    static func caption1(weight: Weight) -> UIFont {
        return .stylizedFont(.caption1, weight)
    }

    @available(iOS 7.0, *)
    static func caption2(weight: Weight) -> UIFont {
        return .stylizedFont(.caption2, weight)
    }
}
