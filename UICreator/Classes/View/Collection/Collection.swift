//
//  Collection.swift
//  Pods-UICreator_Example
//
//  Created by brennobemoura on 22/12/19.
//

import Foundation

public protocol CollectionLayout {
    associatedtype Layout: UICollectionViewLayout
    var dynamicCollectionViewLayout: Layout { get }
}

public class CollectionView: UICollectionView {
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

public class Collection: UIViewCreator, HasViewDelegate, HasViewDataSource {
    public typealias View = CollectionView
    init(layout: () -> UICollectionViewLayout) {
        self.uiView = View(frame: .zero, collectionViewLayout: layout())
    }

    public func delegate(_ delegate: UICollectionViewDelegate?) -> Self {
        (self.uiView as? View)?.delegate = delegate
        return self
    }

    public func dataSource(_ dataSource: UICollectionViewDataSource?) -> Self {
        (self.uiView as? View)?.dataSource = dataSource
        return self
    }
}


public extension UIViewCreator where View: UICollectionView {
    func addCell(for identifier: String, _ cellClass: AnyClass?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.register(cellClass, forCellWithReuseIdentifier: identifier)
        }
    }

    func addCell(for identifier: String, _ uiNib: UINib?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.register(uiNib, forCellWithReuseIdentifier: identifier)
        }
    }

    func addSupplementary(for identifier: String, viewOfKind kind: String, _ cellClass: AnyClass?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.register(cellClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        }
    }

    func addSupplementary(for identifier: String, viewOfKind kind: String, _ uiNib: UINib?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.register(uiNib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        }
    }

    func allowsMultipleSelection(_ flag: Bool) -> Self {
        self.onRendered {
            ($0 as? View)?.allowsMultipleSelection = flag
        }
    }

    func allowsSelection(_ flag: Bool) -> Self {
        self.onRendered {
            ($0 as? View)?.allowsSelection = flag
        }
    }

    func background<Background: ViewCreator>(_ content: @escaping () -> Background) -> Self {
        self.onNotRendered {
            ($0 as? View)?.backgroundView = Host(content: content).uiView
        }
    }

    #if os(iOS)
    func isPaged(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.isPagingEnabled = flag
        }
    }
    #endif
}
