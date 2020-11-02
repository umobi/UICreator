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

extension ListSupport where Self: UICollectionViewLayoutCreator {
    @discardableResult
    func dynamicData(@UICViewBuilder _ contents: @escaping () -> ViewCreator) -> Self {
        self.onNotRendered {
            let collectionView: Self! = $0 as? Self

            let modifier = ListState(collectionView, contents().zip)

            collectionView.register(
                modifier.rows,
                modifier.headers,
                modifier.footers
            )

            collectionView.modifier = modifier
            collectionView.strongDataSource(UICCollectionViewDataSource())
            collectionView.strongDelegate(collectionView.provideDelegate())
        }
    }
}

extension ListSupport where Self: UICollectionView {
    @usableFromInline
    func register(
        _ rows: [List.Identifier<String, Row>],
        _ headers: [List.Identifier<String, Row>],
        _ footers: [List.Identifier<String, Row>]) {

        rows.forEach {
            self.register(
                Views.CollectionViewCell.self,
                forCellWithReuseIdentifier: $0.id
            )
        }

        headers.forEach {
            self.register(
                Views.CollectionReusableView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: $0.id
            )
        }

        footers.forEach {
            self.register(
                Views.CollectionReusableView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: $0.id
            )
        }
    }
}

private var kCollectionDelegate = 0
private var kCollectionDataSource = 0
extension UICollectionView {

    func strongDelegate(_ delegate: UICollectionViewDelegate) {
        self.delegate = delegate
        objc_setAssociatedObject(self, &kCollectionDelegate, delegate, .OBJC_ASSOCIATION_RETAIN)
    }

    func strongDataSource(_ dataSource: UICollectionViewDataSource) {
        self.dataSource = dataSource
        objc_setAssociatedObject(self, &kCollectionDataSource, dataSource, .OBJC_ASSOCIATION_RETAIN)
    }
}
