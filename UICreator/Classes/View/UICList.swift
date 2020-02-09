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

public class TableView: UITableView {

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self).willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self).didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self).didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self).layoutSubviews()
    }
}

public class UICList: UIViewCreator, HasViewDelegate, HasViewDataSource {
    public typealias View = TableView

    public func delegate(_ delegate: UITableViewDelegate?) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.delegate = delegate
        }
    }

    public func dataSource(_ dataSource: UITableViewDataSource?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.dataSource = dataSource
        }
    }

    public init(style: UITableView.Style) {
        self.uiView = View.init(frame: .zero, style: style)
        self.uiView.updateBuilder(self)
    }
}

public extension UIViewCreator where View: UITableView {

    func addCell(for identifier: String, _ cellClass: AnyClass?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.register(cellClass, forCellReuseIdentifier: identifier)
        }
    }

    func addCell(for identifier: String, _ uiNib: UINib?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.register(uiNib, forCellReuseIdentifier: identifier)
        }
    }

    func addHeaderOrFooter(for identifier: String, _ aClass: AnyClass?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }

    func addHeaderOrFooter(for identifier: String, _ uiNib: UINib?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.register(uiNib, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }

    func row(height: CGFloat) -> Self {
        self.onNotRendered {
            ($0 as? View)?.rowHeight = height
        }
    }

    func row(estimatedHeight: CGFloat) -> Self {
        self.onNotRendered {
            ($0 as? View)?.estimatedRowHeight = estimatedHeight
        }
    }

    func header(height: CGFloat) -> Self {
        self.onNotRendered {
            ($0 as? View)?.sectionHeaderHeight = height
        }
    }

    func header(estimatedHeight: CGFloat) -> Self {
        self.onNotRendered {
            ($0 as? View)?.estimatedSectionHeaderHeight = estimatedHeight
        }
    }

    func footer(height: CGFloat) -> Self {
        self.onNotRendered {
            ($0 as? View)?.sectionFooterHeight = height
        }
    }

    func footer(estimatedHeight: CGFloat) -> Self {
        self.onNotRendered {
            ($0 as? View)?.estimatedSectionFooterHeight = estimatedHeight
        }
    }

    func allowsMultipleSelection(_ flag: Bool) -> Self {
        self.onRendered {
            ($0 as? View)?.allowsMultipleSelection = flag
        }
    }

    func allowsSelection(_ flag: Bool) -> Self {
        self.onRendered {
            ($0 as? View)?.allowsSelection = flag
        }
    }

    func allowsSelectionDuringEditing(_ flag: Bool) -> Self {
        self.onRendered {
            ($0 as? View)?.allowsSelectionDuringEditing = flag
        }
    }

    func allowsMultipleSelectionDuringEditing(_ flag: Bool) -> Self {
        self.onRendered {
            ($0 as? View)?.allowsMultipleSelectionDuringEditing = flag
        }
    }

    @available(iOS 11.0,tvOS 11.0 , *)
    func insetsContentViews(toSafeArea flag: Bool) -> Self {
        self.onInTheScene {
            ($0 as? View)?.insetsContentViewsToSafeArea = flag
        }
    }

    func background(_ content: @escaping () -> ViewCreator) -> Self {
        self.onNotRendered { tableView in
            UICResized(superview: (tableView as? View)?.backgroundView)
                .onAdd {
                    (tableView as? View)?.backgroundView = $0
                }.addSubview(
                    UICHost(content: content)
                        .releaseUIView()
                )
                .height(.required)
                .width(.required)
                .watch(in: tableView)
        }
    }

    #if os(iOS)
    func separator(effect: UIVisualEffect) -> Self {
        self.onRendered {
            ($0 as? View)?.separatorEffect = effect
        }
    }

    func separator(color: UIColor?) -> Self {
        self.onRendered {
            ($0 as? View)?.separatorColor = color
        }
    }

    func separator(style: UITableViewCell.SeparatorStyle) -> Self {
        self.onRendered {
            ($0 as? View)?.separatorStyle = style
        }
    }
    #endif

    func separator(insets: UIEdgeInsets) -> Self {
        self.onRendered {
            ($0 as? View)?.separatorInset = insets
        }
    }

    @available(iOS 11.0, tvOS 11.0, *)
    func separator(insetReference: UITableView.SeparatorInsetReference) -> Self {
        self.onRendered {
            ($0 as? View)?.separatorInsetReference = insetReference
        }
    }

    func header(size: CGSize? = nil, _ content: @escaping () -> ViewCreator) -> Self {
        self.onInTheScene { tableView in
            UICResized(size: size, superview: (tableView as? View)?.tableHeaderView)
                .onAdd {
                    (tableView as? View)?.tableHeaderView = $0
                }.addSubview(
                    UICHost(content: content)
                        .releaseUIView()
                )
                .width(.required)
                .watch(in: tableView)
        }
    }

    func footer(size: CGSize? = nil, _ content: @escaping () -> ViewCreator) -> Self {
        self.onInTheScene { tableView in
            UICResized(size: size, superview: (tableView as? View)?.tableFooterView)
                .onAdd {
                    (tableView as? View)?.tableFooterView = $0
                }.addSubview(
                    UICHost(content: content)
                        .releaseUIView()
                )
                .width(.required)
                .watch(in: tableView)
        }
    }
}

