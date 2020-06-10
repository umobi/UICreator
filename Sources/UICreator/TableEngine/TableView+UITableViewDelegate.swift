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

extension UICTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = self.manager?.header(at: section) else {
            return nil
        }

        guard
            let cell = self.dequeueReusableHeaderFooterView(
                withIdentifier: header.identifier
            ) as? TableViewHeaderFooterCell
        else {
            Fatal.Builder("UICList can't dequeue header for section at \(section)").die()
        }

        cell.prepareCell(header, axis: .horizontal)
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = self.manager?.footer(at: section) else {
            return nil
        }

        guard let cell = self.dequeueReusableHeaderFooterView(
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

extension UICTableView {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard self.manager?.header(at: section) != nil else {
            return .zero
        }

        return tableView.sizeManager.header(at: section)?.size.height ?? tableView.sectionHeaderHeight
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard self.manager?.footer(at: section) != nil else {
            return .zero
        }

        return tableView.sizeManager.footer(at: section)?.size.height ?? tableView.sectionFooterHeight
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard self.manager?.row(at: indexPath) != nil else {
            return .zero
        }

        return tableView.sizeManager.row(at: indexPath)?.size.height ?? tableView.rowHeight
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
        self.reusableView.hostedView.uiView?.frame.height ?? .zero
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
    private let headers: Mutable<[SizeCache]> = .init(value: [])
    private let footers: Mutable<[SizeCache]> = .init(value: [])
    private let rows: Mutable<[Int: [SizeCache]]> = .init(value: [:])

    init() {}

    func header(at section: Int) -> SizeCache? {
        guard self.headers.value.count > section else {
            return nil
        }

        let header = self.headers.value[section]
        guard
            case .headerFooter(let section) = header.contentType,
            section == section
        else { return nil }

        return header
    }

    func footer(at section: Int) -> SizeCache? {
        guard self.footers.value.count > section else {
            return nil
        }

        let footer = self.footers.value[section]
        guard
            case .headerFooter(let section) = footer.contentType,
            section == section
        else { return nil }

        return footer
    }

    func row(at indexPath: IndexPath) -> SizeCache? {
        guard
            let rows = self.rows.value[indexPath.section],
            rows.count > indexPath.row
        else {
            return nil
        }

        let row = rows[indexPath.row]
        guard
            case .cell(let indexPath) = row.contentType,
            indexPath.row == indexPath.row
        else { return nil }

        return row
    }

    func updateRow(_ sizeCache: SizeCache) {
        guard case .cell(let indexPath) = sizeCache.contentType else {
            return
        }

        guard var rows = self.rows.value[indexPath.section] else {
            self.rows.value[indexPath.section] = [sizeCache]
            return
        }

        if rows.count <= indexPath.row {
            self.rows.value[indexPath.section] = rows + [sizeCache]
            return
        }

        guard case .cell(let otherIndexPath) = rows[indexPath.row].contentType else {
            fatalError()
        }

        if otherIndexPath.row == indexPath.row {
            rows[indexPath.row] = sizeCache
            self.rows.value[indexPath.section] = rows
            return
        }

        self.rows.value[indexPath.section] = rows[0..<indexPath.row] +
            [sizeCache] +
            rows[indexPath.row..<rows.count]
    }

    func updateHeader(_ sizeCache: SizeCache) {
        guard case .headerFooter(let section) = sizeCache.contentType else {
            return
        }

        if self.headers.value.count <= section {
            self.headers.value = self.headers.value + [sizeCache]
            return
        }

        guard case .headerFooter(let otherSection) = self.headers.value[section].contentType else {
            fatalError()
        }

        if otherSection == section {
            self.headers.value[section] = sizeCache
            return
        }

        self.headers.value = self.headers.value[0..<section] +
            [sizeCache] +
            self.headers.value[section..<self.headers.value.count]
    }

    func updateFooter(_ sizeCache: SizeCache) {
        guard case .headerFooter(let section) = sizeCache.contentType else {
            return
        }

        if self.footers.value.count <= section {
            self.footers.value = self.footers.value + [sizeCache]
            return
        }

        guard case .headerFooter(let otherSection) = self.footers.value[section].contentType else {
            fatalError()
        }

        if otherSection == section {
            self.footers.value[section] = sizeCache
            return
        }

        self.footers.value = self.footers.value[0..<section] +
            [sizeCache] +
            self.footers.value[section..<self.footers.value.count]
    }

    func remove() {
        self.footers.value = []
        self.headers.value = []
        self.rows.value = [:]
    }
}
