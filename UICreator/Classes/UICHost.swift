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
import UIContainer

public class UICHost: Root, ViewControllerType, UIViewCreator {
    public init(size: CGSize = .zero, content: @escaping () -> ViewCreator) {
        super.init()
//        super.init(loader: nil)
        self.uiView.frame = .init(origin: self.uiView.frame.origin, size: size)
        self.uiView.add(priority: .required, content().releaseUIView())
    }
}

extension UICHost: ViewControllerAppearStates {
    var hosted: ViewCreator? {
        return (self.uiView.subviews.first(where: { $0.viewCreator != nil }))?.viewCreator
    }

    public func viewWillAppear(_ animated: Bool) {
        self.hosted?.uiView.commitWillAppear()
    }

    public func viewDidAppear(_ animated: Bool) {
        self.hosted?.uiView.commitDidAppear()
    }

    public func viewWillDisappear(_ animated: Bool) {
        self.hosted?.uiView.commitWillDisappear()
    }

    public func viewDidDisappear(_ animated: Bool) {
        self.hosted?.uiView.commitDidDisappear()
    }
}

private var kWillAppearHandler: UInt = 0
private var kDidAppearHandler: UInt = 0
private var kWillDisappearHandler: UInt = 0
private var kDidDisappearHandler: UInt = 0

private extension UIView {

    var willAppearHandler: Handler? {
        get { objc_getAssociatedObject(self, &kWillAppearHandler) as? Handler }
        set { objc_setAssociatedObject(self, &kWillAppearHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var didAppearHandler: Handler? {
        get { objc_getAssociatedObject(self, &kDidAppearHandler) as? Handler }
        set { objc_setAssociatedObject(self, &kDidAppearHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var willDisappearHandler: Handler? {
        get { objc_getAssociatedObject(self, &kWillDisappearHandler) as? Handler }
        set { objc_setAssociatedObject(self, &kWillDisappearHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var didDisappearHandler: Handler? {
        get { objc_getAssociatedObject(self, &kDidDisappearHandler) as? Handler }
        set { objc_setAssociatedObject(self, &kDidDisappearHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    func appendWillAppear(_ handler: @escaping (UIView) -> Void) {
        let allBefore = self.willAppearHandler
        self.willAppearHandler = .init {
            handler($0)
            allBefore?.commit(in: $0)
        }
    }

    func appendDidAppear(_ handler: @escaping (UIView) -> Void) {
        let allBefore = self.didAppearHandler
        self.didAppearHandler = .init {
            handler($0)
            allBefore?.commit(in: $0)
        }
    }

    func appendWillDisappear(_ handler: @escaping (UIView) -> Void) {
        let allBefore = self.willDisappearHandler
        self.willDisappearHandler = .init {
            handler($0)
            allBefore?.commit(in: $0)
        }
    }

    func appendDidDisappear(_ handler: @escaping (UIView) -> Void) {
        let allBefore = self.didDisappearHandler
        self.didDisappearHandler = .init {
            handler($0)
            allBefore?.commit(in: $0)
        }
    }
}

public extension ViewCreator {
    func onWillAppear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.uiView.appendWillAppear(handler)
        return self
    }

    func onDidAppear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.uiView.appendDidAppear(handler)
        return self
    }

    func onWillDisappear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.uiView.appendWillDisappear(handler)
        return self
    }

    func onDidDisappear(_ handler: @escaping (UIView) -> Void) -> Self {
        self.uiView.appendDidDisappear(handler)
        return self
    }
}

private extension UIView {
    func commitWillAppear() {
        self.subviews.forEach {
            if ($0.next is UIViewController) {
                return
            }

            $0.commitWillAppear()
        }

        self.willAppearHandler?.commit(in: self)
    }

    func commitDidAppear() {
        self.subviews.forEach {
            if ($0.next is UIViewController) {
                return
            }

            $0.commitDidAppear()
        }

        self.didAppearHandler?.commit(in: self)
    }

    func commitWillDisappear() {
        self.subviews.forEach {
            if ($0.next is UIViewController) {
                return
            }

            $0.commitWillDisappear()
        }

        self.willDisappearHandler?.commit(in: self)
    }

    func commitDidDisappear() {
        self.subviews.forEach {
            if ($0.next is UIViewController) {
                return
            }

            $0.commitDidDisappear()
        }

        self.didDisappearHandler?.commit(in: self)
    }
}
