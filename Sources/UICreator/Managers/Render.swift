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
import ConstraintBuilder

struct Render {
    typealias State = CBView.RenderState
    
    weak var view: CBView!

    @MutableBox var state: State = .unset
    @MutableBox var needs: Set<State> = .init()
    @MutableBox var isRunningOutsideCicle: Bool = false

    @MutableBox var notRenderedHandler: ((CBView) -> Void)?
    @MutableBox var renderedHandler: ((CBView) -> Void)?
    @MutableBox var inTheSceneHandler: ((CBView) -> Void)?

    private init(_ view: CBView) {
        self.view = view
    }

    static func create(_ view: CBView) -> Self {
        return .init(view)
    }

    func append(_ state: State) {
        self.needs.insert(state)

        if self.state >= state, !self.isRunningOutsideCicle {
            self.isRunningOutsideCicle = true
            OperationQueue.main.addOperation {
                self.isRunningOutsideCicle = false
                self.needs.filter {
                    $0 <= self.state
                }
                .forEach(self.commit(_:))
            }
        }
    }

    func needs(_ state: State) -> Bool {
        self.needs.contains(state)
    }

    func pop(_ state: State) {
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

            handler?(self.view)
        }

        if state >= .rendered {
            self.needs.remove(.rendered)

            let handler = self.renderedHandler
            self.renderedHandler = nil

            handler?(self.view)
        }

        if state == .inTheScene {
            self.needs.remove(.inTheScene)

            let handler = self.inTheSceneHandler
            self.inTheSceneHandler = nil

            handler?(self.view)
        }
    }

    func commit(_ state: State) {
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
    func recursive(commit state: State) {
        self.view.thatNeedsState(state)
            .reversed()
            .forEach {
                $0.render.pop(state)
            }
    }
}

private extension CBView {
    private func untilState(_ renderState: RenderState) -> [CBView] {
        guard !self.isSelfImplemented else {
            return []
        }

        guard self.render.needs(renderState) && self.render.state >= .notRendered else {
            return []
        }

        return [self] + self.subviews.reduce([]) {
            $0 + $1.untilState(renderState)
        }
    }

    func thatNeedsState(_ renderState: RenderState) -> [CBView] {
        guard self.isSelfImplemented else {
            return []
        }

        guard self.render.needs(renderState) else {
            return []
        }

        return [self] + self.subviews.reduce([]) {
            $0 + $1.untilState(renderState)
        }
    }
}

extension Render {

    func onNotRendered(_ handler: @escaping (CBView) -> Void) {
        let old = self.notRenderedHandler
        self.notRenderedHandler = {
            old?($0)
            handler($0)
        }

        self.append(.notRendered)
    }

    func onRendered(_ handler: @escaping (CBView) -> Void) {
        let old = self.renderedHandler
        self.renderedHandler = {
            old?($0)
            handler($0)
        }

        self.append(.rendered)
    }

    func onInTheScene(_ handler: @escaping (CBView) -> Void) {
        let old = self.inTheSceneHandler
        self.inTheSceneHandler = {
            old?($0)
            handler($0)
        }

        self.append(.inTheScene)
    }
}

extension Render {
    enum Fatal: FatalType {
        case popedStatus(State)

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

public extension CBView {
    @discardableResult
    func onNotRendered(_ handler: @escaping (CBView) -> Void) -> Self {
        self.render.onNotRendered(handler)
        return self
    }

    @discardableResult
    func onRendered(_ handler: @escaping (CBView) -> Void) -> Self {
        self.render.onRendered(handler)
        return self
    }

    @discardableResult
    func onInTheScene(_ handler: @escaping (CBView) -> Void) -> Self {
        self.render.onInTheScene(handler)
        return self
    }
}
