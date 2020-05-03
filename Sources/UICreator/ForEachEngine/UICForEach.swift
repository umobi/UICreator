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

public class PlaceholderView: UIView {

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            RenderManager(self)?.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            RenderManager(self)?.frame(newValue)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self)?.willMove(toSuperview: newSuperview)
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self)?.didMoveToSuperview()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self)?.didMoveToWindow()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self)?.layoutSubviews()
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        RenderManager(self)?.traitDidChange()
    }
}

public class UICForEach<Value, View: ViewCreator>: ViewCreator, ForEachCreator {
    let viewType: ViewCreator.Type

    let observable: Observable
    let content: (Value) -> ViewCreator
    private var syncLoad: ((UIView) -> Void)? = nil

    private func startObservation() {
        let content = self.content
        self.manager?.viewsDidChange(placeholderView: self.uiView, self.observable.map { element in
            {
                content(element)
            }
        })
    }

    private init(_ observable: Observable, content: @escaping (Value) -> View) {
        self.observable = observable
        self.content = content
        self.viewType = View.self
        self.loadView {
            PlaceholderView(builder: self)
        }

        self.syncLoad = {
            ($0.viewCreator as? Self)?.startObservation()
        }

        self.height(equalTo: 0, priority: .defaultHigh)
            .width(equalTo: 0, priority: .defaultHigh)
            .onNotRendered { view in
                (view.viewCreator as? Self)?.load()
            }
    }

    public convenience init(_ value: [Value], content: @escaping (Value) -> View) {
        self.init(.frozed(.init(wrappedValue: value)), content: content)
    }

    public convenience init(_ relay: Relay<[Value]>, content: @escaping (Value) -> View) {
        self.init(.dynamic(relay), content: content)
    }

    func load() {
        let syncLoad = self.syncLoad
        self.syncLoad = nil
        syncLoad?(self.releaseUIView())
    }

    var isLoaded: Bool {
        return self.syncLoad == nil
    }
}

extension UICForEach {
    enum Observable {
        case frozed(UICreator.Value<[Value]>)
        case dynamic(Relay<[Value]>)

        func map<OtherValue>(_ handler: @escaping (Value) -> OtherValue) -> Relay<[OtherValue]> {
            let relay: Relay<[Value]> = {
                switch self {
                case .frozed(let value):
                    return value.projectedValue
                case .dynamic(let relay):
                    return relay
                }
            }()

            return relay.map {
                $0.map {
                    handler($0)
                }
            }
        }
    }
}
