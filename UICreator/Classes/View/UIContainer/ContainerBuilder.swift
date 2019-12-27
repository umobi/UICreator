//
//  ContainerBuilder.swift
//  UICreator
//
//  Created by brennobemoura on 27/12/19.
//

import Foundation
import UIContainer

internal class TableViewCell: UITableViewCell {
    private var builder: ViewCreator? = nil

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

    func prepareCell(content: @escaping () -> ViewCreator) {
        guard self.builder == nil else {
            return
        }

        let builder = content()
        self.builder = builder
        _ = self.contentView.add(builder.uiView)
    }

    public override var watchingViews: [UIView] {
        return self.contentView.subviews
    }
}

extension Table {
    class Content: ViewCreator {
        let content: () -> ViewCreator

        init(content: @escaping () -> ViewCreator) {
            self.content = content
        }
    }

    class Section: Content {
        let section: () -> ViewCreator
        let footer: () -> ViewCreator

        init(section: @escaping () -> ViewCreator, content: @escaping () -> ViewCreator, footer: @escaping () -> ViewCreator) {
            self.section = section
            self.footer = footer
            super.init(content: content)
        }
    }
}
