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

extension ViewCreator {
    var root: ViewCreator? {
        sequence(first: self as ViewCreator, next: { $0.tree.supertree?.root })
            .reversed()
            .first
    }
}

class Tree {
    private(set) weak var root: ViewCreator!
    private(set) var leafs: [Leaf]
    private(set) weak var supertree: Tree?

    init(_ root: ViewCreator) {
        self.root = root
        self.leafs = []
        supertree = nil
    }

    func appendAssert(_ leaf: ViewCreator) {
        guard self.root !== leaf else {
            fatalError()
        }

        guard !self.leafs.contains(where: {
            $0.leaf === leaf
        }) else {
            fatalError()
        }

        leaf.tree.supertree = self
    }

    func append(_ leaf: ViewCreator) {
        self.appendAssert(leaf)
        self.leafs.append(.init(leaf))
    }

    func insert(_ leaf: ViewCreator, at index: Int) {
        self.appendAssert(leaf)

        self.leafs = (Array(self.leafs[0..<index]) + [.init(leaf)] + {
            guard index+1 < self.leafs.count else {
                return []
            }

            return Array(self.leafs[index+1..<self.leafs.count])
        }())
    }

    func remove(_ leaf: ViewCreator) {
        guard self.leafs.contains(where: {
            $0.leaf === leaf
        }) else {
            fatalError()
        }

        self.leafs = self.leafs.filter {
            $0.leaf !== leaf
        }

        leaf.tree.supertree = nil
    }

    func printTrace(_ count: Int = 0) {
        print("\((0..<count).map {_ in "\t"}.joined())", self.root!)
        
        self.leafs.forEach {
            $0.leaf.tree.printTrace(count + 1)
        }
    }
}

private var kTree: UInt = 0
extension ViewCreator {
    var tree: Tree {
        get {
            (objc_getAssociatedObject(self, &kTree) as? Tree) ?? {
                let tree = Tree(self)
                self.tree = tree
                return tree
            }()
        }
        set { objc_setAssociatedObject(self, &kTree, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

extension Tree {
    struct Leaf {
        private(set) weak var leaf: ViewCreator!

        init(_ leaf: ViewCreator) {
            self.leaf = leaf
        }
    }
}

public extension UIView {
    func printCreatorTrace() {
        if let root = self.superCreator?.root {
            root.tree.printTrace()
            return
        }

        self.viewCreators.forEach {
            $0.tree.printTrace()
        }
    }
}

private var kRender: UInt = 0
extension ViewCreator {
    var render: Render {
        get { (objc_getAssociatedObject(self, &kRender) as? Render) ?? .create(self) }
        set { objc_setAssociatedObject(self, &kRender, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

class Render {
    weak var manager: ViewCreator!
    var state: UIView.RenderState = .unset

    private var needs: Set<UIView.RenderState> = []

    private init(_ manager: ViewCreator) {
        self.manager = manager
    }

    static func create(_ manager: ViewCreator) -> Render {
        let render = Render(manager)
        manager.render = render
        return render
    }

    private var isRunningOutsideCicle: Bool = false
    func append(_ state: UIView.RenderState) {
        self.needs.insert(state)

        if self.state >= state, !self.isRunningOutsideCicle {
            self.isRunningOutsideCicle = true
            OperationQueue.main.addOperation { [weak self] in
                self?.isRunningOutsideCicle = false
                self?.needs.filter {
                    $0 <= self?.state ?? .unset
                }
                .forEach {
                    self?.commit($0)
                }
            }
        }
    }

    func needs(_ state: UIView.RenderState) -> Bool {
        self.needs.contains(state)
    }

    private var notRenderedHandler: ((UIView) -> Void)? = nil
    private var renderedHandler: ((UIView) -> Void)? = nil
    private var inTheSceneHandler: ((UIView) -> Void)? = nil

    private var countingNotRendered: Int = 0
    private var countingRendered: Int = 0
    private var countingInTheScene: Int = 0

    func onNotRendered(_ handler: @escaping (UIView) -> Void) {
        let old = self.notRenderedHandler
        self.notRenderedHandler = {
            old?($0)
            handler($0)
        }
        self.countingNotRendered += 1
        self.append(.notRendered)
    }

    func onRendered(_ handler: @escaping (UIView) -> Void) {
        let old = self.renderedHandler
        self.renderedHandler = {
            old?($0)
            handler($0)
        }

        self.countingRendered += 1
        self.append(.rendered)
    }

    func onInTheScene(_ handler: @escaping (UIView) -> Void) {
        let old = self.inTheSceneHandler
        self.inTheSceneHandler = {
            old?($0)
            handler($0)
        }

        self.countingInTheScene += 1
        self.append(.inTheScene)
    }

    func pop(_ state: UIView.RenderState) {
        guard self.needs(state) else {
            fatalError()
        }

        self.needs.remove(state)

        switch state {
        case .notRendered:
            self.notRenderedHandler?(self.manager.uiView)
            self.notRenderedHandler = nil
            self.countingNotRendered = 0

        case .rendered:
            self.renderedHandler?(self.manager.uiView)
            self.renderedHandler = nil
            self.countingRendered = 0

        case .inTheScene:
            self.inTheSceneHandler?(self.manager.uiView)
            self.inTheSceneHandler = nil
            self.countingInTheScene = 0

        default:
            break
        }
    }

    func commit(_ state: UIView.RenderState) {
        if self.state < state {
            self.state = state
        }

        guard self.needs.contains(state) else {
            return
        }

        self.recursive(commit: state)
    }
}

private extension ViewCreator {
    var notRendered: [ViewCreator] {
        guard self.isViewLoaded else {
            return []
        }

        guard self.render.needs(.notRendered) else {
            return []
        }

        return [self] + self.tree.leafs.reduce([]) {
            $0 + $1.leaf.notRendered
        }
    }

    var rendered: [ViewCreator] {
        guard self.isViewLoaded else {
            return []
        }

        guard self.render.needs(.rendered) else {
            return []
        }

        return [self] + self.tree.leafs.reduce([]) {
            $0 + $1.leaf.rendered
        }
    }

    var inTheScene: [ViewCreator] {
        guard self.isViewLoaded else {
            return []
        }

        guard self.render.needs(.inTheScene) else {
            return []
        }

        return [self] + self.tree.leafs.reduce([]) {
            $0 + $1.leaf.inTheScene
        }
    }
}

private extension Render {
    func recursive(commit state: UIView.RenderState){
        switch state {
        case .notRendered:
            self.manager.notRendered.forEach {
                $0.render.pop(state)
            }
        case .rendered:
            self.manager.rendered.forEach {
                $0.render.pop(state)
            }
        case .inTheScene:
            self.manager.inTheScene.forEach {
                $0.render.pop(state)
            }

        default:
            break
        }
    }
}
