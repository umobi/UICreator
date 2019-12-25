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
        return self.collectionViewLayout as! UICollectionViewFlowLayout
    }
}

public extension ViewBuilder where Self: CollectionLayout, Self.Layout: UICollectionViewFlowLayout {
    func line(minimumSpacing: CGFloat) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.dynamicCollectionViewLayout.minimumLineSpacing = minimumSpacing
        }
    }

    func interItem(minimumSpacing: CGFloat) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.dynamicCollectionViewLayout.minimumInteritemSpacing = minimumSpacing
        }
    }

    func item(size: CGSize) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.dynamicCollectionViewLayout.itemSize = size
        }
    }

    func item(relativeHeight height: CGFloat) -> Self {
        return self.appendLayout {
            guard let itemSize = ($0 as? Self)?.dynamicCollectionViewLayout.itemSize else {
                return
            }

            ($0 as? Self)?.dynamicCollectionViewLayout.itemSize = .init(width: itemSize.width, height: $0.bounds.height * height)
        }
    }

    func item(relativeWidth width: CGFloat) -> Self {
        return self.appendLayout {
            guard let itemSize = ($0 as? Self)?.dynamicCollectionViewLayout.itemSize else {
                return
            }

            ($0 as? Self)?.dynamicCollectionViewLayout.itemSize = .init(width: $0.bounds.width * width, height: itemSize.height)
        }
    }

    func item(height: CGFloat) -> Self {
        return self.appendLayout {
            guard let itemSize = ($0 as? Self)?.dynamicCollectionViewLayout.itemSize else {
                return
            }

            ($0 as? Self)?.dynamicCollectionViewLayout.itemSize = .init(width: itemSize.width, height: height)
        }
    }

    func item(width: CGFloat) -> Self {
        return self.appendLayout {
            guard let itemSize = ($0 as? Self)?.dynamicCollectionViewLayout.itemSize else {
                return
            }

            ($0 as? Self)?.dynamicCollectionViewLayout.itemSize = .init(width: width, height: itemSize.height)
        }
    }

    func item(aspectRatioHeight constant: CGFloat) -> Self {
        return self.appendLayout {
            ($0 as? Self)?.dynamicCollectionViewLayout.itemSize = .init(width: $0.bounds.height * constant, height: $0.bounds.height)
        }
    }

    func item(aspectRatioWidth constant: CGFloat) -> Self {
        return self.appendLayout {
            ($0 as? Self)?.dynamicCollectionViewLayout.itemSize = .init(width: $0.bounds.width, height: $0.bounds.width * constant)
        }
    }

    func item(estimatedSize: CGSize) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.dynamicCollectionViewLayout.estimatedItemSize = estimatedSize
        }
    }

    func scroll(direction: ScrollDirection) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.dynamicCollectionViewLayout.scrollDirection = direction
        }
    }

    func header(referenceSize size: CGSize) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.dynamicCollectionViewLayout.headerReferenceSize = size
        }
    }

    func footer(referenceSize size: CGSize) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.dynamicCollectionViewLayout.footerReferenceSize = size
        }
    }

    func section(inset: UIEdgeInsets) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.dynamicCollectionViewLayout.sectionInset = inset
        }
    }

    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    func section(insetReference: Layout.SectionInsetReference) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.dynamicCollectionViewLayout.sectionInsetReference = insetReference
        }
    }

    func section(headersPinToVisibleBounds flag: Bool) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.dynamicCollectionViewLayout.sectionHeadersPinToVisibleBounds = flag
        }
    }

    func section(footersPinToVisibleBounds flag: Bool) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.dynamicCollectionViewLayout.sectionFootersPinToVisibleBounds = flag
        }
    }
}
