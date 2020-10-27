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

@usableFromInline
struct Appear {
    enum State {
        case appeared
        case disappeared
    }

    private weak var view: CBView!

    @MutableBox fileprivate var state: State = .disappeared

    @MutableBox fileprivate var appearHandler: ((CBView) -> Void)?
    @MutableBox fileprivate var disappearHandler: ((CBView) -> Void)?

    private init(_ view: CBView) {
        self.view = view
    }

    @inline(__always)
    static func create(_ view: CBView) -> Self {
        .init(view)
    }

    @inline(__always)
    func needs(_ state: State) -> Bool {
        self.state != state
    }

    private func pop(_ state: State) {
        self.state = state

        switch state {
        case .appeared:
            self.appearHandler?(self.view)
        case .disappeared:
            self.disappearHandler?(self.view)
        }
    }

    func commit(_ state: State) {
        guard self.state != state else {
            return
        }

        guard self.view.isSelfImplemented else {
            return
        }

        ([self.view] + self.view.thatNeedsAppear(state))
            .reversed()
            .forEach {
                $0.appear.pop(state)
            }
    }
}

extension Appear {

    @usableFromInline
    func onAppear(_ handler: @escaping (CBView) -> Void) {
        if self.state == .appeared {
            handler(self.view)
        }

        let oldHandler = self.appearHandler
        self.appearHandler = {
            oldHandler?($0)
            handler($0)
        }
    }

    @usableFromInline
    func onDisappear(_ handler: @escaping (CBView) -> Void) {
        if self.state == .disappeared {
            handler(self.view)
        }

        let oldHandler = self.disappearHandler
        self.disappearHandler = {
            oldHandler?($0)
            handler($0)
        }
    }
}

private extension CBView {
    func thatNeedsAppear(_ state: Appear.State) -> [CBView] {
        guard !self.isSelfImplemented else {
            return []
        }

        guard self.appear.needs(state) else {
            return []
        }

        return [self] + self.subviews.reduce([]) {
            $0 + $1.thatNeedsAppear(state)
        }
    }
}

public extension CBView {
    @inline(__always) @inlinable @discardableResult
    func onAppear(_ handler: @escaping (CBView) -> Void) -> Self {
        self.appear.onAppear(handler)
        return self
    }

    @inline(__always) @inlinable @discardableResult
    func onDisappear(_ handler: @escaping (CBView) -> Void) -> Self {
        self.appear.onDisappear(handler)
        return self
    }
}
