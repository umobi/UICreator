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
public struct UICFlow: UIViewCreator {
    public typealias View = Views.FlowView

    private let contents: () -> ViewCreator

    public init(@UICViewBuilder contents: @escaping () -> ViewCreator) {
        self.contents = contents
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        Views.FlowView()
            .dynamicData((viewCreator as! Self).contents)
    }
}

public extension UIViewCreator where View: UICollectionViewLayoutCreator, View.CollectionLayout: UICollectionViewFlowLayout {

    @inlinable
    func line(minimumSpacing: CGFloat) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.minimumLineSpacing = minimumSpacing
        }
    }

    @inlinable
    func interItem(minimumSpacing: CGFloat) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.minimumInteritemSpacing = minimumSpacing
        }
    }

    @inlinable
    func item(size: CGSize) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.itemSize = size
        }
    }

    @inlinable
    func item(relativeHeight height: CGFloat) -> UICLayoutModifier<View> {
        self.onLayout {
            let collectionLayout: View.CollectionLayout! = ($0 as? View)?.castedCollectionViewLayout

            let itemSize = collectionLayout.itemSize
            collectionLayout.itemSize = .init(
                width: itemSize.width,
                height: $0.bounds.height * height
            )
        }
    }

    @inlinable
    func item(relativeWidth width: CGFloat) -> UICLayoutModifier<View> {
        self.onLayout {
            let collectionLayout: View.CollectionLayout! = ($0 as? View)?.castedCollectionViewLayout

            let itemSize = collectionLayout.itemSize
            collectionLayout.itemSize = .init(
                width: $0.bounds.width * width,
                height: itemSize.height
            )
        }
    }

    @inlinable
    func item(height: CGFloat) -> UICLayoutModifier<View> {
        self.onLayout {
            let collectionLayout: View.CollectionLayout! = ($0 as? View)?.castedCollectionViewLayout

            let itemSize = collectionLayout.itemSize
            collectionLayout.itemSize = .init(
                width: itemSize.width,
                height: height
            )
        }
    }

    @inlinable
    func item(width: CGFloat) -> UICLayoutModifier<View> {
        self.onLayout {
            let collectionLayout: View.CollectionLayout! = ($0 as? View)?.castedCollectionViewLayout

            let itemSize = collectionLayout.itemSize
            collectionLayout.itemSize = .init(
                width: width,
                height: itemSize.height
            )
        }
    }

    @inlinable
    func item(aspectRatioHeight constant: CGFloat) -> UICLayoutModifier<View> {
        self.onLayout {
            ($0 as? View)?.castedCollectionViewLayout.itemSize = .init(
                width: $0.bounds.height * constant,
                height: $0.bounds.height
            )
        }
    }

    @inlinable
    func item(aspectRatioWidth constant: CGFloat) -> UICLayoutModifier<View> {
        self.onLayout {
            ($0 as? View)?.castedCollectionViewLayout.itemSize = .init(
                width: $0.bounds.width,
                height: $0.bounds.width * constant
            )
        }
    }

    @inlinable
    func item(estimatedSize: CGSize) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.estimatedItemSize = estimatedSize
        }
    }

    @inlinable
    func scroll(direction: UICollectionView.ScrollDirection) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.scrollDirection = direction
        }
    }

    @inlinable
    func header(referenceSize size: CGSize) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.headerReferenceSize = size
        }
    }

    @inlinable
    func footer(referenceSize size: CGSize) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.footerReferenceSize = size
        }
    }

    @inlinable
    func section(inset: UIEdgeInsets) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.sectionInset = inset
        }
    }

    @available(iOS 11.0, tvOS 11.0, *) @inlinable
    func section(insetReference: UICollectionViewFlowLayout.SectionInsetReference) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.sectionInsetReference = insetReference
        }
    }

    @inlinable
    func section(headersPinToVisibleBounds flag: Bool) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.sectionHeadersPinToVisibleBounds = flag
        }
    }

    @inlinable
    func section(footersPinToVisibleBounds flag: Bool) -> UICRenderedModifier<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.sectionFootersPinToVisibleBounds = flag
        }
    }
}
