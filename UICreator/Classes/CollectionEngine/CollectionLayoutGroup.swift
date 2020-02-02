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

public class UICCollectionLayoutGroup: UICCollectionLayoutSectionElement, UICCollectionLayoutElement {

    let contents: [UICCollectionLayoutElement]
    let vertical: CollectionLayoutSizeConstraint?
    let horizontal: CollectionLayoutSizeConstraint?

    convenience public init(vertical: CollectionLayoutSizeConstraint, horizontal: CollectionLayoutSizeConstraint,_ contents: @escaping () -> [UICCollectionLayoutElement]) {
        self.init(vertical, horizontal, contents)
    }

    convenience public init(horizontal: CollectionLayoutSizeConstraint,_ contents: @escaping () -> [UICCollectionLayoutElement]) {
        self.init(nil, horizontal, contents)
    }

    convenience public init(vertical: CollectionLayoutSizeConstraint,_ contents: @escaping () -> [UICCollectionLayoutElement]) {
        self.init(vertical, nil, contents)
    }

    convenience public init(_ contents: @escaping () -> [UICCollectionLayoutElement]) {
        self.init(nil, nil, contents)
    }

    private init(_ vertical: CollectionLayoutSizeConstraint?,_ horizontal: CollectionLayoutSizeConstraint?,_ contents: @escaping () -> [UICCollectionLayoutElement]) {
        self.contents = contents()
        self.vertical = vertical
        self.horizontal = horizontal
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
        for content in self.contents {
            switch content {
            case let item as UICCollectionLayoutItem:
                if let numberOfElements = item.numberOfElements {
                    if (0 ..< numberOfElements).contains(index) {
                        return item.size(size)
                    }

                    index -= numberOfElements

                } else {
                    if index == 0 {
                        return item.size(size)
                    }

                    index -= 1
                }

            case let group as UICCollectionLayoutGroup:
                let groupNumberOfItems = group.numberOfItems
                if groupNumberOfItems > index {
                    return group.size(inside: size, forItem: index)
                }
                index -= groupNumberOfItems

            default:
                fatalError()
            }
        }

        return size
    }

    var numberOfItems: Int {
        return self.contents.reduce(0) {
            switch $1 {
            case let group as UICCollectionLayoutGroup:
                return $0 + group.numberOfItems
            case let item as UICCollectionLayoutItem:
                return $0 + (item.numberOfElements ?? 1)
            default:
                fatalError()
            }
        }
    }
}
