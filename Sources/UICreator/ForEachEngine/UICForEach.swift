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

class _EmptyView: UIView {

    init() {
        super.init(frame: .zero)
        self.makeSelfImplemented()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            self.renderManager.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            self.renderManager.frame(newValue)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.renderManager.willMove(toSuperview: newSuperview)
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.renderManager.didMoveToSuperview()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        self.renderManager.didMoveToWindow()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.renderManager.layoutSubviews()
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.renderManager.traitDidChange()
    }
}

public struct EmptyView: UIViewCreator {
    public typealias View = UIView

    init() {}

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        _EmptyView()
    }
}

public struct UICForEach<Content, Value>: ViewCreator, ForEachCreator where Content: ViewCreator, Value: Collection {
    @MutableBox var view: Reference<UIView> = .nil
    @MutableBox var syncLoad: (() -> Void)?
    @MutableBox var manager: SupportForEach!
    
    let viewType: ViewCreator.Type

    let relay: Relay<Value>
    let content: (Value.Element) -> ViewCreator

    private func startObservation() {
        let content = self.content
        self.manager?.viewsDidChange(placeholderView: self.view.value, self.relay.map {
            $0.map { element in
                {
                    content(element)
                }
            }
        })
    }

    private init(private relay: Relay<Value>, content: @escaping (Value.Element) -> Content) {
        self.relay = relay
        self.content = content
        self.viewType = Content.self
        self.syncLoad = self.startObservation
    }

    public init(_ relay: Relay<Value>, content: @escaping (Value.Element) -> Content) {
        self.init(private: relay, content: content)
    }

    public init(_ value: Value, content: @escaping (Value.Element) -> Content) {
        self.init(private: .constant(value), content: content)
    }

    func load() {
        let syncLoad = self.syncLoad
        self.syncLoad = nil

        self.view = {
            if let view = self.view.value {
                return .weak(view)
            }

            return .strong(Self.makeUIView(self))
        }()

        syncLoad?()
    }

    var isLoaded: Bool {
        self.syncLoad == nil
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        EmptyView()
            .height(equalTo: 0, priority: .defaultHigh)
            .width(equalTo: 0, priority: .defaultHigh)
            .onRendered {
                (viewCreator as! Self).view = .weak($0)
                (viewCreator as! Self).load()
            }
            .releaseUIView()
    }
}
