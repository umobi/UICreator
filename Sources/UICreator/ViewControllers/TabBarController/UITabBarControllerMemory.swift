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

private var kTabBarControllerDelegate = 0
extension UITabBarController {
    @usableFromInline
    struct Memory {
        @MutableBox var didSelect: ((UITabBarController) -> Void)?

        @MutableBox var delegate: UICTabBarControllerDelegate?
    }

    @usableFromInline
    var memory: Memory {
        OBJCSet(
            self,
            &kTabBarControllerDelegate,
            policity: .OBJC_ASSOCIATION_COPY,
            orLoad: Memory.init
        )
    }
}

extension UITabBarController {
    @usableFromInline
    func setDelegateIfNeeded() {
        guard self.memory.delegate == nil else {
            return
        }

        let delegate = UICTabBarControllerDelegate()
        self.memory.delegate = delegate
        self.delegate = delegate
    }
}

extension UITabBarController {
    @inline(__always)
    func didSelect() {
        self.memory.didSelect?(self)
    }
}

private extension UITabBarController {

    func onHandler<P1, Return>(
        _ keyPath: ReferenceWritableKeyPath<Memory, ((P1) -> Return)?>,
        handler: @escaping (P1) -> Return,
        returning: @escaping (Return?, Return) -> Return) -> Self {

        self.setDelegateIfNeeded()

        let old = self.memory[keyPath: keyPath]
        self.memory[keyPath: keyPath] = {
            returning(old?($0), handler($0))
        }

        return self
    }
}

public extension UITabBarController {

    @discardableResult @inline(__always)
    func onDidSelect(_ handler: @escaping (UITabBarController) -> Void) -> Self {
        self.onHandler(
            \.didSelect,
            handler: handler,
            returning: { _, _ in }
        )
    }
}
