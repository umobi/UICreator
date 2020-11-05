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

extension UICCollectionLayoutGroup: UICCollectionLayoutGroupDelegate {
    var isVerticalValid: Bool {
        !(self.vertical?.isDynamic ?? true) || (self.delegate?.isVerticalValid ?? false)
    }

    var isHorizontalValid: Bool {
        !(self.horizontal?.isDynamic ?? true) || (self.delegate?.isHorizontalValid ?? false)
    }
}

public class UICCollectionLayoutGroup: UICCollectionLayoutSectionElement, UICCollectionLayoutElement {

    let contents: [UICCollectionLayoutElement]
    let vertical: CollectionLayoutSizeConstraint?
    let horizontal: CollectionLayoutSizeConstraint?
    private(set) var insets: UIEdgeInsets = .zero
    weak var delegate: UICCollectionLayoutGroupDelegate!

    convenience public init(
        vertical: CollectionLayoutSizeConstraint,
        horizontal: CollectionLayoutSizeConstraint,
        @UICCollectionLayoutBuilder _ contents: () -> UICCollectionLayoutElement) {

        self.init(vertical, horizontal, contents().zip)
    }

    convenience public init(
        horizontal: CollectionLayoutSizeConstraint,
        @UICCollectionLayoutBuilder _ contents: () -> UICCollectionLayoutElement) {

        self.init(nil, horizontal, contents().zip)
    }

    convenience public init(
        vertical: CollectionLayoutSizeConstraint,
        @UICCollectionLayoutBuilder _ contents: () -> UICCollectionLayoutElement) {

        self.init(vertical, nil, contents().zip)
    }

    convenience public init(@UICCollectionLayoutBuilder _ contents: () -> UICCollectionLayoutElement) {
        self.init(nil, nil, contents().zip)
    }

    internal init(
        _ vertical: CollectionLayoutSizeConstraint?,
        _ horizontal: CollectionLayoutSizeConstraint?,
        _ contents: [UICCollectionLayoutElement]) {

        self.contents = contents
        self.vertical = vertical
        self.horizontal = horizontal

        self.contents.forEach {
            if let group = $0 as? UICCollectionLayoutGroup {
                group.delegate = self
                return
            }

            ($0 as? UICCollectionLayoutItem)?.delegate = self
        }
    }

    public func insets(_ margins: Margin..., equalTo constant: CGFloat) -> UICCollectionLayoutGroup {
        margins.forEach {
            switch $0 {
            case .top:
                self.insets = .init(
                    top: constant,
                    left: self.insets.left,
                    bottom: self.insets.bottom,
                    right: self.insets.right
                )
            case .bottom:
                self.insets = .init(
                    top: self.insets.top,
                    left: self.insets.left,
                    bottom: constant,
                    right: self.insets.right
                )
            case .leading:
                self.insets = .init(
                    top: self.insets.top,
                    left: constant,
                    bottom: self.insets.bottom,
                    right: self.insets.right
                )
            case .trailing:
                self.insets = .init(
                    top: self.insets.top,
                    left: self.insets.left,
                    bottom: self.insets.bottom,
                    right: constant
                )
            }
        }

        return self
    }

    private func size(_ size: CGSize) -> CGSize {
        return .init(
            width: (self.size(
                relatedTo: size.width,
                applying: self.horizontal
            )) - (self.insets.left + self.insets.right),

            height: self.size(
                relatedTo: size.height,
                applying: self.vertical
            ) - (self.insets.top + self.insets.bottom)
        )
    }

    private func size(inside size: CGSize, forItem index: Int, at indexPath: IndexPath) -> CGSize {
        let size = self.size(size)
        var index = index % self.numberOfItems
        for content in self.contents {
            switch content {
            case let item as UICCollectionLayoutItem:
                if let numberOfElements = item.numberOfElements {
                    if (0 ..< numberOfElements).contains(index) {
                        return item.size(size, at: indexPath)
                    }

                    index -= numberOfElements

                } else {
                    if index == 0 {
                        return item.size(size, at: indexPath)
                    }

                    index -= 1
                }

            case let group as UICCollectionLayoutGroup:
                let groupNumberOfItems = group.numberOfItems
                if groupNumberOfItems > index {
                    return group.size(inside: size, forItem: index, at: indexPath)
                }
                index -= groupNumberOfItems

            default:
                Fatal.invalidContentType.die()
            }
        }

        return size
    }

    func size(inside size: CGSize, at indexPath: IndexPath) -> CGSize {
        self.size(inside: size, forItem: indexPath.row, at: indexPath)
    }

    var numberOfItems: Int {
        return self.contents.reduce(0) {
            switch $1 {
            case let group as UICCollectionLayoutGroup:
                return $0 + group.numberOfItems
            case let item as UICCollectionLayoutItem:
                return $0 + (item.numberOfElements ?? 1)
            default:
                Fatal.invalidContentType.die()
            }
        }
    }

    func item(at index: Int) -> UICCollectionLayoutItem {
        var index = index % self.numberOfItems

        for content in self.contents {
            switch content {
            case let item as UICCollectionLayoutItem:
                if let numberOfElements = item.numberOfElements {
                    if (0 ..< numberOfElements).contains(index) {
                        return item
                    }

                    index -= numberOfElements

                } else {
                    if index == 0 {
                        return item
                    }

                    index -= 1
                }

            case let group as UICCollectionLayoutGroup:
                let groupNumberOfItems = group.numberOfItems
                if groupNumberOfItems > index {
                    return group.item(at: index)
                }
                index -= groupNumberOfItems

            default:
                 break
            }
        }

        Fatal.invalidContentType.die()
    }
}

extension UICCollectionLayoutGroup {
    enum Fatal: String, FatalType {
        case invalidContentType = """
        UICCollectionLayoutGroup only accept UICCollectionLayoutGroup or UICCollectionLayoutItem as layout content
        """
    }
}
