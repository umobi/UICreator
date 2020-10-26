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

class UICTableViewDelegate: NSObject, UITableViewDelegate {}

// swiftlint:disable file_length
extension UICTableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.manager?.header(at: section) else {
            return nil
        }

        guard
            let cell = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: header.identifier
            ) as? TableViewHeaderFooterCell
        else {
            Fatal.Builder("UICList can't dequeue header for section at \(section)").die()
        }

        cell.prepareCell(header, axis: .horizontal)
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.manager?.footer(at: section) else {
            return nil
        }

        guard let cell = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: footer.identifier
            ) as? TableViewHeaderFooterCell
        else {
            Fatal.Builder("UICList can't dequeue footer for section at \(section)").die()
        }

        cell.prepareCell(footer, axis: .horizontal)
        return cell
    }

    #if os(iOS)
    @available(iOS 11.0, *)
    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let reusableView = tableView.reusableView(at: indexPath) else {
            return nil
        }

        let configurator = UISwipeActionsConfiguration(actions: reusableView.cellLoaded.trailingActions.compactMap {
            let contextualAction = $0 as? UICContextualAction
            return contextualAction?
                .indexPath(indexPath)
                .tableView(tableView)
                .rowAction
        })

        reusableView.cellLoaded.trailingActions.forEach {
            ($0 as? UICContextualAction)?.commitConfigurator(configurator)
        }

        return configurator
    }

    @available(iOS 11.0, *)
    public func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let reusableView = tableView.reusableView(at: indexPath) else {
            return nil
        }

        let configurator = UISwipeActionsConfiguration(actions: reusableView.cellLoaded.leadingActions.compactMap {
            let contextualAction = $0 as? UICContextualAction
            return contextualAction?
                .indexPath(indexPath)
                .tableView(tableView)
                .rowAction
        })

        reusableView.cellLoaded.leadingActions.forEach {
            ($0 as? UICContextualAction)?.commitConfigurator(configurator)
        }

        return configurator
    }

    public func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let reusableView = tableView.reusableView(at: indexPath) else {
            return nil
        }

        return (reusableView.cellLoaded.leadingActions + reusableView.cellLoaded.trailingActions).compactMap {
            let action = ($0 as? UICRowAction)
            return action?
                .indexPath(indexPath)
                .tableView(tableView)
                .rowAction
        }
    }
    #endif
}

extension UICTableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        (tableView.heightForHeader(in: section) ?? .zero)
            .ifZeroOrLower(.ulpOfOne)
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        (tableView.heightForFooter(in: section) ?? .zero)
            .ifZero(.ulpOfOne)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        (tableView.heightForRow(at: indexPath) ?? .zero)
            .ifZeroOrLower(.zero)
    }
}

private extension Numeric where Self: Comparable {
    func ifZeroOrLower(_ constant: Self) -> Self {
        self <= .zero ? constant : self
    }
}

extension UICTableViewDelegate {

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        (tableView.heightForHeader(in: section) ?? .zero)
            .ifZeroOrLower(.ulpOfOne)
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        (tableView.heightForFooter(in: section) ?? .zero)
            .ifZero(.ulpOfOne)
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        (tableView.heightForRow(at: indexPath) ?? .zero)
            .ifZeroOrLower(.zero)
    }
}

extension UITableView {
    func heightForHeader(in section: Int) -> CGFloat? {
        guard self.manager?.header(at: section) != nil else {
            return nil
        }

        return self.sizeManager.header(at: section)?.size.height
    }

    func heightForFooter(in section: Int) -> CGFloat? {
        guard self.manager?.footer(at: section) != nil else {
            return nil
        }

        return self.sizeManager.footer(at: section)?.size.height
    }

    func heightForRow(at indexPath: IndexPath) -> CGFloat? {
        guard self.manager?.row(at: indexPath) != nil else {
            return nil
        }

        return self.sizeManager.row(at: indexPath)?.size.height
    }
}

struct ReusableHeight {
    let reusableView: ReusableView

    init?(_ view: UIView?) {
        guard let reusableView = view as? ReusableView else {
            return nil
        }

        self.reusableView = reusableView
    }

    var height: CGFloat {
        self.reusableView.hostedView?.frame.height ?? .zero
    }
}

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

private var kTableSizeManager = 0

extension UITableView {
    var sizeManager: CollectionOfSizes {
        OBJCSet(
            self,
            &kTableSizeManager,
            policity: .OBJC_ASSOCIATION_RETAIN,
            orLoad: {
                .init()
            }
        )
    }
}

extension CGFloat {
    func ifZero(_ constant: CGFloat) -> CGFloat {
        self == .zero ? constant : self
    }
}

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

private extension Int {
    func compare(_ other: Self) -> ComparisonResult {
        if self == other {
            return .orderedSame
        }

        return self < other ? .orderedAscending : .orderedDescending
    }
}
