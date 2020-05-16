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

public protocol UICCollectionLayoutElement: CollectionLayoutConstraintable {

}

public protocol UICCollectionLayoutSectionElement {

}

public protocol CollectionLayoutConstraintable {

}

public class UICCollectionLayoutSupplementary: UICCollectionLayoutSectionElement, CollectionLayoutConstraintable {
    private(set) var vertical: CollectionLayoutSizeConstraint?
    private(set) var horizontal: CollectionLayoutSizeConstraint?

    fileprivate var modifiedItems: [UICCollectionLayoutModifiedItem] = []

    convenience public init(vertical: CollectionLayoutSizeConstraint, horizontal: CollectionLayoutSizeConstraint) {
        self.init(vertical, horizontal)
    }

    convenience public init(horizontal: CollectionLayoutSizeConstraint) {
        self.init(nil, horizontal)
    }

    convenience public init(vertical: CollectionLayoutSizeConstraint) {
        self.init(vertical, nil)
    }

    convenience public init() {
        self.init(nil, nil)
    }

    internal required init(
        _ vertical: CollectionLayoutSizeConstraint?,
        _ horizontal: CollectionLayoutSizeConstraint?) {
        self.vertical = vertical
        self.horizontal = horizontal
    }

    var isDynamic: Bool {
        return (self.vertical?.isDynamic ?? false) || (self.horizontal?.isDynamic ?? false)
    }

    func size(_ size: CGSize, at section: Int) -> CGSize {
        if let modified = self.modifiedItems.first(where: { $0.indexPath.section == section }) {
            return modified.size(size)
        }

        return .init(
            width: self.size(relatedTo: size.width, applying: self.horizontal),
            height: self.size(relatedTo: size.height, applying: self.vertical)
        )
    }
}

extension UICCollectionLayoutSupplementary {
    func modify(at section: Int) -> UICCollectionLayoutModifiedItem {
        return .init(self, at: .init(row: 0, section: section))
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

public class UICCollectionLayoutHeader: UICCollectionLayoutSupplementary {}
public class UICCollectionLayoutFooter: UICCollectionLayoutSupplementary {}

public class UICCollectionLayoutSection: UICCollectionLayoutSectionElement {
    let content: UICCollectionLayoutGroup
    let header: UICCollectionLayoutHeader?
    let footer: UICCollectionLayoutFooter?
    let numberOfSections: Int?

    public init(numberOfSections: Int? = nil, _ contents: @escaping () -> [UICCollectionLayoutSectionElement]) {
        let contents = contents()

        if contents.contains(where: { $0 is UICCollectionLayoutSection }) {
            Fatal.recursiveSections.die()
        }

        if contents.reduce(0) { $0 + ($1 is UICCollectionLayoutHeader ? 1 : 0) } > 1 {
            Fatal.tooMuchHeaderInSection.die()
        }

        if contents.reduce(0) { $0 + ($1 is UICCollectionLayoutFooter ? 1 : 0) } > 1 {
            Fatal.tooMuchFooterInSection.die()
        }

        self.numberOfSections = numberOfSections
        self.content = UICCollectionLayoutGroup {
            contents.compactMap {
                $0 as? UICCollectionLayoutElement
            }
        }

        self.header = contents.first(where: { $0 is UICCollectionLayoutHeader }) as? UICCollectionLayoutHeader
        self.footer = contents.first(where: { $0 is UICCollectionLayoutFooter }) as? UICCollectionLayoutFooter
    }

    func size(inside size: CGSize, at indexPath: IndexPath) -> CGSize {
        self.content.size(inside: size, at: indexPath)
    }

    var numberOfItems: Int {
        self.content.numberOfItems
    }

    public func insets(_ margins: Margin..., equalTo constant: CGFloat) -> UICCollectionLayoutSection {
        margins.forEach {
            switch $0 {
            case .top:
                _ = self.content.insets(.top, equalTo: constant)
            case .bottom:
                _ = self.content.insets(.bottom, equalTo: constant)
            case .leading:
                _ = self.content.insets(.leading, equalTo: constant)
            case .trailing:
                _ = self.content.insets(.trailing, equalTo: constant)
            }
        }

        return self
    }
}

class UICCollectionLayoutManager {
    private(set) var contents: [UICCollectionLayoutSection]

    convenience init(contents: [UICCollectionLayoutSectionElement]) {
        self.init(contents)
    }

    private init(_ contents: [UICCollectionLayoutSectionElement]) {
        if contents.contains(where: { $0 is UICCollectionLayoutSection }) {
            if !contents.allSatisfy({ $0 is UICCollectionLayoutSection }) {
                Fatal.nestedSectionsWithOtherContents.die()
            }

            self.contents = contents.map {
                guard let section = $0 as? UICCollectionLayoutSection else {
                    Fatal.invalidSectionType.die()
                }

                return section
            }
            return
        }

        self.contents = [UICCollectionLayoutSection {
            contents
        }]
    }

    func item(at indexPath: IndexPath) -> UICCollectionLayoutItem {
        return self.section(at: indexPath.section).content.item(at: indexPath.row)
    }

    func section(at index: Int) -> UICCollectionLayoutSection {
        var index = index % self.numberOfSections

        for section in self.contents {
            if let numberOfSections = section.numberOfSections {
                if (0..<numberOfSections).contains(index) {
                    return section
                }

                index -= numberOfSections
            } else {
                if index == 0 {
                    return section
                }

                index -= 1
            }
        }

        Fatal.noSectionAtIndex(index).die()
    }

    var numberOfSections: Int {
        self.contents.reduce(0) {
            $0 + ($1.numberOfSections ?? 1)
        }
    }

    func header(at section: Int) -> UICCollectionLayoutHeader? {
        return self.section(at: section).header
    }

    func footer(at section: Int) -> UICCollectionLayoutFooter? {
        return self.section(at: section).footer
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
             case .estimated(let constant):
                return constant
             }
         }

         return value
     }
}

extension UICCollectionLayoutSection {
    enum Fatal: String, FatalType {
        case tooMuchHeaderInSection = """
        UICCollectionLayoutSection found too much headers in one section
        """

        case tooMuchFooterInSection = """
        UICCollectionLayoutSection found too much footers in one section
        """

        case recursiveSections = """
        It is not allowed to create recursive sections layout
        """
    }
}

extension UICCollectionLayoutManager {
    enum Fatal: FatalType {
        case nestedSectionsWithOtherContents
        case noSectionAtIndex(Int)
        case invalidSectionType

        var error: String {
            switch self {
            case .nestedSectionsWithOtherContents:
                return """
                UICCollectionLayoutSection found nested sections with other layout contents
                """

            case .noSectionAtIndex(let index):
                return """
                UICCollectionLayoutSection couldn't find section for index \(index)
                """

            case .invalidSectionType:
                return """
                UICCollectionLayoutSection was trying to cast sections but it has found a content that is not a section
                """
            }
        }
    }
}
