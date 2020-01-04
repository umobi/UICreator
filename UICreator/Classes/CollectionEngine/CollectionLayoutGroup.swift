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

public enum CollectionLayoutContent {
    case item(CollectionLayoutItem)
    case items(CollectionLayoutItem, quantity: Int)
    case group(CollectionLayoutGroup)
}

public class CollectionLayoutGroup: CollectionLayoutConstraintable {

    let vertical: CollectionLayoutSizeConstraint?
    let horizontal: CollectionLayoutSizeConstraint?
    let content: [CollectionLayoutContent]

    public init(vertical: CollectionLayoutSizeConstraint, content: [CollectionLayoutContent]) {
        self.vertical = vertical
        self.horizontal = nil
        self.content = content
    }

    public init(horizontal: CollectionLayoutSizeConstraint, content: [CollectionLayoutContent]) {
        self.horizontal = horizontal
        self.vertical = nil
        self.content = content
    }

    public init(vertical: CollectionLayoutSizeConstraint, horizontal: CollectionLayoutSizeConstraint, content: [CollectionLayoutContent]) {
        self.vertical = vertical
        self.horizontal = horizontal
        self.content = content
    }

    private func size(_ size: CGSize) -> CGSize {
        return .init(
            width: self.size(relatedTo: size.width, applying: self.horizontal),
            height: self.size(relatedTo: size.height, applying: self.vertical)
        )
    }

    func size(inside size: CGSize, forItem index: Int) -> CGSize {
        let size = self.size(size)
        var index = index % self.numberOfItems
        for content in self.content {
            switch content {
            case .item(let item):
                if index == 0 {
                    return item.size(size)
                }
                index -= 1
            case .items(let item, let quantity):
                if (0 ..< quantity).contains(index) {
                    return item.size(size)
                }
                index -= quantity
            case .group(let group):
                let groupNumberOfItems = group.numberOfItems
                if groupNumberOfItems > index {
                    return group.size(inside: size, forItem: index)
                }
                index -= groupNumberOfItems
            }
        }

        return size
    }

    var numberOfItems: Int {
        return self.content.reduce(0) {
            switch $1 {
            case .group(let group):
                return $0 + group.numberOfItems
            case .items(_, let quantity):
                return $0 + quantity
            case .item:
                return $0 + 1
            }
        }
    }

    func item(at index: Int) -> CollectionLayoutItem? {
        guard index < self.numberOfItems else {
            return nil
        }
        var index = index

        for content in self.content {
            switch content {
            case .item(let item):
                if index == 0 {
                    return item
                }
                index -= 1
            case .items(let item, let quantity):
                if (0 ..< quantity).contains(index) {
                    return item
                }
                index -= quantity
            case .group(let group):
                let groupNumberOfItems = group.numberOfItems
                if groupNumberOfItems > index {
                    return group.item(at: index)
                }
                index -= groupNumberOfItems
            }
        }

        return nil
    }
}
