//
//  Table.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public class Table: UITableView, ViewBuilder, HasViewDelegate, HasViewDataSource {

    public func delegate(_ delegate: UITableViewDelegate?) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.delegate = delegate
        }
    }

    public func dataSource(_ dataSource: UITableViewDataSource?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.dataSource = dataSource
        }
    }

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

public extension ViewBuilder where Self: UITableView {
    init(style: Style) {
        self.init(frame: .zero, style: style)
    }

    func addCell(for identifier: String, _ cellClass: AnyClass?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.register(cellClass, forCellReuseIdentifier: identifier)
        }
    }

    func addCell(for identifier: String, _ uiNib: UINib?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.register(uiNib, forCellReuseIdentifier: identifier)
        }
    }

    func addHeaderOrFooter(for identifier: String, _ aClass: AnyClass?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }

    func addHeaderOrFooter(for identifier: String, _ uiNib: UINib?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.register(uiNib, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }

    func row(height: CGFloat) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.rowHeight = height
        }
    }

    func row(estimatedHeight: CGFloat) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.estimatedRowHeight = estimatedHeight
        }
    }

    func header(height: CGFloat) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.sectionHeaderHeight = height
        }
    }

    func header(estimatedHeight: CGFloat) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.estimatedSectionHeaderHeight = estimatedHeight
        }
    }

    func footer(height: CGFloat) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.sectionFooterHeight = height
        }
    }

    func footer(estimatedHeight: CGFloat) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.estimatedSectionFooterHeight = estimatedHeight
        }
    }

    func allowsMultipleSelection(_ flag: Bool) -> Self {
        self.appendRendered {
            ($0 as? Self)?.allowsMultipleSelection = flag
        }
    }

    func allowsSelection(_ flag: Bool) -> Self {
        self.appendRendered {
            ($0 as? Self)?.allowsSelection = flag
        }
    }

    func allowsSelectionDuringEditing(_ flag: Bool) -> Self {
        self.appendRendered {
            ($0 as? Self)?.allowsSelectionDuringEditing = flag
        }
    }

    func allowsMultipleSelectionDuringEditing(_ flag: Bool) -> Self {
        self.appendRendered {
            ($0 as? Self)?.allowsMultipleSelectionDuringEditing = flag
        }
    }

    @available(iOS 11.0, *)
    func insetsContentViews(toSafeArea flag: Bool) -> Self {
        self.appendInTheScene {
            ($0 as? Self)?.insetsContentViewsToSafeArea = flag
        }
    }

    func background(_ content: @escaping () -> UIView) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.backgroundView = Host(content)
        }
    }

    func separator(effect: UIVisualEffect) -> Self {
        self.appendRendered {
            ($0 as? Self)?.separatorEffect = effect
        }
    }

    func separator(color: UIColor?) -> Self {
        self.appendRendered {
            ($0 as? Self)?.separatorColor = color
        }
    }

    func separator(insets: UIEdgeInsets) -> Self {
        self.appendRendered {
            ($0 as? Self)?.separatorInset = insets
        }
    }

    @available(iOS 11.0, *)
    func separator(insetReference: SeparatorInsetReference) -> Self {
        self.appendRendered {
            ($0 as? Self)?.separatorInsetReference = insetReference
        }
    }

    func separator(style: UITableViewCell.SeparatorStyle) -> Self {
        self.appendRendered {
            ($0 as? Self)?.separatorStyle = style
        }
    }

    func header(size: CGSize = .zero, _ content: @escaping () -> UIView) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.tableHeaderView = Host(size: size, content)
        }
    }

    func footer(size: CGSize = .zero, _ content: @escaping () -> UIView) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.tableFooterView = Host(size: size, content)
        }
    }
}
