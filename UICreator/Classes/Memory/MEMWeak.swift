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

struct MEMWeak<Object>: Memory where Object: AnyObject {
    private weak var __weak_uiView: Object!
    private var __strong_uiView: Object!

    var object: Object! {
        self.__strong_uiView ?? self.__weak_uiView
    }

    private init(weak object: Object!) {
        self.__weak_uiView = object
        self.__strong_uiView = nil
    }

    private init(strong object: Object!) {
        self.__weak_uiView = nil
        self.__strong_uiView = object
    }

    static func `weak`(_ object: Object) -> Self {
        .init(weak: object)
    }

    static func strong(_ object: Object) -> Self {
        .init(strong: object)
    }

    static var `nil`: Self {
        .init(weak: nil)
    }

    var isWeaked: Bool {
        self.__weak_uiView != nil
    }
}
