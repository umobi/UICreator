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

@objc extension UIContainer.View {
    open func viewDidLoad() {
        self.didViewLoad = true
    }
}

extension UIContainer.View: ViewBuilder {

    private var didViewLoad: Bool {
        get { (objc_getAssociatedObject(self, &kViewDidLoad) as? Bool) ?? false }
        set { (objc_setAssociatedObject(self, &kViewDidLoad, newValue, .OBJC_ASSOCIATION_RETAIN)) }
    }


    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if let template = (self as? TemplateView), self.subviews.isEmpty {
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

        if !self.didViewLoad {
            self.viewDidLoad()
        }
    }
}
