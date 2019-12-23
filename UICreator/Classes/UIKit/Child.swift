//
//  Child.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import SnapKit

/// `class Child` is a view that holds more than one **subview**.
public class Child: UIView, ViewBuilder {
    public convenience init(_ subview: Subview) {
        self.init()

        subview.views.forEach {
            self.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalTo(0).priority(.low)
            }
        }
    }

    public convenience init(_ views: UIView...) {
        self.init()

        views.forEach {
            self.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalTo(0).priority(.low)
            }
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
