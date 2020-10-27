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

public protocol UICollectionViewLayoutCreator: UICollectionView {
    associatedtype CollectionLayout: UICollectionViewLayout

    func provideDelegate() -> UICollectionViewDelegate
}

public extension UICollectionViewLayoutCreator {
    var castedCollectionViewLayout: CollectionLayout {
        self.collectionViewLayout as! CollectionLayout
    }
}

class UICCollectionViewDelegateFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return collectionView.sizeForItem(at: indexPath)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {

        return collectionView.sizeForHeader(at: section) ?? .zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int) -> CGSize {

        return collectionView.sizeForFooter(at: section) ?? .zero
    }
}

public class UICFlowView: UICollectionView, ListSupport, UICollectionViewLayoutCreator {
    public typealias CollectionLayout = UICollectionViewFlowLayout

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        self.makeSelfImplemented()
    }

    public func provideDelegate() -> UICollectionViewDelegate {
        UICCollectionViewDelegateFlowLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        fatalError("init(frame:, collectionViewLayout:) has not been implemented")
    }

    public override var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            self.renderManager.isHidden(newValue)
        }
    }

    public override var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            self.renderManager.frame(newValue)
        }
    }

    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.renderManager.willMove(toSuperview: newSuperview)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.renderManager.didMoveToSuperview()
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        self.renderManager.didMoveToWindow()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.renderManager.layoutSubviews()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.renderManager.traitDidChange()
    }

    public override func reloadData() {
        super.reloadData()
        self.invalidateLayoutMaker()
    }
}

public struct UICFlow: UIViewCreator {
    public typealias View = UICFlowView

    private let contents: () -> ViewCreator

    public init(@UICViewBuilder contents: @escaping () -> ViewCreator) {
        self.contents = contents
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        UICFlowView()
            .dynamicData((viewCreator as! Self).contents)
    }
}

public extension UIViewCreator where View: UICollectionViewLayoutCreator, View.CollectionLayout: UICollectionViewFlowLayout {

    func line(minimumSpacing: CGFloat) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.minimumLineSpacing = minimumSpacing
        }
    }

    func interItem(minimumSpacing: CGFloat) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.minimumInteritemSpacing = minimumSpacing
        }
    }

    func item(size: CGSize) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.itemSize = size
        }
    }

    func item(relativeHeight height: CGFloat) -> UICModifiedView<View> {
        self.onLayout {
            let collectionLayout: View.CollectionLayout! = ($0 as? View)?.castedCollectionViewLayout

            let itemSize = collectionLayout.itemSize
            collectionLayout.itemSize = .init(
                width: itemSize.width,
                height: $0.bounds.height * height
            )
        }
    }

    func item(relativeWidth width: CGFloat) -> UICModifiedView<View> {
        self.onLayout {
            let collectionLayout: View.CollectionLayout! = ($0 as? View)?.castedCollectionViewLayout

            let itemSize = collectionLayout.itemSize
            collectionLayout.itemSize = .init(
                width: $0.bounds.width * width,
                height: itemSize.height
            )
        }
    }

    func item(height: CGFloat) -> UICModifiedView<View> {
        self.onLayout {
            let collectionLayout: View.CollectionLayout! = ($0 as? View)?.castedCollectionViewLayout

            let itemSize = collectionLayout.itemSize
            collectionLayout.itemSize = .init(
                width: itemSize.width,
                height: height
            )
        }
    }

    func item(width: CGFloat) -> UICModifiedView<View> {
        self.onLayout {
            let collectionLayout: View.CollectionLayout! = ($0 as? View)?.castedCollectionViewLayout

            let itemSize = collectionLayout.itemSize
            collectionLayout.itemSize = .init(
                width: width,
                height: itemSize.height
            )
        }
    }

    func item(aspectRatioHeight constant: CGFloat) -> UICModifiedView<View> {
        self.onLayout {
            ($0 as? View)?.castedCollectionViewLayout.itemSize = .init(
                width: $0.bounds.height * constant,
                height: $0.bounds.height
            )
        }
    }

    func item(aspectRatioWidth constant: CGFloat) -> UICModifiedView<View> {
        self.onLayout {
            ($0 as? View)?.castedCollectionViewLayout.itemSize = .init(
                width: $0.bounds.width,
                height: $0.bounds.width * constant
            )
        }
    }

    func item(estimatedSize: CGSize) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.estimatedItemSize = estimatedSize
        }
    }

    func scroll(direction: UICollectionView.ScrollDirection) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.scrollDirection = direction
        }
    }

    func header(referenceSize size: CGSize) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.headerReferenceSize = size
        }
    }

    func footer(referenceSize size: CGSize) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.footerReferenceSize = size
        }
    }

    func section(inset: UIEdgeInsets) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.sectionInset = inset
        }
    }

    @available(iOS 11.0, tvOS 11.0, *)
    func section(insetReference: UICollectionViewFlowLayout.SectionInsetReference) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.sectionInsetReference = insetReference
        }
    }

    func section(headersPinToVisibleBounds flag: Bool) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.sectionHeadersPinToVisibleBounds = flag
        }
    }

    func section(footersPinToVisibleBounds flag: Bool) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.castedCollectionViewLayout.sectionFootersPinToVisibleBounds = flag
        }
    }
}
