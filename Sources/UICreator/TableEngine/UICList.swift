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
public struct UICList: UIViewCreator {
    public typealias View = UITableView

    private let style: UITableView.Style
    private let contents: () -> ViewCreator

    public init(
        _ style: UITableView.Style,
        @UICViewBuilder contents: @escaping () -> ViewCreator) {

        self.style = style
        self.contents = contents
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self
        
        return UICTableView(_self.style)
            .dynamicData(_self.contents)
            .onNotRendered {
                #if os(iOS)
                ($0 as? View)?.separatorStyle = .none
                #endif
            }
    }
}

public extension UIViewCreator where View: UITableView {
    @inlinable
    func allowsMultipleSelection(_ flag: Bool) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.allowsMultipleSelection = flag
        }
    }

    @inlinable
    func allowsSelection(_ flag: Bool) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.allowsSelection = flag
        }
    }

    @inlinable
    func allowsSelectionDuringEditing(_ flag: Bool) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.allowsSelectionDuringEditing = flag
        }
    }

    @inlinable
    func allowsMultipleSelectionDuringEditing(_ flag: Bool) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.allowsMultipleSelectionDuringEditing = flag
        }
    }

    @available(iOS 11.0, tvOS 11.0, *)
    @inlinable
    func insetsContentViews(toSafeArea flag: Bool) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?.insetsContentViewsToSafeArea = flag
        }
    }

    @inlinable
    func background(_ content: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onInTheScene { tableView in
            weak var tableView = tableView

            UICResized(superview: (tableView as? View)?.backgroundView)
                .onAdd {
                    (tableView as? View)?.backgroundView = $0
                }.addSubview(
                    UICAnyView(content).releaseUIView()
                )
                .height(.required)
                .width(.required)
                .watch(in: tableView)
        }
    }

    #if os(iOS)
    @inlinable
    func separatorEffect(_ effect: UIVisualEffect) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.separatorEffect = effect
        }
    }

    @inlinable
    func separatorColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.separatorColor = color
        }
    }

    @inlinable
    func separatorStyle(_ style: UITableViewCell.SeparatorStyle) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.separatorStyle = style
        }
    }
    #endif

    @inlinable
    func separatorInsets(_ insets: UIEdgeInsets) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.separatorInset = insets
        }
    }

    @available(iOS 11.0, tvOS 11.0, *)
    @inlinable
    func separatorInsetReference(_ insetReference: UITableView.SeparatorInsetReference) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.separatorInsetReference = insetReference
        }
    }

    @inlinable
    func header(size: CGSize? = nil, _ content: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onInTheScene { tableView in
            weak var tableView = tableView

            UICResized(size: size, superview: (tableView as? View)?.tableHeaderView)
                .onAdd {
                    (tableView as? View)?.tableHeaderView = $0
                }.addSubview(
                    UICAnyView(content).releaseUIView()
                )
                .width(.required)
                .watch(in: tableView)
        }
    }

    @inlinable
    func footer(size: CGSize? = nil, _ content: @escaping () -> ViewCreator) -> UICModifiedView<View> {
        self.onInTheScene { tableView in
            weak var tableView = tableView

            UICResized(size: size, superview: (tableView as? View)?.tableFooterView)
                .onAdd {
                    (tableView as? View)?.tableFooterView = $0
                }.addSubview(
                    UICAnyView(content).releaseUIView()
                )
                .width(.required)
                .watch(in: tableView)
        }
    }
}

public extension UIViewCreator where View: UITableView {
    @inlinable
    func accessoryType(_ type: UITableViewCell.AccessoryType) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.appendCellHandler {
                $0.accessoryType = type
            }
        }
    }
}

