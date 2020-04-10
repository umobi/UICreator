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
}

internal extension ViewRender {
    private(set) var viewCreator: ViewCreator? {
        get { self.opaqueViewCreator.object as? ViewCreator }
        set { self.setCreator(newValue, policity: self.superview == nil ? .OBJC_ASSOCIATION_ASSIGN : .OBJC_ASSOCIATION_RETAIN) }
    }

    func setCreator(_ newValue: ViewCreator?, policity: objc_AssociationPolicy = .OBJC_ASSOCIATION_ASSIGN) {
        
        guard let newValue = newValue else {
            self.opaqueViewCreator = .nil
            return
        }

        if case .OBJC_ASSOCIATION_ASSIGN = policity {
            self.opaqueViewCreator = .weak(newValue)
            return
        }

        self.opaqueViewCreator = .strong(newValue)
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
            handler($0)
            allAppear?.commit(in: $0)
        }
    }

    @discardableResult
    func appendDisappear(_ handler: @escaping (UIView) -> Void) -> Self {
        let allDisappear = self.disappearHandler
        return self.disappear {
            handler($0)
            allDisappear?.commit(in: $0)
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
            handler($0)
            allLayout?.commit(in: $0)
        }
    }
}

extension UIView {
    func commitLayout() {
        self.layoutHandler?.commit(in: self)
    }
}

private extension UIView {

    func commitAppear() {
        self.appearHandler?.commit(in: self)
    }

    func commitDisappear() {
        self.disappearHandler?.commit(in: self)
    }

    func _recursiveAppear(_ visitedRoot: Bool = false) {
        guard !visitedRoot || self.viewCreator == nil else {
            return
        }

        guard self.appearState != .appeared else {
            return
        }

        let visitedRoot = !visitedRoot || self.viewCreator != nil
        self.subviews.forEach {
            $0._recursiveAppear(visitedRoot)
        }

        self.appearState = .appeared
        self.commitAppear()
    }

    func _recursiveDisappear(_ visitedRoot: Bool = false) {
        guard !visitedRoot || self.viewCreator == nil else {
            return
        }

        guard self.appearState == .appeared else {
            return
        }

        let visitedRoot = !visitedRoot || self.viewCreator != nil
        self.subviews.forEach {
            $0._recursiveDisappear(visitedRoot)
        }

        self.appearState = .disappeared
        self.commitDisappear()
    }
}

extension ViewCreator {
    func commitAppear() {
        self.onInTheScene {
            $0._recursiveAppear()
        }
    }

    func commitDisappear() {
        self.onInTheScene {
            $0._recursiveDisappear()
        }
    }
}

private extension UIView {
    func _recursiveLayout(_ visitedRoot: Bool = false) {
        guard !visitedRoot || self.viewCreator == nil else {
            return
        }

        let visitedRoot = !visitedRoot || self.viewCreator != nil

        self.subviews.forEach {
            $0._recursiveLayout(visitedRoot)
        }

        self.commitLayout()
    }
}
extension ViewCreator {
    func commitLayout() {
        if let uiView = self.uiView {
            uiView._recursiveLayout()
            return
        }
        
        self.onInTheScene {
            $0._recursiveLayout()
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
}
