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

public struct UICTop: UIViewCreator {
    public typealias View = CBView

    private let priority: UILayoutPriority
    private let content: () -> ViewCreator

    public init(
        _ priority: UILayoutPriority = .required,
        content: @escaping () -> ViewCreator) {

        self.priority = priority
        self.content = content
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return ContentView(.top, priority: _self.priority)
            .onNotRendered {
                ($0 as? ContentView)?.addContent(_self.content().releaseUIView())
            }
    }
}

public struct UICTopLeft: UIViewCreator {
    public typealias View = CBView

    private let priority: UILayoutPriority
    private let content: () -> ViewCreator

    public init(
        _ priority: UILayoutPriority = .required,
        content: @escaping () -> ViewCreator) {

        self.priority = priority
        self.content = content
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return ContentView(.topLeft, priority: _self.priority)
            .onNotRendered {
                ($0 as? ContentView)?.addContent(_self.content().releaseUIView())
            }
    }
}

public struct UICTopRight: UIViewCreator {
    public typealias View = CBView

    private let priority: UILayoutPriority
    private let content: () -> ViewCreator

    public init(
        _ priority: UILayoutPriority = .required,
        content: @escaping () -> ViewCreator) {

        self.priority = priority
        self.content = content
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return ContentView(.topRight, priority: _self.priority)
            .onNotRendered {
                ($0 as? ContentView)?.addContent(_self.content().releaseUIView())
            }
    }
}

public struct UICCenter: UIViewCreator {
    public typealias View = CBView

    private let priority: UILayoutPriority
    private let content: () -> ViewCreator

    public init(
        _ priority: UILayoutPriority = .required,
        content: @escaping () -> ViewCreator) {

        self.priority = priority
        self.content = content
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return ContentView(.center, priority: _self.priority)
            .onNotRendered {
                ($0 as? ContentView)?.addContent(_self.content().releaseUIView())
            }
    }
}

public struct UICLeft: UIViewCreator {
    public typealias View = CBView

    private let priority: UILayoutPriority
    private let content: () -> ViewCreator

    public init(
        _ priority: UILayoutPriority = .required,
        content: @escaping () -> ViewCreator) {

        self.priority = priority
        self.content = content
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return ContentView(.left, priority: _self.priority)
            .onNotRendered {
                ($0 as? ContentView)?.addContent(_self.content().releaseUIView())
            }
    }
}

public struct UICRight: UIViewCreator {
    public typealias View = CBView

    private let priority: UILayoutPriority
    private let content: () -> ViewCreator

    public init(
        _ priority: UILayoutPriority = .required,
        content: @escaping () -> ViewCreator) {

        self.priority = priority
        self.content = content
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return ContentView(.right, priority: _self.priority)
            .onNotRendered {
                ($0 as? ContentView)?.addContent(_self.content().releaseUIView())
            }
    }
}

public struct UICBottom: UIViewCreator {
    public typealias View = CBView

    private let priority: UILayoutPriority
    private let content: () -> ViewCreator

    public init(
        _ priority: UILayoutPriority = .required,
        content: @escaping () -> ViewCreator) {

        self.priority = priority
        self.content = content
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return ContentView(.bottom, priority: _self.priority)
            .onNotRendered {
                ($0 as? ContentView)?.addContent(_self.content().releaseUIView())
            }
    }
}

public struct UICBottomLeft: UIViewCreator {
    public typealias View = CBView

    private let priority: UILayoutPriority
    private let content: () -> ViewCreator

    public init(
        _ priority: UILayoutPriority = .required,
        content: @escaping () -> ViewCreator) {

        self.priority = priority
        self.content = content
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return ContentView(.bottomLeft, priority: _self.priority)
            .onNotRendered {
                ($0 as? ContentView)?.addContent(_self.content().releaseUIView())
            }
    }
}

public struct UICBottomRight: UIViewCreator {
    public typealias View = CBView

    private let priority: UILayoutPriority
    private let content: () -> ViewCreator

    public init(
        _ priority: UILayoutPriority = .required,
        content: @escaping () -> ViewCreator) {

        self.priority = priority
        self.content = content
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return ContentView(.bottomRight, priority: _self.priority)
            .onNotRendered {
                ($0 as? ContentView)?.addContent(_self.content().releaseUIView())
            }
    }
}
