//
//  FlowCollection.swift
//  UICreator
//
//  Created by brennobemoura on 24/12/19.
//

import Foundation

public class FlowCollection: Collection, CollectionLayout {
    public convenience init() {
        self.init {
            UICollectionViewFlowLayout()
        }
    }

    public var dynamicCollectionViewLayout: UICollectionViewFlowLayout {
        return (self.uiView as? View)?.collectionViewLayout as! UICollectionViewFlowLayout
    }
}

public extension FlowCollection {
    func line(minimumSpacing: CGFloat) -> Self {
        return self.onRendered { _ in
            self.dynamicCollectionViewLayout.minimumLineSpacing = minimumSpacing
        }
    }

    func interItem(minimumSpacing: CGFloat) -> Self {
        return self.onRendered { _ in
            self.dynamicCollectionViewLayout.minimumInteritemSpacing = minimumSpacing
        }
    }

    func item(size: CGSize) -> Self {
        return self.onRendered { _ in
            self.dynamicCollectionViewLayout.itemSize = size
        }
    }

    func item(relativeHeight height: CGFloat) -> Self {
        return self.onLayout {
            let itemSize = self.dynamicCollectionViewLayout.itemSize
            self.dynamicCollectionViewLayout.itemSize = .init(width: itemSize.width, height: $0.bounds.height * height)
        }
    }

    func item(relativeWidth width: CGFloat) -> Self {
        return self.onLayout {
            let itemSize = self.dynamicCollectionViewLayout.itemSize
            self.dynamicCollectionViewLayout.itemSize = .init(width: $0.bounds.width * width, height: itemSize.height)
        }
    }

    func item(height: CGFloat) -> Self {
        return self.onLayout { _ in
            let itemSize = self.dynamicCollectionViewLayout.itemSize
            self.dynamicCollectionViewLayout.itemSize = .init(width: itemSize.width, height: height)
        }
    }

    func item(width: CGFloat) -> Self {
        return self.onLayout { _ in
            let itemSize = self.dynamicCollectionViewLayout.itemSize
            self.dynamicCollectionViewLayout.itemSize = .init(width: width, height: itemSize.height)
        }
    }

    func item(aspectRatioHeight constant: CGFloat) -> Self {
        return self.onLayout {
            self.dynamicCollectionViewLayout.itemSize = .init(width: $0.bounds.height * constant, height: $0.bounds.height)
        }
    }

    func item(aspectRatioWidth constant: CGFloat) -> Self {
        return self.onLayout {
            self.dynamicCollectionViewLayout.itemSize = .init(width: $0.bounds.width, height: $0.bounds.width * constant)
        }
    }

    func item(estimatedSize: CGSize) -> Self {
        return self.onRendered { _ in
            self.dynamicCollectionViewLayout.estimatedItemSize = estimatedSize
        }
    }

    func scroll(direction: UICollectionView.ScrollDirection) -> Self {
        return self.onRendered { _ in
            self.dynamicCollectionViewLayout.scrollDirection = direction
        }
    }

    func header(referenceSize size: CGSize) -> Self {
        return self.onRendered { _ in
            self.dynamicCollectionViewLayout.headerReferenceSize = size
        }
    }

    func footer(referenceSize size: CGSize) -> Self {
        return self.onRendered { _ in
            self.dynamicCollectionViewLayout.footerReferenceSize = size
        }
    }

    func section(inset: UIEdgeInsets) -> Self {
        return self.onRendered { _ in
            self.dynamicCollectionViewLayout.sectionInset = inset
        }
    }

    @available(iOS 11.0, tvOS 11.0, *)
    func section(insetReference: Layout.SectionInsetReference) -> Self {
        return self.onRendered { _ in
            self.dynamicCollectionViewLayout.sectionInsetReference = insetReference
        }
    }

    func section(headersPinToVisibleBounds flag: Bool) -> Self {
        return self.onRendered { _ in
            self.dynamicCollectionViewLayout.sectionHeadersPinToVisibleBounds = flag
        }
    }

    func section(footersPinToVisibleBounds flag: Bool) -> Self {
        return self.onRendered { _ in
            self.dynamicCollectionViewLayout.sectionFootersPinToVisibleBounds = flag
        }
    }
}
