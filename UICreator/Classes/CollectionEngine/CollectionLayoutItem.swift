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

struct UICCollectionLayoutModifiedItem: CollectionLayoutConstraintable {
    let indexPath: IndexPath
    let vertical: CollectionLayoutSizeConstraint?
    let horizontal: CollectionLayoutSizeConstraint?
    weak var delegate: UICCollectionLayoutGroupDelegate?

    init(_ item: UICCollectionLayoutItem, at indexPath: IndexPath) {
        self.vertical = item.vertical
        self.horizontal = item.horizontal
        self.indexPath = indexPath
        self.delegate = item.delegate
    }

    init(_ item: UICCollectionLayoutSupplementary, at indexPath: IndexPath) {
        self.vertical = item.vertical
        self.horizontal = item.horizontal
        self.indexPath = indexPath
        self.delegate = nil
    }

    private init(_ original: UICCollectionLayoutModifiedItem, editable: Editable) {
        self.vertical = editable.vertical
        self.horizontal = editable.horizontal
        self.indexPath = original.indexPath
        self.delegate = original.delegate
    }

    private func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    func vertical(_ constraint: CollectionLayoutSizeConstraint) -> Self {
        guard !(self.delegate?.isVerticalValid ?? true) || (self.vertical?.isDynamic ?? false) else {
            return self
        }

        return self.edit {
            $0.vertical = constraint
        }
    }

    func horizontal(_ constraint: CollectionLayoutSizeConstraint) -> Self {
        guard !(self.delegate?.isHorizontalValid ?? true) || (self.horizontal?.isDynamic ?? false) else {
            return self
        }

        return self.edit {
            $0.horizontal = constraint
        }
    }

    func size(_ size: CGSize) -> CGSize {
        return .init(
            width: self.size(relatedTo: size.width, applying: self.horizontal),
            height: self.size(relatedTo: size.height, applying: self.vertical)
        )
    }

    func willChangeSize(whenReplacedWith copy: UICCollectionLayoutModifiedItem) -> Bool {
        var didChangedSize = true

        if case .equalTo(let constant)? = self.vertical {
            if case .equalTo(let newConstant)? = copy.vertical {
                didChangedSize = didChangedSize && constant != newConstant
            }
        }

        if case .equalTo(let constant)? = self.horizontal {
            if case .equalTo(let newConstant)? = copy.horizontal {
                didChangedSize = didChangedSize && constant != newConstant
            }
        }

        return didChangedSize
    }

    private class Editable {
        var vertical: CollectionLayoutSizeConstraint?
        var horizontal: CollectionLayoutSizeConstraint?

        init(_ modifiedItem: UICCollectionLayoutModifiedItem) {
            self.vertical = modifiedItem.vertical
            self.horizontal = modifiedItem.horizontal
        }
    }
}

extension UICCollectionLayoutItem {
    func modify(at indexPath: IndexPath) -> UICCollectionLayoutModifiedItem {
        return .init(self, at: indexPath)
    }

    func modified(_ modified: UICCollectionLayoutModifiedItem) -> Bool {
        var modified: UICCollectionLayoutModifiedItem? = modified

        var needToInvalidadeSize = true
        self.modifiedItems = self.modifiedItems.compactMap {
            if let copyModified = modified, $0.indexPath == copyModified.indexPath {
                modified = nil
                needToInvalidadeSize = $0.willChangeSize(whenReplacedWith: copyModified)
                return copyModified
            }

            return $0
            } + [modified].compactMap { $0 }

        return needToInvalidadeSize
    }
}

protocol UICCollectionLayoutGroupDelegate: class {
    var isVerticalValid: Bool { get }
    var isHorizontalValid: Bool { get }
}

public class UICCollectionLayoutItem: UICCollectionLayoutSectionElement, UICCollectionLayoutElement {
    let vertical: CollectionLayoutSizeConstraint?
    let horizontal: CollectionLayoutSizeConstraint?
    let numberOfElements: Int?

    weak var delegate: UICCollectionLayoutGroupDelegate!

    fileprivate var modifiedItems: [UICCollectionLayoutModifiedItem] = []

    convenience public init(vertical: CollectionLayoutSizeConstraint, horizontal: CollectionLayoutSizeConstraint, numberOfElements: Int? = nil) {
        self.init(vertical, horizontal, numberOfElements)
    }

    convenience public init(horizontal: CollectionLayoutSizeConstraint, numberOfElements: Int? = nil) {
        self.init(nil, horizontal, numberOfElements)
    }

    convenience public init(vertical: CollectionLayoutSizeConstraint, numberOfElements: Int? = nil) {
        self.init(vertical, nil, numberOfElements)
    }

    convenience public init(numberOfElements: Int? = nil) {
        self.init(nil, nil, numberOfElements)
    }

    private init(_ vertical: CollectionLayoutSizeConstraint?,_ horizontal: CollectionLayoutSizeConstraint?,_ numberOfElements: Int?) {
        self.numberOfElements = numberOfElements
        self.vertical = vertical
        self.horizontal = horizontal
    }

    var isDynamic: Bool {
        return !self.delegate.isVerticalValid || !self.delegate.isHorizontalValid || (self.vertical?.isDynamic ?? false ) || (self.horizontal?.isDynamic ?? false)
    }

    func size(_ size: CGSize, at indexPath: IndexPath) -> CGSize {
        if let modified = self.modifiedItems.first(where: { $0.indexPath == indexPath }) {
            return modified.size(size)
        }
        
        return .init(
            width: self.size(relatedTo: size.width, applying: self.horizontal),
            height: self.size(relatedTo: size.height, applying: self.vertical)
        )
    }
}
