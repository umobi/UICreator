//
//  Container.swift
//  UICreator
//
//  Created by brennobemoura on 24/12/19.
//

import Foundation
import UIKit
import UIContainer

public class _Container<View: UIViewController>: UIContainer.Container<View> {
    override var watchingViews: [UIView] {
        return []
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

public class Container<ViewController: UIViewController>: UIViewCreator {
    public typealias View = _Container<ViewController>

    required init(_ content: @escaping () -> ViewController) {
        self.uiView = View.init(builder: self)
        _ = self.onInTheScene {
            ($0 as? View)?.prepareContainer(inside: $0.viewController, loadHandler: content)
        }
    }

    deinit {
        print("Killed")
    }
}
