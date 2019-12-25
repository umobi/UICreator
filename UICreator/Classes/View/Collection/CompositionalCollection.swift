//
//  CompositionalCollection.swift
//  UICreator
//
//  Created by brennobemoura on 24/12/19.
//

import Foundation
import UIKit

@available(iOS 13.0, tvOS 13.0, *)
public class CompositionalCollection: Collection, CollectionLayout {
    public var dynamicCollectionViewLayout: UICollectionViewCompositionalLayout {
        return self.collectionViewLayout as! UICollectionViewCompositionalLayout
    }
}
