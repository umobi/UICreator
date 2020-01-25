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

private var kCollectionGroup: UInt = 0
private var kCollectionDataSource: UInt = 0
private var kCollectionDelegate: UInt = 0
private var kCollectionLayoutGroup: UInt = 0

extension UICollectionView {
    var group: UICListCollectionElements? {
        get { objc_getAssociatedObject(self, &kCollectionGroup) as? UICListCollectionElements }
        set { objc_setAssociatedObject(self, &kCollectionGroup, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var layoutGroup: [CollectionLayoutSection]? {
        get { objc_getAssociatedObject(self, &kCollectionLayoutGroup) as? [CollectionLayoutSection] }
        set { objc_setAssociatedObject(self, &kCollectionLayoutGroup, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var creatorDataSource: CollectionDataSource? {
        get { objc_getAssociatedObject(self, &kCollectionDataSource) as? CollectionDataSource }
        set { objc_setAssociatedObject(self, &kCollectionDataSource, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var creatorDelegate: TableDelegate? {
        get { objc_getAssociatedObject(self, &kCollectionDelegate) as? TableDelegate }
        set { objc_setAssociatedObject(self, &kCollectionDelegate, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}
