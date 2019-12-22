//
//  UICollectionView+ViewBuilder.swift
//  UICreator
//
//  Created by brennobemoura on 22/12/19.
//

import Foundation
import UIKit

public protocol CollectionLayout: UICollectionView {
    associatedtype Layout: UICollectionViewLayout
    var dynamicCollectionViewLayout: Layout { get }
}

public extension ViewBuilder where Self: UICollectionView {
    init(layout: () -> UICollectionViewLayout) {
        self.init(frame: .zero, collectionViewLayout: layout())
    }
}

public extension ViewBuilder where Self: UICollectionView {
    func addCell(for identifier: String, _ cellClass: AnyClass?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.register(cellClass, forCellWithReuseIdentifier: identifier)
        }
    }

    func addCell(for identifier: String, _ uiNib: UINib?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.register(uiNib, forCellWithReuseIdentifier: identifier)
        }
    }

    func addSupplementary(for identifier: String, viewOfKind kind: String, _ cellClass: AnyClass?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.register(cellClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        }
    }

    func addSupplementary(for identifier: String, viewOfKind kind: String, _ uiNib: UINib?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.register(uiNib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        }
    }

    func allowsMultipleSelection(_ flag: Bool) -> Self {
        self.appendRendered {
            ($0 as? Self)?.allowsMultipleSelection = flag
        }
    }

    func allowsSelection(_ flag: Bool) -> Self {
        self.appendRendered {
            ($0 as? Self)?.allowsSelection = flag
        }
    }

    func background(_ content: @escaping () -> UIView) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.backgroundView = Host(content)
        }
    }

    func isPaged(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.isPagingEnabled = flag
        }
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
