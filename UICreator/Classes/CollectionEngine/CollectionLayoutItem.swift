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

public class UICCollectionLayoutItem: UICCollectionLayoutSectionElement, UICCollectionLayoutElement {
    let vertical: CollectionLayoutSizeConstraint?
    let horizontal: CollectionLayoutSizeConstraint?
    let numberOfElements: Int?

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

    func size(_ size: CGSize) -> CGSize {
        return .init(
            width: self.size(relatedTo: size.width, applying: self.horizontal),
            height: self.size(relatedTo: size.height, applying: self.vertical)
        )
    }
}
