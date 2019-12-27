//
//  Table.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public class TableView: UITableView {
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.commitNotRendered()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }
}

public class Table: UIViewCreator, HasViewDelegate, HasViewDataSource {
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
        self.onNotRendered {
            ($0 as? View)?.backgroundView = Host(content: content).uiView
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

    func header(size: CGSize = .zero, _ content: @escaping () -> ViewCreator) -> Self {
        return self.onRendered {
            ($0 as? View)?.tableHeaderView = Host(size: size, content: content).uiView
        }
    }

    func footer(size: CGSize = .zero, _ content: @escaping () -> ViewCreator) -> Self {
        return self.onRendered {
            ($0 as? View)?.tableFooterView = Host(size: size, content: content).uiView
        }
    }
}
