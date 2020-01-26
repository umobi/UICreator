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

extension TableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = self.group?.header(at: section) else {
            return nil
        }

        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: header.0) as? TableViewHeaderFooterCell else {
            fatalError()
        }
        
        cell.prepareCell(payload: header.1)
        self.creatorDelegate?.header(at: section, content: cell.builder)
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = self.group?.footer(at: section) else {
            return nil
        }

        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: footer.0) as? TableViewHeaderFooterCell else {
            fatalError()
        }

        cell.prepareCell(payload: footer.1)
        self.creatorDelegate?.footer(at: section, content: cell.builder)
        return cell
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let row = self.group?.row(at: indexPath)?.1
        return !((row?.leadingActions?() ?? []) + (row?.trailingActions?() ?? [])).isEmpty
    }

    @available(iOS 11.0, tvOS 11.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let row = self.group?.row(at: indexPath)?.1 else {
            return nil
        }

        let rowActions = row.trailingActions?() ?? []
        let configurator = UISwipeActionsConfiguration(actions: rowActions.compactMap {
            let contextualAction = $0 as? UICContextualAction
            return contextualAction?
                .indexPath(indexPath)
                .tableView(tableView)
                .rowAction
        })

        rowActions.forEach {
            ($0 as? UICContextualAction)?.commitConfigurator(configurator)
        }

        return configurator
    }

    @available(iOS 11.0, tvOS 11.0, *)
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let row = self.group?.row(at: indexPath)?.1 else {
            return nil
        }

        let rowActions = row.leadingActions?() ?? []
        let configurator = UISwipeActionsConfiguration(actions: rowActions.compactMap {
            let contextualAction = $0 as? UICContextualAction
            return contextualAction?
                .indexPath(indexPath)
                .tableView(tableView)
                .rowAction
        })

        rowActions.forEach {
            ($0 as? UICContextualAction)?.commitConfigurator(configurator)
        }

        return configurator
    }

    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let row = self.group?.row(at: indexPath)?.1 else {
            return nil
        }

        return ((row.trailingActions?() ?? []) + (row.leadingActions?() ?? [])).compactMap {
            let action = ($0 as? UICRowAction)
            return action?
                .indexPath(indexPath)
                .tableView(tableView)
                .rowAction
        }
    }
}

extension TableView {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard self.group?.header(at: section) != nil else {
            return .zero
        }

        return self.creatorDelegate?.tableView(tableView, heightForHeaderAt: section) ?? tableView.sectionHeaderHeight
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard self.group?.footer(at: section) != nil else {
            return .zero
        }

        return self.creatorDelegate?.tableView(tableView, heightForHeaderAt: section) ?? tableView.sectionFooterHeight
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard self.group?.row(at: indexPath) != nil else {
            return .zero
        }

        return self.creatorDelegate?.tableView(tableView, heightForRowAt: indexPath) ?? tableView.rowHeight
    }
}

extension TableView {
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard self.group?.header(at: section) != nil else {
            return .zero
        }

        return self.creatorDelegate?.tableView(tableView, estimatedHeightForHeaderAt: section) ?? 1
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        guard self.group?.footer(at: section) != nil else {
            return .zero
        }

        return self.creatorDelegate?.tableView(tableView, estimatedHeightForHeaderAt: section) ?? 1
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard self.group?.row(at: indexPath) != nil else {
            return .zero
        }

        return self.creatorDelegate?.tableView(tableView, estimatedHeightForRowAt: indexPath) ?? tableView.estimatedRowHeight
    }
}