public extension UIViewCreator where View: UITableView {
    @inlinable
    func deleteRows(
        with animation: UITableView.RowAnimation,
        _ value: Relay<[IndexPath]>,
        completion completionHandler: @escaping ([IndexPath]) -> Void) -> UICModifiedView<View> {

        self.onInTheScene {
            weak var tableView: View! = $0 as? View

            value.next { indexPaths in
                guard let manager = tableView.manager as? ListManager else {
                    UICList.Fatal.deleteRows(indexPaths).warning()
                    return
                }

                tableView.manager = ListManager.Delete(manager)
                    .disableIndexPaths(indexPaths)

                if #available(iOS 11, tvOS 11, *) {
                    tableView.performBatchUpdates({
                        tableView.deleteRows(at: indexPaths, with: animation)
                    }, completion: { didEnd in
                        if didEnd {
                            tableView.manager = manager
                            completionHandler(indexPaths)
                        }
                    })
                    return
                }

                tableView.beginUpdates()
                tableView.deleteRows(at: indexPaths, with: animation)
                tableView.endUpdates()

                tableView.manager = manager
                completionHandler(indexPaths)
            }
        }
    }

    @inlinable
    func deleteSections(
        with animation: UITableView.RowAnimation,
        _ value: Relay<[Int]>,
        completion completionHandler: @escaping ([Int]) -> Void) -> UICModifiedView<View> {

        self.onInTheScene {
            weak var tableView: View! = $0 as? View

            value.next { sections in
                guard let manager = tableView.manager as? ListManager else {
                    UICList.Fatal.deleteSections(sections).warning()
                    return
                }

                tableView.manager = ListManager.Delete(manager)
                    .disableSections(sections)

                if #available(iOS 11, tvOS 11, *) {
                    tableView.performBatchUpdates({
                        tableView.deleteSections(.init(sections), with: animation)
                    }, completion: { didEnd in
                        if didEnd {
                            tableView.manager = manager
                            completionHandler(sections)
                        }
                    })
                    return
                }

                tableView.beginUpdates()
                tableView.deleteSections(.init(sections), with: animation)
                tableView.endUpdates()

                tableView.manager = manager
                completionHandler(sections)
            }
        }
    }
}

public extension UIViewCreator where View: UITableView {

    @inlinable
    func insertRows(
        with animation: UITableView.RowAnimation,
        _ value: Relay<[IndexPath]>,
        perform: @escaping ([IndexPath]) -> Void) -> UICModifiedView<View> {

        self.onInTheScene {
            weak var tableView: View! = $0 as? View

            value.next { indexPaths in
                guard let manager = tableView.manager as? ListManager else {
                    UICList.Fatal.insertRows(indexPaths).warning()
                    return
                }

                tableView.manager = ListManager.Append(manager)
                perform(indexPaths)

                if #available(iOS 11, tvOS 11, *) {
                    tableView.performBatchUpdates({
                        tableView.insertRows(at: indexPaths, with: animation)
                    }, completion: { didEnd in
                        if didEnd {
                            tableView.manager = manager
                        }
                    })
                    return
                }

                tableView.beginUpdates()
                tableView.insertRows(at: indexPaths, with: animation)
                tableView.endUpdates()

                tableView.manager = manager
            }
        }
    }

    @inlinable
    func insertSections(
        with animation: UITableView.RowAnimation,
        _ value: Relay<[Int]>,
        perform: @escaping ([Int]) -> Void) -> UICModifiedView<View> {

        self.onInTheScene {
            weak var tableView: View! = $0 as? View

            value.next { sections in
                guard let manager = tableView.manager as? ListManager else {
                    UICList.Fatal.insertSections(sections).warning()
                    return
                }

                tableView.manager = ListManager.Append(manager)
                perform(sections)

                if #available(iOS 11, tvOS 11, *) {
                    tableView.performBatchUpdates({
                        tableView.insertSections(.init(sections), with: animation)
                    }, completion: { didEnd in
                        if didEnd {
                            tableView.manager = manager
                            if let listSupport = tableView as? ListSupport {
                                listSupport.setNeedsReloadData()
                                return
                            }
                            tableView.reloadData()
                        }
                    })
                    return
                }

                tableView.beginUpdates()
                tableView.insertSections(.init(sections), with: animation)
                tableView.endUpdates()

                tableView.manager = manager
                if let listSupport = tableView as? ListSupport {
                    listSupport.setNeedsReloadData()
                    return
                }

                tableView.reloadData()
            }
        }
    }
}

extension UICList {
    @usableFromInline
    enum Fatal: FatalType {
        case deleteRows([IndexPath])
        case deleteSections([Int])
        case insertRows([IndexPath])
        case insertSections([Int])

        @usableFromInline
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
