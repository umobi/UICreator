//
//  UIView+Mode.swift
//  Pods-UIBuilder_Tests
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

private var kNotRenderedHandler: UInt = 0
private var kRenderedHandler: UInt = 0
private var kInTheSceneHandler: UInt = 0

internal extension UIView {

    /// `enum Mode` The view rendering mode. It is updated depending on the hierarchy of the view.
    /// To execute each state, the superview should call `commitNotRendered()`, `commitRendered()` and `commitInTheScene()`
    /// provided by `protocol ViewBuilder` .
    enum Mode {
        case notRendered
        case rendered
        case inTheScene
    }

    /// The current state of the view
    var mode: Mode {
        if self.superview == nil {
            return .notRendered
        }

        if self.window == nil {
            return .rendered
        }

        return .inTheScene
    }

    /// `class Handler` is a wrap for callbacks used by Core to execute some of the style configurations and other callbacks.
    /// It always return the `self` view as a parameter, so you will not need to create memory dependency in callbacks.
    /// As a tip, you may just cast like `$0 as? Self`, that may work.
    class Handler {
        private let handler: (UIView) -> Void

        init(_ handler: @escaping (UIView) -> Void) {
            self.handler = handler
        }

        func commit(in view: UIView) {
            self.handler(view)
        }
    }

    /// This holds the callback for `UIView.Mode.notRendered`
    var notRenderedHandler: Handler? {
        get { objc_getAssociatedObject(self, &kNotRenderedHandler) as? Handler }
        set { objc_setAssociatedObject(self, &kNotRenderedHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    /// This holds the callback for `UIView.Mode.rendered`
    var renderedHandler: Handler? {
        get { objc_getAssociatedObject(self, &kRenderedHandler) as? Handler }
        set { objc_setAssociatedObject(self, &kRenderedHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    /// This holds the callback for `UIView.Mode.inTheScene`
    var inTheSceneHandler: Handler? {
        get { objc_getAssociatedObject(self, &kInTheSceneHandler) as? Handler }
        set { objc_setAssociatedObject(self, &kInTheSceneHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    /// This create the `Handler` for callback associated to`UIView.Mode.notRendered`
    private func beforeRendering(_ handler: @escaping (UIView) -> Void) -> Self {
        self.notRenderedHandler = .init(handler)
        return self
    }

    /// This create the `Handler` for callback associated to `UIView.Mode.rendered`
    private func rendered(_ handler: @escaping (UIView) -> Void) -> Self {
        self.renderedHandler = .init(handler)
        return self
    }

    /// This create the `Handler` for callback associated to `UIView.Mode.inTheScene`
    private func inTheScene(_ handler: @escaping (UIView) -> Void) -> Self {
        self.inTheSceneHandler = .init(handler)
        return self
    }

    /// The `add(_:)` function is used internally to add views inside view and constraint with 751 of priority in all edges.
    func add(_ view: UIView) -> Self {
        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        {
            $0.isActive = true
            $0.priority = .init(rawValue: 751)
        }(view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0));

        {
            $0.isActive = true
            $0.priority = .init(rawValue: 751)
        }(view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0));

        {
            $0.isActive = true
            $0.priority = .init(rawValue: 751)
        }(view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0));

        {
            $0.isActive = true
            $0.priority = .init(rawValue: 751)
        }(view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0));

        return self
    }

    // Mark: - append methods for each state. All them get the old Handler callback associated to the state and add one more in the stack. The engine here stack each callback and execute them starting by the last command to the first command added in to stack

    /// The `appendBeforeRendering(_:)` function is used internally to add more callbacks for `UIView.Mode.notRendered` state.
    func appendBeforeRendering(_ handler: @escaping (UIView) -> Void) -> Self {
        let allBefore = self.notRenderedHandler
        return self.beforeRendering {
            handler($0)
            allBefore?.commit(in: $0)
        }
    }

    /// The `appendRendered(_:)` function is used internally to add more callbacks for `UIView.Mode.rendered` state.
    func appendRendered(_ handler: @escaping (UIView) -> Void) -> Self {
        let allRendered = self.renderedHandler
        return self.rendered {
            handler($0)
            allRendered?.commit(in: $0)
        }
    }

    /// The `appendInTheScene(_:)` function is used internally to add more callbacks for `UIView.Mode.inTheScene` state.
    func appendInTheScene(_ handler: @escaping (UIView) -> Void) -> Self {
        let allinTheScene = self.inTheSceneHandler
        return self.inTheScene {
            handler($0)
            allinTheScene?.commit(in: $0)
        }
    }
}
