//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import UIKit
import SnapKit

private var kNotRenderedHandler: UInt = 0
private var kRenderedHandler: UInt = 0
private var kInTheSceneHandler: UInt = 0
private var kOnLayoutHandler: UInt = 0

internal extension UIView {

    /// `enum Mode` The view rendering mode. It is updated depending on the hierarchy of the view.
    /// To execute each state, the superview should call `commitNotRendered()`, `commitRendered()` and `commitInTheScene()`
    /// provided by `protocol ViewCreator` .
    enum RenderState {
        case notRendered
        case rendered
        case inTheScene

        private static var allCases: [RenderState] {
            return [.notRendered, .rendered, .inTheScene]
        }

        static func >(left: RenderState, right: RenderState) -> Bool {
            let allCases = self.allCases
            guard let leftOffset = allCases.enumerated().first(where: { $0.element == left })?.offset else {
                return false
            }

            return allCases[0..<leftOffset].contains(right)
        }

        static func <(left: RenderState, right: RenderState) -> Bool {
            let allCases = self.allCases
            guard let leftOffset = allCases.enumerated().first(where: { $0.element == left })?.offset else {
                return false
            }

            return allCases[(leftOffset+1)..<allCases.count].contains(right)
        }

        static func >=(left: RenderState, right: RenderState) -> Bool {
            let allCases = self.allCases
            guard let leftOffset = allCases.enumerated().first(where: { $0.element == left })?.offset else {
                return false
            }

            return allCases[0...leftOffset].contains(right)
        }

        static func <=(left: RenderState, right: RenderState) -> Bool {
            let allCases = self.allCases
            guard let leftOffset = allCases.enumerated().first(where: { $0.element == left })?.offset else {
                return false
            }

            return allCases[leftOffset..<allCases.count].contains(right)
        }
    }

    /// The current state of the view
    var renderState: RenderState {
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
    /// As a tip, you may just cast like `$0 as? View`, that may work.
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

    var layoutHandler: Handler? {
        get { objc_getAssociatedObject(self, &kOnLayoutHandler) as? Handler }
        set { objc_setAssociatedObject(self, &kOnLayoutHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
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

    private func layout(_ handler: @escaping (UIView) -> Void) -> Self {
        self.layoutHandler = .init(handler)
        return self
    }

    /// The `add(_:)` function is used internally to add views inside view and constraint with 751 of priority in all edges.
    func add(priority: ConstraintPriority? = nil,_ view: UIView) -> Self {
        self.addSubview(view)

        let priority: ConstraintPriority = priority ?? ((self as UIView) is RootView && view is RootView ? .required :
        .init(751))

        view.snp.makeConstraints {
            $0.edges.equalTo(0).priority(priority)
        }
        
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

    func appendLayout(_ handler: @escaping (UIView) -> Void) -> Self {
        let allLayout = self.layoutHandler
        return self.layout {
            handler($0)
            allLayout?.commit(in: $0)
        }
    }
}