public extension UIViewCreator where View: UITableView {
    func accessoryType(_ type: UITableViewCell.AccessoryType) -> Self {
        (self.uiView as? View)?.appendCellHandler {
            $0.accessoryType = type
        }

        return self
    }
}

private var kTableViewCellHandler: UInt = 0
extension UITableView {
    private var tableViewCellHandler: ((UITableViewCell) -> Void)? {
        get { objc_getAssociatedObject(self, &kTableViewCellHandler) as? (UITableViewCell) -> Void }
        set { objc_setAssociatedObject(self, &kTableViewCellHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    @discardableResult
    func appendCellHandler(handler: @escaping (UITableViewCell) -> Void) -> Self {
        let all = self.tableViewCellHandler
        self.tableViewCellHandler = {
            all?($0)
            handler($0)
        }

        return self
    }

    func commitCell(_ cell: UITableViewCell) {
        self.tableViewCellHandler?(cell)
    }
}

public extension UIViewCreator where View: UITableView {
    func deleteRows(with animation: UITableView.RowAnimation,_ value: Value<[IndexPath]>, onCompletion: @escaping ([IndexPath]) -> Void) -> Self {
        value.asRelay.next { [weak self] indexPaths in
            guard let manager = (self?.uiView as? View)?.manager as? ListManager else {
                Fatal.UICList.deleteRows(indexPaths).warning()
                return
            }

            (self?.uiView as? View)?.manager = ListManager.Delete(manager)
                .disableIndexPaths(indexPaths)

            if #available(iOS 11, tvOS 11, *) {
                (self?.uiView as? View)?.performBatchUpdates({
                    (self?.uiView as? View)?.deleteRows(at: indexPaths, with: animation)
                }, completion: { didEnd in
                    if didEnd {
                        (self?.uiView as? View)?.manager = manager
                        onCompletion(indexPaths)
                    }
                })
                return
            }

            (self?.uiView as? View)?.beginUpdates()
            (self?.uiView as? View)?.deleteRows(at: indexPaths, with: animation)
            (self?.uiView as? View)?.endUpdates()

            (self?.uiView as? View)?.manager = manager
            onCompletion(indexPaths)
        }

        return self
    }

    func deleteSections(with animation: UITableView.RowAnimation,_ value: Value<[Int]>, onCompletion: @escaping ([Int]) -> Void) -> Self {
        value.asRelay.next { [weak self] sections in
            guard let manager = (self?.uiView as? View)?.manager as? ListManager else {
                Fatal.UICList.deleteSections(sections).warning()
                return
            }

            (self?.uiView as? View)?.manager = ListManager.Delete(manager)
                .disableSections(sections)

            if #available(iOS 11, tvOS 11, *) {
                (self?.uiView as? View)?.performBatchUpdates({
                    (self?.uiView as? View)?.deleteSections(.init(sections), with: animation)
                }, completion: { didEnd in
                    if didEnd {
                        (self?.uiView as? View)?.manager = manager
                        onCompletion(sections)
                    }
                })
                return
            }

            (self?.uiView as? View)?.beginUpdates()
            (self?.uiView as? View)?.deleteSections(.init(sections), with: animation)
            (self?.uiView as? View)?.endUpdates()

            (self?.uiView as? View)?.manager = manager
            onCompletion(sections)
        }

        return self
    }
}

public extension UIViewCreator where View: UITableView {

