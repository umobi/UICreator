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
