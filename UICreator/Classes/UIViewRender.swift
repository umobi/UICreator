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

protocol ViewRender: UIView {
    /// Subviews that has commits that needs to be done.
    var watchingViews: [UIView] { get }
}

private var kViewBuilder: UInt = 0
internal extension ViewRender {
    private(set) var viewCreator: ViewCreator? {
        get { objc_getAssociatedObject(self, &kViewBuilder) as? ViewCreator }
        set { self.setCreator(newValue, policity: self.superview == nil ? .OBJC_ASSOCIATION_ASSIGN : .OBJC_ASSOCIATION_RETAIN) }
    }

    func setCreator(_ newValue: ViewCreator?, policity: objc_AssociationPolicy = .OBJC_ASSOCIATION_ASSIGN) {
        objc_setAssociatedObject(self, &kViewBuilder, newValue, policity)
    }

    init(builder: ViewCreator) {
        self.init()
        self.viewCreator = builder
    }

    func updateBuilder(_ builder: ViewCreator) {
        self.viewCreator = builder
    }
}

extension UIView: ViewRender {
    @objc
    var watchingViews: [UIView] {
        return self.subviews
    }
}

private var kAppearState: UInt = 0
private var kOnAppearHandler: UInt = 0
private var kOnDisappearHandler: UInt = 0
private var kOnLayoutHandler: UInt = 0

extension UIView {
    enum AppearState {
        case appeared
        case disappeared
        case unset
    }

    var appearState: AppearState {
        get { (objc_getAssociatedObject(self, &kAppearState) as? AppearState) ?? .unset }
        set { objc_setAssociatedObject(self, &kAppearState, newValue, .OBJC_ASSOCIATION_RETAIN) }
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

private extension UIView {

    var appearHandler: UIView.Handler? {
        get { objc_getAssociatedObject(self, &kOnAppearHandler) as? UIView.Handler }
        set { objc_setAssociatedObject(self, &kOnAppearHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var disappearHandler: UIView.Handler? {
        get { objc_getAssociatedObject(self, &kOnDisappearHandler) as? UIView.Handler }
        set { objc_setAssociatedObject(self, &kOnDisappearHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

private extension UIView {

    var layoutHandler: UIView.Handler? {
        get { objc_getAssociatedObject(self, &kOnLayoutHandler) as? UIView.Handler }
        set { objc_setAssociatedObject(self, &kOnLayoutHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
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

public extension UIView {

    @discardableResult
    func onAppear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.appendAppear(handler)

        if case .appeared = self.appearState {
            handler(self)
        }

        return self
    }

    @discardableResult
    func onDisappear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.appendDisappear(handler)

        if case .disappeared = self.appearState {
            handler(self)
        }

        return self
    }
}

public extension UIView {

    @discardableResult
    func onLayout(_ handler: @escaping (UIView) -> Void) -> Self {
        self.appendLayout(handler)

        if self.frame.size != .zero {
            RenderManager(self)?.layoutSubviews()
        }

        return self
    }
}

public extension ViewCreator {

    @discardableResult
    func onAppear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.appearUtil = self.appearUtil.merge(.init(handler))
        return self
    }

    @discardableResult
    func onDisappear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.disappearUtil = self.disappearUtil.merge(.init(handler))
        return self
    }
}

public extension ViewCreator {

    @discardableResult
    func onLayout(_ handler: @escaping (UIView) -> Void) -> Self {
        if let view = self.uiView {
            view.onLayout(handler)
            return self
        }
        
        self.layoutUtil = self.layoutUtil.merge(.init(handler))
        return self
    }
}

private var kAppearUtil: UInt = 0
private var kDisappearUtil: UInt = 0
private var kLayoutUtil: UInt = 0
extension ViewCreator {
    var appearUtil: AppearUtil {
        get { objc_getAssociatedObject(self, &kAppearUtil) as? AppearUtil ?? {
            let appearUtil = AppearUtil { _ in }
            self.appearUtil = appearUtil
            self.onNotRendered { [unowned self] in
                $0.onAppear {
                    self.appearUtil.action($0)
                }
            }
            return appearUtil
        }()}

        set { objc_setAssociatedObject(self, &kAppearUtil, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var disappearUtil: AppearUtil {
        get { objc_getAssociatedObject(self, &kDisappearUtil) as? AppearUtil ?? {
            let disappearUtil = AppearUtil { _ in }
            self.disappearUtil = disappearUtil
            self.onNotRendered { [unowned self] in
                $0.onDisappear {
                    self.disappearUtil.action($0)
                }
            }
            return disappearUtil
        }()}

        set { objc_setAssociatedObject(self, &kDisappearUtil, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var layoutUtil: AppearUtil {
        get { objc_getAssociatedObject(self, &kLayoutUtil) as? AppearUtil ?? {
            let layoutUtil = AppearUtil { _ in }
            self.layoutUtil = layoutUtil
            self.onNotRendered { [unowned self] in
                $0.onLayout {
                    self.layoutUtil.action($0)
                }
            }
            return layoutUtil
        }()}

        set { objc_setAssociatedObject(self, &kLayoutUtil, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

struct AppearUtil {
    let action: (UIView) -> Void

    init(_ action: @escaping (UIView) -> Void) {
        self.action = action
    }

    func merge(_ other: AppearUtil) -> Self {
        .init {
            self.action($0)
            other.action($0)
        }
    }
}
