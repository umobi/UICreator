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

extension UICCollectionView: ListSupport {}

public extension UICollectionView {
    private typealias CollectionView = UICollectionView & UICollectionViewDataSource & UICollectionViewDelegate & ListSupport

    @discardableResult
    func dynamicData(@UICViewBuilder _ contents: @escaping () -> ViewCreator) -> Self {
        self.onNotRendered {
            let manager = ListManager(contents: contents().zip)
            let collectionView: CollectionView! = $0 as? CollectionView

            manager.rowsIdentifier.forEach {
                collectionView.register(
                    CollectionViewCell.self,
                    forCellWithReuseIdentifier: $0
                )
            }

            manager.headersIdentifier.forEach {
                collectionView.register(
                    CollectionReusableView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: $0
                )
            }

            manager.footersIdentifier.forEach {
                collectionView.register(
                    CollectionReusableView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                    withReuseIdentifier: $0
                )
            }

            collectionView.manager = manager
            collectionView.dataSource = collectionView
            collectionView.delegate = collectionView
            manager.listToken = collectionView.makeToken()
        }
    }
}
