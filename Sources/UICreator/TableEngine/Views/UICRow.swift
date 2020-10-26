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
import ConstraintBuilder

@frozen
public struct UICRow: ViewCreator {
    let content: () -> ViewCreator

    let trailingActions: (() -> RowAction)?
    let leadingActions: (() -> RowAction)?
    let accessoryType: UITableViewCell.AccessoryType

    public init(content: @escaping () -> ViewCreator) {
        self.content = content
        self.trailingActions = nil
        self.leadingActions = nil
        self.accessoryType = .none
    }

    private init(_ original: UICRow, editable: Editable) {
        self.content = original.content
        self.trailingActions = editable.trailingActions
        self.leadingActions = editable.leadingActions
        self.accessoryType = editable.accessoryType
    }

    fileprivate class Editable {
        var trailingActions: (() -> RowAction)?
        var leadingActions: (() -> RowAction)?
        var accessoryType: UITableViewCell.AccessoryType

        init(_ original: UICRow) {
            self.trailingActions = original.trailingActions
            self.leadingActions = original.leadingActions
            self.accessoryType = original.accessoryType
        }
    }

    fileprivate func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        fatalError()
    }
}

public extension UICRow {
    func trailingActions(@RowActionBuilder _ actions: @escaping () -> RowAction) -> Self {
        self.edit {
            $0.trailingActions = actions
        }
    }

    func leadingActions(@RowActionBuilder _ actions: @escaping () -> RowAction) -> Self {
        self.edit {
            $0.leadingActions = actions
        }
    }

    func accessoryType(_ type: UITableViewCell.AccessoryType) -> Self {
        self.edit {
            $0.accessoryType = type
        }
    }
}

@_functionBuilder
public struct RowActionBuilder {
    static public func buildBlock(_ segments: RowAction...) -> RowAction {
        CombinedRowActions(children: segments)
    }
}

internal class CombinedRowActions: RowAction {
    let children: [RowAction]

    init(children: [RowAction]) {
        self.children = children
    }
}

internal extension RowAction {
    var zip: [RowAction] {
        switch self {
        case let views as CombinedRowActions:
            return views.children
        default:
            return [self]
        }
    }
}

public protocol RowAction {

}

@available(iOS 11, *)
@available(tvOS, unavailable)
extension UIContextualAction {
    func editHandler(_ handler: @escaping UIContextualAction.Handler) -> UIContextualAction {
        .init(style: self.style, title: self.title, handler: handler)
    }
}

@available(tvOS, unavailable)
extension UITableViewRowAction {
    func editHandler(_ handler: @escaping ((UITableViewRowAction, IndexPath) -> Void)) -> UITableViewRowAction {
        .init(style: self.style, title: self.title, handler: handler)
    }
}

@available(iOS 11, tvOS 11, *)
@available(tvOS, unavailable)
public class UICContextualAction: RowAction {
    private(set) var rowAction: UIContextualAction
    private(set) var handler: ((IndexPath) -> Bool)?
    private(set) var indexPath: IndexPath
    private weak var tableView: UITableView!

    public init(_ title: String? = nil, _ image: UICImage? = nil, style: UIContextualAction.Style) {
        self.indexPath = .init(row: .zero, section: .zero)
        self.rowAction = UIContextualAction(style: style, title: title, handler: { (_, _, _) in })
        self.handler = nil
        self.rowAction = self.rowAction.editHandler { [weak self] _, _, success in
            success(self?.handler?(self!.indexPath) ?? false)
        }

        self.rowAction.image = image?.uiImage
    }

    internal func tableView(_ tableView: UITableView) -> Self {
        self.tableView = tableView
        return self
    }

    public func backgroundColor(_ color: UIColor?) -> Self {
        self.rowAction.backgroundColor = color
        return self
    }

    public func indexPath(_ indexPath: IndexPath) -> Self {
        self.indexPath = indexPath
        return self
    }

    public func onAction(_ handler: @escaping (IndexPath) -> Bool) -> Self {
        self.handler = handler
        return self
    }

    private var configuratorHandler: ((UISwipeActionsConfiguration) -> Void)?
    public func configurator(_ configuratorHandler: @escaping (UISwipeActionsConfiguration) -> Void) -> Self {
        self.configuratorHandler = configuratorHandler
        return self
    }

    internal func commitConfigurator(_ configurator: UISwipeActionsConfiguration) {
        self.configuratorHandler?(configurator)
    }

    public func deleteAction(
        with animation: UITableView.RowAnimation,
        onCompletion handler: @escaping (IndexPath) -> Void) -> Self {
        self.onAction { [weak self] indexPath in
            guard let manager = self?.tableView?.manager as? ListManager else {
                UICList.Fatal.deleteRows([indexPath]).warning()
                return false
            }

            self?.tableView.manager = ListManager.Delete(manager)
                .disableIndexPath(indexPath)

            self?.tableView?.performBatchUpdates({
                self?.tableView.deleteRows(at: [indexPath], with: animation)
            }, completion: { didEnd in
                if didEnd {
                    self?.tableView.manager = manager
                    handler(indexPath)
                }
            })

            return true
        }
    }
}

@available(iOS, deprecated: 13.0)
@available(tvOS, unavailable)
public class UICRowAction: RowAction {
    private(set) var rowAction: UITableViewRowAction
    private(set) var handler: ((IndexPath) -> Void)?
    private(set) var indexPath: IndexPath
    weak var tableView: UITableView!

    public init(_ title: String? = nil, style: UITableViewRowAction.Style) {
        self.indexPath = .init(row: .zero, section: .zero)
        self.rowAction = UITableViewRowAction(style: style, title: title, handler: { (_, _) in })
        self.handler = nil
        self.rowAction = self.rowAction.editHandler { [weak self] _, _ in
            self?.handler?(self!.indexPath)
        }
    }

    public func backgroundColor(_ color: UIColor?) -> Self {
        self.rowAction.backgroundColor = color
        return self
    }

    public func backgroundEffect(_ effect: UIVisualEffect) -> Self {
        self.rowAction.backgroundEffect = effect
        return self
    }

    func indexPath(_ indexPath: IndexPath) -> Self {
        self.indexPath = indexPath
        return self
    }

    public func onAction(_ handler: @escaping (IndexPath) -> Void) -> Self {
        self.handler = handler
        return self
    }

    internal func tableView(_ tableView: UITableView) -> Self {
        self.tableView = tableView
        return self
    }

    public func deleteAction(
        with animation: UITableView.RowAnimation,
        onCompletion handler: @escaping (IndexPath) -> Void) -> Self {
        self.onAction { [weak self] indexPath in
            guard let manager = self?.tableView?.manager as? ListManager else {
                UICList.Fatal.deleteRows([indexPath]).warning()
                return
            }

            self?.tableView.manager = ListManager.Delete(manager)
                .disableIndexPath(indexPath)

            if #available(iOS 11.0, tvOS 11.0, *) {
                self?.tableView?.performBatchUpdates({
                    self?.tableView.deleteRows(at: [indexPath], with: animation)
                }, completion: { didEnd in
                    if didEnd {
                        self?.tableView.manager = manager
                        handler(indexPath)
                    }
                })

                return
            }

            self?.tableView?.beginUpdates()
            self?.tableView?.deleteRows(at: [indexPath], with: animation)
            self?.tableView?.endUpdates()

            self?.tableView?.manager = manager
            handler(indexPath)
        }
    }
}
