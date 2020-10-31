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

private var kMEMCollectionPayload: UInt = 0
private extension UICollectionView {
    struct Memory {
        @MutableBox var manager: ListCollectionManager?
        @MutableBox var modifier: ListModifier?
        @MutableBox var layoutManager: UICCollectionLayoutManager?
        @MutableBox var layoutManagerHandler: (() -> UICCollectionLayoutSectionElement)?
    }

    var memory: Memory {
        OBJCSet(
            self,
            &kMEMCollectionPayload,
            policity: .OBJC_ASSOCIATION_COPY,
            orLoad: Memory.init
        )
    }
}

extension UICollectionView {
    @inline(__always) @usableFromInline
    var manager: ListCollectionManager? {
        get { self.memory.manager }
        set { self.memory.manager = newValue }
    }

    @inline(__always) @usableFromInline
    var modifier: ListModifier? {
        get { self.memory.modifier }
        set { self.memory.modifier = newValue }
    }

    @inline(__always)
    var layoutManager: UICCollectionLayoutManager? {
        get { self.memory.layoutManager }
        set { self.memory.layoutManager = newValue }
    }

    @inline(__always)
    fileprivate var layoutManagerHandler: (() -> UICCollectionLayoutSectionElement)? {
        get { self.memory.layoutManagerHandler }
        set { self.memory.layoutManagerHandler = newValue }
    }

    func invalidateLayoutMaker() {
        guard let content = self.layoutManagerHandler else {
            return
        }

        self.layoutManager = UICCollectionLayoutManager(contents: content().zip)
        self.invalidateIntrinsicContentSize()
    }
}

public extension UIViewCreator where View: UICollectionView {
    func layoutMaker(
        @UICCollectionLayoutSectionBuilder content:
            @escaping () -> UICCollectionLayoutSectionElement) -> UICModifiedView<View> {

        self.onInTheScene {
            ($0 as? View)?.layoutManagerHandler = content
            ($0 as? View)?.invalidateLayoutMaker()
        }
    }
}
