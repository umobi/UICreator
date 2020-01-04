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

public protocol CollectionLayoutConstraintable {
    
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

public struct CollectionLayoutElement {
    enum Count {
        case single(CollectionLayoutContent)
        case sequence([CollectionLayoutContent])
    }

    let elements: Count

    init(_ single: CollectionLayoutContent) {
        self.elements = .single(single)
    }

    init(sequence: [CollectionLayoutContent]) {
        self.elements = .sequence(sequence)
    }
}

public extension CollectionLayoutElement {
    static func item(vertical: CollectionLayoutSizeConstraint) -> Self {
        return .init(.item(.init(vertical: vertical)))
    }

    static func item(horizontal: CollectionLayoutSizeConstraint) -> Self {
        return .init(.item(.init(horizontal: horizontal)))
    }

    static func item(vertical: CollectionLayoutSizeConstraint, horizontal: CollectionLayoutSizeConstraint) -> Self {
        return .init(.item(.init(vertical: vertical, horizontal: horizontal)))
    }
}

public extension CollectionLayoutElement {
    static func items(vertical: CollectionLayoutSizeConstraint, quantity: Int) -> Self {
        if quantity <= 0 {
            fatalError()
        }

        return .init(.items(.init(vertical: vertical), quantity: quantity))
    }

    static func items(horizontal: CollectionLayoutSizeConstraint, quantity: Int) -> Self {
        if quantity <= 0 {
            fatalError()
        }

        return .init(.items(.init(horizontal: horizontal), quantity: quantity))
    }

    static func items(vertical: CollectionLayoutSizeConstraint, horizontal: CollectionLayoutSizeConstraint, quantity: Int) -> Self {
        if quantity <= 0 {
            fatalError()
        }

        return .init(.items(.init(vertical: vertical, horizontal: horizontal), quantity: quantity))
    }
}

public extension CollectionLayoutElement {
    static func sequence(_ elements: CollectionLayoutElement...) -> Self {
        return .init(sequence: elements.map {
            guard case .single(let content) = $0.elements else {
                fatalError()
            }

            return content
        })
    }

    var asArray: [CollectionLayoutContent] {
        switch self.elements {
        case .sequence(let array):
            return array
        case .single(let content):
            return [content]
        }
    }

    var asGroup: CollectionLayoutGroup {
        return .init(vertical: .flexible(1), content: self.asArray)
    }
}

public extension CollectionLayoutElement {
    static func group(vertical: CollectionLayoutSizeConstraint, content: @escaping () -> CollectionLayoutElement) -> Self {
        return .init(.group(.init(vertical: vertical, content: content().asArray)))
    }

    static func group(horizontal: CollectionLayoutSizeConstraint, content: @escaping () -> CollectionLayoutElement) -> Self {
        return .init(.group(.init(horizontal: horizontal, content: content().asArray)))
    }

    static func group(vertical: CollectionLayoutSizeConstraint, horizontal: CollectionLayoutSizeConstraint, content: @escaping () -> CollectionLayoutElement) -> Self {
        return .init(.group(.init(vertical: vertical, horizontal: horizontal, content: content().asArray)))
    }
}

public struct CollectionLayoutSection {
    let element: CollectionLayoutElement
    init(_ element: CollectionLayoutElement) {
        self.element = element
    }

    func size(inside size: CGSize, forItem index: Int) -> CGSize {
        return element.asGroup.size(inside: size, forItem: index)
    }
}

public extension CollectionLayoutSection {
    static func section(content: @escaping () -> CollectionLayoutElement) -> Self {
        return .init(content())
    }
}

public extension Array where Element == CollectionLayoutSection {
    static func sequence(_ sections: Element...) -> [Element] {
        return sections
    }

    static func section(content: @escaping () -> CollectionLayoutElement) -> [Element] {
        return [.section(content: content)]
    }

    func section(at index: Int) -> CollectionLayoutSection? {
        if self.isEmpty {
            return nil
        }

        let index = index % self.count
        return self[index]
    }
}

public extension FlowCollection {
    func layoutMaker(content: @escaping () -> [CollectionLayoutSection]) -> Self {
        return self.onInTheScene {
            ($0 as? View)?.layoutGroup = content()
            ($0 as? View)?.collectionViewLayout.invalidateLayout()
        }
    }
}
