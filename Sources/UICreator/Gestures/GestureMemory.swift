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

private var kGestureMemory = 0
extension UIGestureRecognizer {
    struct Memory {
        @MutableBox var beganHandler: ((UIGestureRecognizer) -> Void)?
        @MutableBox var cancelledHandler: ((UIGestureRecognizer) -> Void)?
        @MutableBox var changedHandler: ((UIGestureRecognizer) -> Void)?
        @MutableBox var failedHandler: ((UIGestureRecognizer) -> Void)?
        @MutableBox var recognizedHandler: ((UIGestureRecognizer) -> Void)?
        @MutableBox var possibleHandler: ((UIGestureRecognizer) -> Void)?
        @MutableBox var endedHandler: ((UIGestureRecognizer) -> Void)?
        @MutableBox var anyOtherHandler: ((UIGestureRecognizer) -> Void)?

        fileprivate let delegate = GestureDelegate()
    }

    var memory: Memory {
        OBJCSet(
            self,
            &kGestureMemory,
            policity: .OBJC_ASSOCIATION_COPY,
            orLoad: Memory.init
        )
    }
}

extension UIGestureRecognizer {
    var gestureDelegate: GestureDelegate {
        self.memory.delegate
    }
}

public extension UIGestureRecognizer {
    func onBegan(_ handler: @escaping (UIGestureRecognizer) -> Void) {
        let old = self.memory.beganHandler
        self.memory.beganHandler = {
            old?($0)
            handler($0)
        }
    }

    func onCancelled(_ handler: @escaping (UIGestureRecognizer) -> Void) {
        let old = self.memory.cancelledHandler
        memory.cancelledHandler = {
            old?($0)
            handler($0)
        }
    }

    func onChanged(_ handler: @escaping (UIGestureRecognizer) -> Void) {
        let old = self.memory.changedHandler
        memory.changedHandler = {
            old?($0)
            handler($0)
        }
    }

    func onFailed(_ handler: @escaping (UIGestureRecognizer) -> Void) {
        let old = self.memory.failedHandler
        self.memory.failedHandler = {
            old?($0)
            handler($0)
        }
    }

    func onRecognized(_ handler: @escaping (UIGestureRecognizer) -> Void) {
        let old = self.memory.recognizedHandler
        self.memory.recognizedHandler = {
            old?($0)
            handler($0)
        }
    }

    func onPossible(_ handler: @escaping (UIGestureRecognizer) -> Void) {
        let old = self.memory.possibleHandler
        self.memory.possibleHandler =  {
            old?($0)
            handler($0)
        }
    }

    func onEnded(_ handler: @escaping (UIGestureRecognizer) -> Void) {
        let old = self.memory.endedHandler
        self.memory.endedHandler = {
            old?($0)
            handler($0)
        }
    }

    func onAnyOther(_ handler: @escaping (UIGestureRecognizer) -> Void) {
        let old = self.memory.anyOtherHandler
        self.memory.anyOtherHandler = {
            old?($0)
            handler($0)
        }
    }
}

internal extension UIGestureRecognizer {
    @objc func commit(_ sender: UIGestureRecognizer) {
        let memory = sender.memory
        switch sender.state {
        case .possible:
            (memory.possibleHandler ?? memory.recognizedHandler)?(sender)
        case .began:
            (memory.beganHandler ?? memory.recognizedHandler)?(sender)
        case .changed:
            (memory.changedHandler ?? memory.recognizedHandler)?(sender)
        case .ended:
            (memory.endedHandler ?? memory.recognizedHandler)?(sender)
        case .cancelled:
            (memory.cancelledHandler ?? memory.recognizedHandler)?(sender)
        case .failed:
            (memory.failedHandler ?? memory.recognizedHandler)?(sender)
        @unknown default:
            memory.anyOtherHandler?(sender)
        }
    }
}

