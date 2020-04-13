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

struct MEMCollectionPayload {
    let manager: Mutable<ListCollectionManager?> = .init(value: nil)
    let layoutManager: Mutable<UICCollectionLayoutManager?> = .init(value: nil)
    let layoutManagerCallback: Mutable<(() -> [UICCollectionLayoutSectionElement])?> = .init(value: nil)
}

private var kMEMCollectionPayload: UInt = 0
extension UICollectionView {
    private var collectionPayload: MEMCollectionPayload {
        OBJCSet(self, &kMEMCollectionPayload, policity: .OBJC_ASSOCIATION_COPY) {
            .init()
        }
    }

    var manager: ListCollectionManager? {
        get { self.collectionPayload.manager.value }
        set { self.collectionPayload.manager.value = newValue }
    }

    var layoutManager: UICCollectionLayoutManager? {
        get { self.collectionPayload.layoutManager.value }
        set { self.collectionPayload.layoutManager.value = newValue }
    }

    fileprivate var layoutManagerCallback: (() -> [UICCollectionLayoutSectionElement])? {
        get { self.collectionPayload.layoutManagerCallback.value }
        set { self.collectionPayload.layoutManagerCallback.value = newValue }
    }

    func invalidateLayoutMaker() {
        guard let content = self.layoutManagerCallback else {
            return
        }
        
        self.layoutManager = UICCollectionLayoutManager(contents: content())
        self.invalidateIntrinsicContentSize()
    }
}

public extension UICCollection {
    func layoutMaker(content: @escaping () -> [UICCollectionLayoutSectionElement]) -> Self {
        return self.onInTheScene {
            ($0 as? View)?.layoutManagerCallback = content
            ($0 as? View)?.invalidateLayoutMaker()
        }
    }
}
