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

@_functionBuilder
public struct UICViewBuilder {
    static public func buildBlock(_ segments: ViewCreator...) -> ViewCreator {
        CombinedViews(children: segments)
    }

    static public func buildEither(first: ViewCreator) -> ViewCreator {
        return first
    }

    static public func buildEither(second: ViewCreator) -> ViewCreator {
        return second
    }

    static public func buildIf(_ view: ViewCreator?) -> ViewCreator {
        view ?? EmptyViewResult()
    }
}

internal class CombinedViews: ViewCreator {
    let children: [ViewCreator]

    init(children: [ViewCreator]) {
        self.children = children
    }
}

internal class EmptyViewResult: ViewCreator {

}

internal extension ViewCreator {
    var zip: [ViewCreator] {
        switch self {
        case let views as CombinedViews:
            return views.children.filter {
                !($0 is EmptyViewResult)
            }.reduce([]) { $0 + $1.zip }
        case is EmptyViewResult:
            return []
        default:
            return [self]
        }
    }
}
