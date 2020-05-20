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

class Render {
    weak var manager: ViewCreator!
    var state: UIView.RenderState = .unset

    private var needs: Set<UIView.RenderState> = .init()

    private init(_ manager: ViewCreator) {
        self.manager = manager
    }

    static func create(_ manager: ViewCreator) -> Render {
        return Render(manager)
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

    private var notRenderedHandler: ((UIView) -> Void)?
    private var renderedHandler: ((UIView) -> Void)?
    private var inTheSceneHandler: ((UIView) -> Void)?

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
            Fatal.popedStatus(state).die()
        }

        if self.state < state {
            self.state = state
        }

        if state >= .notRendered {
            self.needs.remove(.notRendered)

            let handler = self.notRenderedHandler
            self.notRenderedHandler = nil
            self.countingNotRendered = 0
            handler?(self.manager.uiView)
        }

        if state >= .rendered {
            self.needs.remove(.rendered)

            let handler = self.renderedHandler
            self.renderedHandler = nil
            self.countingRendered = 0
            handler?(self.manager.uiView)
        }

        if state == .inTheScene {
            self.needs.remove(.inTheScene)

            let handler = self.inTheSceneHandler
            self.inTheSceneHandler = nil
            self.countingInTheScene = 0
            handler?(self.manager.uiView)
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

private extension Render {
    func recursive(commit state: UIView.RenderState) {
        switch state {
        case .notRendered:
            self.manager.notRendered.reversed().forEach {
                $0.render.pop(state)
            }
        case .rendered:
            self.manager.rendered.reversed().forEach {
                $0.render.pop(state)
            }
        case .inTheScene:
            self.manager.inTheScene.reversed().forEach {
                $0.render.pop(state)
            }

        default:
            break
        }
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

        guard self.render.state >= .notRendered && self.render.needs(.rendered) else {
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

        guard self.render.state >= .rendered && self.render.needs(.inTheScene) else {
            return []
        }

        return [self] + self.tree.leafs.reduce([]) {
            $0 + $1.leaf.inTheScene
        }
    }
}

extension Render {
    enum Fatal: FatalType {
        case popedStatus(UIView.RenderState)

        var error: String {
            switch self {
            case .popedStatus(let status):
                return """
                UICreator.Render is trying to pop render status '\(status)' but it wasn't necessarly
                """
            }
        }
    }
}
