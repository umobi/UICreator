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

public protocol ViewRender: UIView {
    func onAppear(_ handler: @escaping (UIView) -> Void) -> Self
    func onDisappear(_ handler: @escaping (UIView) -> Void) -> Self
    func onLayout(_ handler: @escaping (UIView) -> Void) -> Self
    func onTrait(_ handler: @escaping (UIView) -> Void) -> Self
}

internal extension ViewRender {
    private(set) var viewCreator: ViewCreator? {
        get { self.opaqueViewCreator.object as? ViewCreator }
        set { self.setCreator(newValue, storeType: self.superview == nil ? .weak : .strong) }
    }

    func setCreator(_ newValue: ViewCreator?, storeType: MemoryStoreType = .weak) {
        guard let newValue = newValue else {
            self.opaqueViewCreator = .nil
            return
        }

        switch storeType {
        case .weak:
            self.opaqueViewCreator = .weak(newValue)
        case .strong:
            self.opaqueViewCreator = .strong(newValue)
        }
    }

    init(builder: ViewCreator) {
        self.init()
        self.viewCreator = builder
    }

    func updateBuilder(_ builder: ViewCreator) {
        self.viewCreator = builder
    }
}

extension UIView {
    enum AppearState {
        case appeared
        case disappeared
        case unset
    }
}

private extension UIView {
    private func appear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.appearHandler = .init(handler)
        return self
    }

    private func disappear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.disappearHandler = .init(handler)
        return self
    }

    @discardableResult
    func appendAppear(_ handler: @escaping (UIView) -> Void) -> Self {
        let allAppear = self.appearHandler
        return self.appear {
            allAppear?.commit(in: $0)
            handler($0)
        }
    }

    @discardableResult
    func appendDisappear(_ handler: @escaping (UIView) -> Void) -> Self {
        let allDisappear = self.disappearHandler
        return self.disappear {
            allDisappear?.commit(in: $0)
            handler($0)
        }
    }
}

private extension UIView {
    private func layout(_ handler: @escaping (UIView) -> Void) -> Self {
        self.layoutHandler = .init(handler)
        return self
    }

    func appendLayout(_ handler: @escaping (UIView) -> Void) -> Self {
        let allLayout = self.layoutHandler
        return self.layout {
            allLayout?.commit(in: $0)
            handler($0)
        }
    }
}

private extension UIView {
    private func trait(_ handler: @escaping (UIView) -> Void) -> Self {
        self.traitHandler = .init(handler)
        return self
    }

    func appendTrait(_ handler: @escaping (UIView) -> Void) -> Self {
        let allTrait = self.traitHandler
        return self.trait {
            allTrait?.commit(in: $0)
            handler($0)
        }
    }
}

extension UIView {
    func commitLayout() {
        self.layoutHandler?.commit(in: self)
    }

    func commitTrait() {
        self.traitHandler?.commit(in: self)
    }
}

private extension UIView {
    private static func _recursiveToBottom(
        in view: UIView,
        visitedRoot: Bool = false,
        guard guardCheckHandler: @escaping (UIView) -> Bool,
        do doHandler: @escaping (UIView) -> Void) {

        guard !visitedRoot || view.viewCreator == nil else {
            return
        }

        guard guardCheckHandler(view) else {
            return
        }

        let visitedRoot = !visitedRoot || view.viewCreator != nil
        view.subviews.forEach {
            self._recursiveToBottom(in: $0, visitedRoot: visitedRoot, guard: guardCheckHandler, do: doHandler)
        }

        doHandler(view)
    }

    static func recursiveToBottom(
        in view: UIView,
        guard guardCheckHandler: @escaping (UIView) -> Bool,
        do doHandler: @escaping (UIView) -> Void) {

        self._recursiveToBottom(in: view, guard: guardCheckHandler, do: doHandler)
    }

    static func recursiveToBottom(
        in view: UIView,
        do doHandler: @escaping (UIView) -> Void) {

        self._recursiveToBottom(in: view, guard: { _ in true }, do: doHandler)
    }
}

private extension UIView {

    func commitAppear() {
        self.appearHandler?.commit(in: self)
    }

    func commitDisappear() {
        self.disappearHandler?.commit(in: self)
    }

    func notifyAppearedState() {
        UIView.recursiveToBottom(
            in: self,
            guard: {
                $0.appearState != .appeared
            }, do: {
                $0.appearState = .appeared
                $0.commitAppear()
            })
    }

    func notifyDisappearedState() {
        UIView.recursiveToBottom(
            in: self,
            guard: {
                $0.appearState == .appeared
            }, do: {
                $0.appearState = .disappeared
                $0.commitDisappear()
            })
    }
}

private extension UIView {
    func notifyLayout() {
        UIView.recursiveToBottom(
            in: self,
            do: {
                $0.commitLayout()
            })
    }

    func notifyTrait() {
        UIView.recursiveToBottom(
            in: self,
            do: {
                $0.commitTrait()
            })
    }
}

extension ViewCreator {
    func setNeedsCommit(commit handler: @escaping (UIView) -> Void) {
        if let uiView = self.uiView {
            handler(uiView)
            return
        }

        self.onInTheScene {
            handler($0)
        }
    }
}

extension ViewCreator {
    func commitAppear() {
        self.setNeedsCommit {
            $0.notifyAppearedState()
        }
    }

    func commitDisappear() {
        self.setNeedsCommit {
            $0.notifyDisappearedState()
        }
    }
}

extension ViewCreator {
    func commitLayout() {
        self.setNeedsCommit {
            $0.notifyLayout()
        }
    }

    func commitTrait() {
        self.setNeedsCommit {
            $0.notifyTrait()
        }
    }
}

extension UIView: ViewRender {

    @discardableResult
    public func onAppear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.appendAppear(handler)

        if case .appeared = self.appearState {
            handler(self)
        }

        return self
    }

    @discardableResult
    public func onDisappear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.appendDisappear(handler)

        if case .disappeared = self.appearState {
            handler(self)
        }

        return self
    }

    @discardableResult
    public func onLayout(_ handler: @escaping (UIView) -> Void) -> Self {
        _ = self.appendLayout(handler)

        if self.frame.size != .zero {
            RenderManager(self)?.layoutSubviews()
        }

        return self
    }

    @discardableResult
    public func onTrait(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.appendTrait(handler)
    }
}

public extension ViewCreator {

    @discardableResult
    func onAppear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.appear = self.appear.merge(.init(handler))
        return self
    }

    @discardableResult
    func onDisappear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.disappear = self.disappear.merge(.init(handler))
        return self
    }

    @discardableResult
    func onLayout(_ handler: @escaping (UIView) -> Void) -> Self {
        if let view = self.uiView {
            view.onLayout(handler)
            return self
        }

        self.layout = self.layout.merge(.init(handler))
        return self
    }

    @discardableResult
    func onTrait(_ handler: @escaping (UIView) -> Void) -> Self {
        self.trait = self.trait.merge(.init(handler))
        return self
    }
}
