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
import CoreGraphics

struct SizeCache {
    enum ContentType {
        case cell(IndexPath)
        case headerFooter(Int)
    }

    let contentType: ContentType
    let size: CGSize

    private init(_ contentType: ContentType, size: CGSize) {
        self.contentType = contentType
        self.size = size
    }

    func height(_ constant: CGFloat) -> SizeCache {
        .init(self.contentType, size: .init(width: self.size.width, height: constant))
    }

    func width(_ constant: CGFloat) -> SizeCache {
        .init(self.contentType, size: .init(width: constant, height: self.size.height))
    }

    static func cell(_ indexPath: IndexPath) -> SizeCache {
        .init(.cell(indexPath), size: .zero)
    }

    static func headerFooter(_ section: Int) -> SizeCache {
        .init(.headerFooter(section), size: .zero)
    }
}

extension SizeCache.ContentType: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case .cell(let indexPath):
            guard case .cell(let rIndexPath) = rhs else {
                fatalError()
            }

            return indexPath < rIndexPath
        case .headerFooter(let section):
            guard case .headerFooter(let rSection) = rhs else {
                fatalError()
            }

            return section < rSection
        }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case .cell(let indexPath):
            guard case .cell(let rIndexPath) = rhs else {
                fatalError()
            }

            return indexPath == rIndexPath
        case .headerFooter(let section):
            guard case .headerFooter(let rSection) = rhs else {
                fatalError()
            }

            return section == rSection
        }
    }

    func compare(_ other: Self) -> ComparisonResult {
        if self == other {
            return .orderedSame
        }

        return self < other ? .orderedAscending : .orderedDescending
    }

}
