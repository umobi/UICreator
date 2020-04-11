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

/// `struct Handler` is a wrap for callbacks used by Core to execute some of the style configurations and other callbacks.
/// It always return the `self` view as a parameter, so you will not need to create memory dependency in callbacks.
/// As a tip, you may just cast like `$0 as? View`, that may work.
struct UIHandler<Object> {
    private let handler: ((Object) -> Void)?

    init(_ handler: @escaping (Object) -> Void) {
        self.handler = handler
    }

    init() {
        self.handler = nil
    }

    func commit(in object: Object) {
        self.handler?(object)
    }

    func merge(_ other: UIHandler<Object>) -> Self {
        .init {
            self.handler?($0)
            other.handler?($0)
        }
    }
}
