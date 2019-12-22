//
//  Collection.swift
//  Pods-UICreator_Example
//
//  Created by brennobemoura on 22/12/19.
//

import Foundation

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

@available(iOS 13.0, *)
public class CompositionalCollection: Collection, CollectionLayout {
    public var dynamicCollectionViewLayout: UICollectionViewCompositionalLayout {
        return self.collectionViewLayout as! UICollectionViewCompositionalLayout
    }
}
