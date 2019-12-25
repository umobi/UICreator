//
//  Collection.swift
//  Pods-UICreator_Example
//
//  Created by brennobemoura on 22/12/19.
//

import Foundation

public protocol CollectionLayout: UICollectionView {
    associatedtype Layout: UICollectionViewLayout
    var dynamicCollectionViewLayout: Layout { get }
}

public class Collection: UICollectionView, ViewBuilder, HasViewDelegate, HasViewDataSource {
    public func delegate(_ delegate: UICollectionViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }

    public func dataSource(_ dataSource: UICollectionViewDataSource?) -> Self {
        self.dataSource = dataSource
        return self
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.commitNotRendered()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }
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
        self.appendBeforeRendering {
            ($0 as? Self)?.backgroundView = Host(content)
        }
    }

    #if os(iOS)
    func isPaged(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.isPagingEnabled = flag
        }
    }
    #endif
}
