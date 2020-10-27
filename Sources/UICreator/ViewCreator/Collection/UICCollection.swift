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
import ConstraintBuilder

@frozen
public struct UICCollection<Layout>: UIViewCreator where Layout: UICCollectionViewLayoutCreator {
    public typealias View = Views.CollectionView<Layout>

    private let layout: Layout
    private let contents: () -> ViewCreator

    public init(
        layout: Layout,
        @UICViewBuilder contents: @escaping () -> ViewCreator) {
        self.layout = layout
        self.contents = contents
    }

    @inline(__always)
    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return Views.CollectionView(_self.layout)
            .dynamicData((viewCreator as! Self).contents)
    }
}

public extension UIViewCreator where View: UICollectionView {
    @inlinable
    func allowsMultipleSelection(_ flag: Bool) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.allowsMultipleSelection = flag
        }
    }

    @inlinable
    func allowsSelection(_ flag: Bool) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.allowsSelection = flag
        }
    }

    @inlinable
    func background<Background: ViewCreator>(_ content: @escaping () -> Background) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.backgroundView = UICAnyView(content).releaseUIView()
        }
    }

    #if os(iOS)
    @inlinable
    func isPaged(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.isPagingEnabled = flag
        }
    }
    #endif
}
