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

// swiftlint:disable file_length
class UICTableViewDelegate: NSObject, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.manager?.header(at: section) else {
            return nil
        }

        guard
            let cell = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: header.identifier
            ) as? Views.TableViewHeaderFooterCell
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
            ) as? Views.TableViewHeaderFooterCell
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

extension CGFloat {
    @inline(__always)
    func ifZero(_ constant: CGFloat) -> CGFloat {
        self == .zero ? constant : self
    }
}

extension Numeric where Self: Comparable {
    @inline(__always)
    func ifZeroOrLower(_ constant: Self) -> Self {
        self <= .zero ? constant : self
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
