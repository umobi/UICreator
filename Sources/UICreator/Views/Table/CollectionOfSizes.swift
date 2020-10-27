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

struct CollectionOfSizes {
    @MutableBox var headers: [SizeCache] = []
    @MutableBox var footers: [SizeCache] = []
    @MutableBox var rows: [Int: [SizeCache]] = [:]

    func header(at section: Int) -> SizeCache? {
        guard self.headers.count > section else {
            return nil
        }

        guard
            let header = self.headers.binarySearch({
                guard case .headerFooter(let searchSection) = $0.contentType else {
                    fatalError()
                }

                return searchSection.compare(section)
            }),
            case .headerFooter(let section) = header.contentType,
            section == section
        else { return nil }

        return header
    }

    func footer(at section: Int) -> SizeCache? {
        guard self.footers.count > section else {
            return nil
        }

        guard
            let footer = self.footers.binarySearch({
                guard case .headerFooter(let searchSection) = $0.contentType else {
                    fatalError()
                }

                return searchSection.compare(section)
            }),
            case .headerFooter(let section) = footer.contentType,
            section == section
        else { return nil }

        return footer
    }

    func row(at indexPath: IndexPath) -> SizeCache? {
        guard let rows = self.rows[indexPath.section] else {
            return nil
        }

        guard
            let row = rows.binarySearch({
                guard case .cell(let searchIndexPath) = $0.contentType else {
                    fatalError()
                }

                return searchIndexPath.compare(indexPath)
            }),
            case .cell(let indexPath) = row.contentType,
            indexPath.row == indexPath.row
        else {
            return nil

        }

        return row
    }

    func updateRow(_ sizeCache: SizeCache) {
        guard case .cell(let indexPath) = sizeCache.contentType else {
            return
        }

        guard var rows = self.rows[indexPath.section] else {
            self.rows[indexPath.section] = [sizeCache]
            return
        }

        let index = rows.binaryInsert {
            $0.contentType.compare(sizeCache.contentType)
        }

        if index == rows.count {
            self.rows[indexPath.section]  = rows + [sizeCache]
            return
        }

        if case .cell(let searchIndexPath) = rows[index].contentType, searchIndexPath.row == indexPath.row {
            rows[index] = sizeCache
            self.rows[indexPath.section] = rows
            return
        }

        rows.insert(sizeCache, at: index)
        self.rows[indexPath.section] = rows
    }

    func updateHeader(_ sizeCache: SizeCache) {
        guard case .headerFooter(let section) = sizeCache.contentType else {
            return
        }

        let index = self.headers.binaryInsert {
            $0.contentType.compare(sizeCache.contentType)
        }

        if index == self.headers.count {
            self.headers.append(sizeCache)
            return
        }

        if case .headerFooter(let searchSection) = self.headers[index].contentType, searchSection == section {
            self.headers[index] = sizeCache
            return
        }

        self.headers.insert(sizeCache, at: index)
    }

    func updateFooter(_ sizeCache: SizeCache) {
        guard case .headerFooter(let section) = sizeCache.contentType else {
            return
        }

        let index = self.footers.binaryInsert {
            $0.contentType.compare(sizeCache.contentType)
        }

        if index == self.footers.count {
            self.footers.append(sizeCache)
            return
        }

        if case .headerFooter(let searchSection) = self.footers[index].contentType, searchSection == section {
            self.footers[index] = sizeCache
            return
        }

        self.footers.insert(sizeCache, at: index)
    }

    func sections(count: Int) {
        if self.headers.count > count {
            self.headers = Array(self.headers[0..<count])
        }

        if self.footers.count > count {
            self.footers = Array(self.footers[0..<count])
        }
    }

    func rows(count: Int, in section: Int) {
        let rows = Array((self.rows[section] ?? []))

        guard rows.count > count else {
            return
        }

        self.rows[section] = count == 0 ? nil : Array(rows[0..<count])
    }
}

private extension Array {
    func binaryInsert(_ searchItemHandler: @escaping (Element) -> ComparisonResult) -> Int {
        var start = self.startIndex
        var end = self.endIndex
        while start < end {
            let middle = start + (end - start) / 2
            if searchItemHandler(self[middle]) == .orderedAscending {
                start = middle + 1
            } else {
                end = middle
            }
        }

        assert(start == end)
        return start
    }

    func binarySearch(_ searchItemHandler: @escaping (Element) -> ComparisonResult) -> Element? {
        var lowerIndex = 0
        var upperIndex = self.count - 1

        while true {
            let currentIndex = (lowerIndex + upperIndex)/2
            if searchItemHandler(self[currentIndex]) == .orderedSame {
                return self[currentIndex]
            } else if lowerIndex > upperIndex {
                return nil
            } else {
                if searchItemHandler(self[currentIndex]) == .orderedDescending {
                    upperIndex = currentIndex - 1
                } else {
                    lowerIndex = currentIndex + 1
                }
            }
        }
    }
}

private extension Int {
    @inline(__always)
    func compare(_ other: Self) -> ComparisonResult {
        if self == other {
            return .orderedSame
        }

        return self < other ? .orderedAscending : .orderedDescending
    }
}

private var kTableSizeManager = 0
extension UITableView {
    var sizeManager: CollectionOfSizes {
        OBJCSet(
            self,
            &kTableSizeManager,
            policity: .OBJC_ASSOCIATION_RETAIN,
            orLoad: CollectionOfSizes.init
        )
    }
}
