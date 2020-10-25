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

internal class FlowCollection: UICollectionView {
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        self.makeSelfImplemented()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        fatalError("init(frame:, collectionViewLayout:) has not been implemented")
    }

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            self.renderManager.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            self.renderManager.frame(newValue)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.renderManager.willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.renderManager.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.renderManager.didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.renderManager.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.renderManager.traitDidChange()
    }

    override open func reloadData() {
        super.reloadData()
        self.invalidateLayoutMaker()
    }
}

public struct UICFlow: UIViewCreator, CollectionLayout {
    public typealias Layout = UICollectionViewFlowLayout
    public typealias View = UICollectionView

    let contents: () -> ViewCreator

    init(@UICViewBuilder contents: @escaping () -> ViewCreator) {
        self.contents = contents
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        FlowCollection()
            .dynamicData((viewCreator as! Self).contents)
    }
}

public extension UIViewCreator where Self: CollectionLayout, Layout: UICollectionViewFlowLayout {
    func line(minimumSpacing: CGFloat) -> UICModifiedView<View> {
        self.onRendered {
            (($0 as? View)?.collectionViewLayout as? Layout)?.minimumLineSpacing = minimumSpacing
        }
    }

    func interItem(minimumSpacing: CGFloat) -> UICModifiedView<View> {
        self.onRendered {
            (($0 as? View)?.collectionViewLayout as? Layout)?.minimumInteritemSpacing = minimumSpacing
        }
    }

    func item(size: CGSize) -> UICModifiedView<View> {
        self.onRendered {
            (($0 as? View)?.collectionViewLayout as? Layout)?.itemSize = size
        }
    }

    func item(relativeHeight height: CGFloat) -> UICModifiedView<View> {
        self.onLayout {
            let collectionLayout: Layout! = ($0 as? View)?.collectionViewLayout as? Layout

            let itemSize = collectionLayout.itemSize
            collectionLayout.itemSize = .init(
                width: itemSize.width,
                height: $0.bounds.height * height
            )
        }
    }

    func item(relativeWidth width: CGFloat) -> UICModifiedView<View> {
        self.onLayout {
            let collectionLayout: Layout! = ($0 as? View)?.collectionViewLayout as? Layout

            let itemSize = collectionLayout.itemSize
            collectionLayout.itemSize = .init(
                width: $0.bounds.width * width,
                height: itemSize.height
            )
        }
    }

    func item(height: CGFloat) -> UICModifiedView<View> {
        self.onLayout {
            let collectionLayout: Layout! = ($0 as? View)?.collectionViewLayout as? Layout

            let itemSize = collectionLayout.itemSize
            collectionLayout.itemSize = .init(
                width: itemSize.width,
                height: height
            )
        }
    }

    func item(width: CGFloat) -> UICModifiedView<View> {
        self.onLayout {
            let collectionLayout: Layout! = ($0 as? View)?.collectionViewLayout as? Layout

            let itemSize = collectionLayout.itemSize
            collectionLayout.itemSize = .init(
                width: width,
                height: itemSize.height
            )
        }
    }

    func item(aspectRatioHeight constant: CGFloat) -> UICModifiedView<View> {
        self.onLayout {
            (($0 as? View)?.collectionViewLayout as? Layout)?.itemSize = .init(
                width: $0.bounds.height * constant,
                height: $0.bounds.height
            )
        }
    }

    func item(aspectRatioWidth constant: CGFloat) -> UICModifiedView<View> {
        self.onLayout {
            (($0 as? View)?.collectionViewLayout as? Layout)?.itemSize = .init(
                width: $0.bounds.width,
                height: $0.bounds.width * constant
            )
        }
    }

    func item(estimatedSize: CGSize) -> UICModifiedView<View> {
        self.onRendered {
            (($0 as? View)?.collectionViewLayout as? Layout)?.estimatedItemSize = estimatedSize
        }
    }

    func scroll(direction: UICollectionView.ScrollDirection) -> UICModifiedView<View> {
        self.onRendered {
            (($0 as? View)?.collectionViewLayout as? Layout)?.scrollDirection = direction
        }
    }

    func header(referenceSize size: CGSize) -> UICModifiedView<View> {
        self.onRendered {
            (($0 as? View)?.collectionViewLayout as? Layout)?.headerReferenceSize = size
        }
    }

    func footer(referenceSize size: CGSize) -> UICModifiedView<View> {
        self.onRendered {
            (($0 as? View)?.collectionViewLayout as? Layout)?.footerReferenceSize = size
        }
    }

    func section(inset: UIEdgeInsets) -> UICModifiedView<View> {
        self.onRendered {
            (($0 as? View)?.collectionViewLayout as? Layout)?.sectionInset = inset
        }
    }

    @available(iOS 11.0, tvOS 11.0, *)
    func section(insetReference: Layout.SectionInsetReference) -> UICModifiedView<View> {
        self.onRendered {
            (($0 as? View)?.collectionViewLayout as? Layout)?.sectionInsetReference = insetReference
        }
    }

    func section(headersPinToVisibleBounds flag: Bool) -> UICModifiedView<View> {
        self.onRendered {
            (($0 as? View)?.collectionViewLayout as? Layout)?.sectionHeadersPinToVisibleBounds = flag
        }
    }

    func section(footersPinToVisibleBounds flag: Bool) -> UICModifiedView<View> {
        self.onRendered {
            (($0 as? View)?.collectionViewLayout as? Layout)?.sectionFootersPinToVisibleBounds = flag
        }
    }
}
