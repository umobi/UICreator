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

public class UICContent: UIViewCreator {
    public typealias View = ContentView

    public init(
        mode: ContentView.LayoutMode = .center,
        priority: UILayoutPriority = .required,
        content: @escaping () -> ViewCreator) {
        let content = content()
        self.tree.append(content)

        self.loadView { [unowned self] in
            View(builder: self)
        }
        .onNotRendered {
            ($0 as? View)?.layoutMode = mode
            ($0 as? View)?.priority = priority
        }
        .onNotRendered {
            ($0 as? View)?.addContent(content.releaseUIView())
        }
    }
}

public func UICCenter(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .center, priority: priority, content: content)
}

public func UICTopLeft(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .topLeft, priority: priority, content: content)
}

public func UICTop(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .top, priority: priority, content: content)
}

public func UICTopRight(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .topRight, priority: priority, content: content)
}

public func UICLeft(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .left, priority: priority, content: content)
}

public func UICRight(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .right, priority: priority, content: content)
}

public func UICBottomLeft(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .bottomLeft, priority: priority, content: content)
}

public func UICBottom(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .bottom, priority: priority, content: content)
}

public func UICBottomRight(priority: UILayoutPriority = .required, content: @escaping () -> ViewCreator) -> UICContent {
    return .init(mode: .bottomRight, priority: priority, content: content)
}

public extension UIViewCreator where View: ContentView {

    func content(mode: View.LayoutMode) -> Self {
        self.onNotRendered {
            ($0 as? View)?.layoutMode = mode
        }
    }

    func fitting(priority: UILayoutPriority) -> Self {
        self.onNotRendered {
            ($0 as? View)?.priority = priority
        }
    }
}
