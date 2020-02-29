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
import EasyAnchor
import UIContainer

internal extension UIView {

    /// `enum Mode` The view rendering mode. It is updated depending on the hierarchy of the view.
    /// To execute each state, the superview should call `commitNotRendered()`, `commitRendered()` and `commitInTheScene()`
    /// provided by `protocol ViewCreator` .
    enum RenderState {
        case notRendered
        case rendered
        case inTheScene
        case unset

        private static var allCases: [RenderState] {
            return [.unset, .notRendered, .rendered, .inTheScene]
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

        var prev: RenderState? {
            Self.allCases.split(separator: self).first?.last
        }

        var next: RenderState? {
            Self.allCases.split(separator: self).last?.first
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
    struct Handler {
        private let handler: (UIView) -> Void

        init(_ handler: @escaping (UIView) -> Void) {
            self.handler = handler
        }

        func commit(in view: UIView) {
            self.handler(view)
        }
    }

    /// The `add(_:)` function is used internally to add views inside view and constraint with required priority in all edges.
    func add(priority: UILayoutPriority? = nil,_ view: UIView) {
        AddSubview(self).addSubview(view)

        let priority: UILayoutPriority = priority ?? ((self as UIView) is RootView && view is RootView ? .required :
        .init(751))

        activate(
            view.anchor
                .edges
                .priority(priority.rawValue)
        )
    }
}

public extension ViewCreator {

    @discardableResult
    func onNotRendered(_ handler: @escaping (UIView) -> Void) -> Self {
        self.render.onNotRendered(handler)
        return self
    }

    @discardableResult
    func onRendered(_ handler: @escaping (UIView) -> Void) -> Self {
        self.render.onRendered(handler)
        return self
    }

    @discardableResult
    func onInTheScene(_ handler: @escaping (UIView) -> Void) -> Self {
        self.render.onInTheScene(handler)
        return self
    }
}
