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

        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: header.identifier) as? TableViewHeaderFooterCell else {
            fatalError()
        }
        
        cell.prepareCell(header)
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = self.group?.footer(at: section) else {
            return nil
        }

        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: footer.identifier) as? TableViewHeaderFooterCell else {
            fatalError()
        }

        cell.prepareCell(footer)
        return cell
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let reusableView = tableView.cellForRow(at: indexPath) as? ReusableView else {
            return false
        }

        return !(reusableView.cellLoaded.trailingActions + reusableView.cellLoaded.leadingActions).isEmpty
    }

    @available(iOS 11.0, tvOS 11.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let reusableView = tableView.cellForRow(at: indexPath) as? ReusableView else {
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

    @available(iOS 11.0, tvOS 11.0, *)
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let reusableView = tableView.cellForRow(at: indexPath) as? ReusableView else {
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

    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let reusableView = tableView.cellForRow(at: indexPath) as? ReusableView else {
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
