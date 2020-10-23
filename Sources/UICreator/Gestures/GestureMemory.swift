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

struct GestureMemory: MutableEditable {
    typealias Handler = UIHandler<UIGestureRecognizer>

    let began: Handler?
    let cancelled: Handler?
    let changed: Handler?
    let failed: Handler?
    let recognized: Handler?
    let possible: Handler?
    let ended: Handler?
    let anyOther: Handler?
    
    let gesture: Mutable<MemorySwitch>
    let isReleased: Mutable<Bool>

    init() {
        self.began = nil
        self.cancelled = nil
        self.changed = nil
        self.failed = nil
        self.recognized = nil
        self.possible = nil
        self.ended = nil
        self.anyOther = nil
        self.gesture = .init(value: .nil)
        self.isReleased = .init(value: false)
    }

    init(_ original: GestureMemory, editable: Editable) {
        self.began = editable.began
        self.cancelled = editable.cancelled
        self.changed = editable.changed
        self.failed = editable.failed
        self.recognized = editable.recognized
        self.possible = editable.possible
        self.ended = editable.ended
        self.anyOther = editable.anyOther
        self.gesture = original.gesture
        self.isReleased = original.isReleased
    }

    func edit(_ edit: @escaping (Editable) -> Void) -> GestureMemory {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

extension GestureMemory {
    class Editable {
        var began: Handler?
        var cancelled: Handler?
        var changed: Handler?
        var failed: Handler?
        var recognized: Handler?
        var possible: Handler?
        var ended: Handler?
        var anyOther: Handler?

        init(_ payload: GestureMemory) {
            self.began = payload.began
            self.cancelled = payload.cancelled
            self.changed = payload.changed
            self.failed = payload.failed
            self.recognized = payload.recognized
            self.possible = payload.possible
            self.ended = payload.ended
            self.anyOther = payload.anyOther
        }
    }
}
