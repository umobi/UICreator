//
//  View.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

private var kViewDidLoad: UInt = 0

public typealias View = UIContainer.View

@objc extension UIContainer.View {

    private var didViewLoad: Bool {
        get { (objc_getAssociatedObject(self, &kViewDidLoad) as? Bool) ?? false }
        set { (objc_setAssociatedObject(self, &kViewDidLoad, newValue, .OBJC_ASSOCIATION_RETAIN)) }
    }

    open func viewDidLoad() {
        self.didViewLoad = true
    }
}

extension UIContainer.View: ViewBuilder {

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if let template = (self as? TemplateView), self.subviews.isEmpty {
            _ = self.add(template.body)
        }

        self.commitNotRendered()

        if !self.didViewLoad {
            self.viewDidLoad()
        }
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }
}