    func insertRows(with animation: UITableView.RowAnimation,_ value: Value<[IndexPath]>, perform: @escaping ([IndexPath]) -> Void) -> Self {
        value.asRelay.next { [weak self] indexPaths in
            guard let manager = (self?.uiView as? View)?.manager as? ListManager else {
                Fatal.UICList.insertRows(indexPaths).warning()
                return
            }
            
            (self?.uiView as? View)?.manager = ListManager.Append(manager)
            perform(indexPaths)

            if #available(iOS 11, tvOS 11, *) {
                (self?.uiView as? View)?.performBatchUpdates({
                    (self?.uiView as? View)?.insertRows(at: indexPaths, with: animation)
                }, completion: { didEnd in
                    if didEnd {
                        (self?.uiView as? View)?.manager = manager
                    }
                })
                return
            }

            (self?.uiView as? View)?.beginUpdates()
            (self?.uiView as? View)?.insertRows(at: indexPaths, with: animation)
            (self?.uiView as? View)?.endUpdates()

            (self?.uiView as? View)?.manager = manager
        }

        return self
    }

    func insertSections(with animation: UITableView.RowAnimation,_ value: Value<[Int]>, perform: @escaping ([Int]) -> Void) -> Self {
        value.asRelay.next { [weak self] sections in
            guard let manager = (self?.uiView as? View)?.manager as? ListManager else {
                Fatal.UICList.insertSections(sections).warning()
                return
            }

            (self?.uiView as? View)?.manager = ListManager.Append(manager)
            perform(sections)

            if #available(iOS 11, tvOS 11, *) {
                (self?.uiView as? View)?.performBatchUpdates({
                    (self?.uiView as? View)?.insertSections(.init(sections), with: animation)
                }, completion: { didEnd in
                    if didEnd {
                        (self?.uiView as? View)?.manager = manager
                        if let listSupport = self?.uiView as? ListSupport {
                            listSupport.setNeedsReloadData()
                            return
                        }
                        (self?.uiView as? View)?.reloadData()
                    }
                })
                return
            }

            (self?.uiView as? View)?.beginUpdates()
            (self?.uiView as? View)?.insertSections(.init(sections), with: animation)
            (self?.uiView as? View)?.endUpdates()

            (self?.uiView as? View)?.manager = manager
            if let listSupport = self?.uiView as? ListSupport {
                listSupport.setNeedsReloadData()
                return
            }
            (self?.uiView as? View)?.reloadData()
        }

        return self
    }
}

extension Fatal {
    enum UICList: FatalType {
        case deleteRows([IndexPath])
        case deleteSections([Int])
        case insertRows([IndexPath])
        case insertSections([Int])

        var error: String {
            switch self {
            case .deleteRows(let indexPaths):
                return "UICList can't perform action deleteRows for indexPaths \(indexPaths)."
            case .deleteSections(let sectionPaths):
                return "UICList can't perform action deleteSections for sectionPaths \(sectionPaths)"
            case .insertRows(let indexPaths):
                return "UICList can't perform action insertRows for indexPaths \(indexPaths)."
            case .insertSections(let sectionPaths):
                return "UICList can't perform action insertSections for sectionPaths \(sectionPaths)"
            }
        }
    }
}
