//
//  View.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public class View: UIContainer.View, ViewBuilder {
    public func didLoad() {}

    public required init() {
        super.init(frame: .zero)
        self.prepare()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var _didLoad: (() -> Void)? = {
        { [weak self] in
            self?.didLoad()
            self?._didLoad = nil
        }
    }()

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if self.subviews.isEmpty, let template = (self as? TemplateView) {
            _ = self.add(template.body)
        }
        self.commitNotRendered()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
        self._didLoad?()
    }
}
