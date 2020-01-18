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

protocol ForEachCreator: ViewCreator {
    var manager: AnyObject? { get nonmutating set }

    func startObservation()
}

protocol SupportForEach {
    func viewsDidChange(placeholderView: UIView!, _ sequence: Relay<[ViewCreator]>)
}

public class ForEach<Value>: ViewCreator, ForEachCreator {
    let relay: Relay<[Value]>
    let content: (Value) -> ViewCreator
    weak var manager: AnyObject?

    func startObservation() {
        let content = self.content
        (self.manager as? SupportForEach)?.viewsDidChange(placeholderView: self.uiView, relay.map {
            $0.map {
                content($0)
            }
        })
    }

    public init(_ value: UICreator.Value<[Value]>, content: @escaping (Value) -> ViewCreator) {
        self.relay = value.asRelay
        self.content = content
        self.uiView = .init()
        self.uiView.updateBuilder(self)

        self.onInTheScene { view in
            (view.viewCreator as? Self)?.startObservation()
        }
    }
}
