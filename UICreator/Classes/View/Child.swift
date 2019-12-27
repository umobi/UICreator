//
//  Child.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import SnapKit

public class ChildView: UIView {
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

/// `class Child` is a view that holds more than one **subview**.
public class Child: UIViewCreator {
    public typealias View = ChildView

    public init(_ subview: Subview) {
        self.uiView = View.init(builder: self)

        subview.views.compactMap { $0 }
            .forEach {
                self.uiView.addSubview($0.uiView)
                $0.uiView.snp.makeConstraints {
                    $0.edges.equalTo(0).priority(.low)
                }
            }
    }

    public init(_ views: ViewCreator...) {
        self.uiView = View.init(builder: self)

        views.compactMap { $0 }
            .forEach {
                self.uiView.addSubview($0.uiView)
                $0.uiView.snp.makeConstraints {
                    $0.edges.equalTo(0).priority(.low)
                }
            }
    }
}
