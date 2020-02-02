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

public protocol UICCollectionLayoutElement: CollectionLayoutConstraintable {

}

public protocol UICCollectionLayoutSectionElement {

}

public protocol CollectionLayoutConstraintable {

}

public class UICCollectionLayoutSection: UICCollectionLayoutSectionElement {
    let content: UICCollectionLayoutGroup

    public init(_ contents: @escaping () -> [UICCollectionLayoutElement]) {
        self.content = UICCollectionLayoutGroup(contents)
    }

    func size(inside size: CGSize, forItem index: Int) -> CGSize {
        self.content.size(inside: size, forItem: index)
    }

    var numberOfItems: Int {
        self.content.numberOfItems
    }
}

class UICCollectionLayoutManager {
    let contents: [UICCollectionLayoutSection]

    convenience init(contents: [UICCollectionLayoutSectionElement]) {
        self.init(contents)
    }

    private init(_ contents: [UICCollectionLayoutSectionElement]) {
        if contents.contains(where: { $0 is UICCollectionLayoutSection }) {
            if !contents.allSatisfy { $0 is UICCollectionLayoutSection } {
                fatalError()
            }

            self.contents = contents.map {
                $0 as! UICCollectionLayoutSection
            }
            return
        }

        self.contents = [UICCollectionLayoutSection {
            contents.map {
                $0 as! UICCollectionLayoutElement
            }
        }]
    }

    func section(at index: Int) -> UICCollectionLayoutSection {
        return self.contents[index % self.contents.count]
    }

    var numberOfSections: Int {
        self.contents.count
    }
}

internal extension CollectionLayoutConstraintable {
     func size(relatedTo value: CGFloat, applying constraint: CollectionLayoutSizeConstraint?) -> CGFloat {
         if let constraint = constraint {
             switch constraint {
             case .equalTo(let constant):
                 return constant
             case .flexible(let multiplier):
                 return multiplier * value
             }
         }

         return value
     }
}

public extension UICFlow {
    func layoutMaker(content: @escaping () -> [UICCollectionLayoutSectionElement]) -> Self {
        return self.onInTheScene {
            ($0 as? View)?.layoutManager = UICCollectionLayoutManager(contents: content())
            ($0 as? View)?.collectionViewLayout.invalidateLayout()
        }
    }
}
