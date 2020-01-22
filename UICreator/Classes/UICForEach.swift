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
    func startObservation()
}

private var kManager: UInt = 0
extension ForEachCreator {
    weak var manager: SupportForEach? {
        get { objc_getAssociatedObject(self, &kManager) as? SupportForEach }
        set { objc_setAssociatedObject(self, &kManager, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
}

protocol SupportForEach: class {
    func viewsDidChange(placeholderView: UIView!, _ sequence: Relay<[() -> ViewCreator]>)
}

public class PlaceholderView: UIView {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }
}

public class UICForEach<Value>: ViewCreator, ForEachCreator {
    let relay: Relay<[Value]>
    let content: (Value) -> ViewCreator

    func startObservation() {
        let content = self.content
        self.manager?.viewsDidChange(placeholderView: self.uiView, relay.map {
            $0.map { item in
                {
                    content(item)
                }
            }
        })
    }

    public init(_ value: UICreator.Value<[Value]>, content: @escaping (Value) -> ViewCreator) {
        self.relay = value.asRelay
        self.content = content
        self.uiView = PlaceholderView(builder: self)

        self.onInTheScene { [weak value] view in
            (view.viewCreator as? Self)?.startObservation()
            (view.viewCreator as? Self)?.relay.post(value?.value ?? [])
        }
    }

    public init(_ value: [Value], content: @escaping (Value) -> ViewCreator) {
        let value = UICreator.Value(value: value)
        self.relay = value.asRelay
        self.content = content
        self.uiView = PlaceholderView(builder: self)

        self.onInTheScene { view in
            (view.viewCreator as? Self)?.startObservation()
            (view.viewCreator as? Self)?.relay.post(value.value)
        }
    }
}
