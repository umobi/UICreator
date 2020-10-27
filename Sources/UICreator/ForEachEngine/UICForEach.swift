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

    let view: UIView?

    public init() {
        self.view = nil
    }
    
    init(_ view: UIView) {
        self.view = view
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        (viewCreator as! Self).view ?? _EmptyView()
    }
}

extension UICForEach {
    @usableFromInline
    class Enviroment: ForEachEnviromentType {
        @UICOutlet var view: UIView!
        @Relay private var dynamicContent: [() -> ViewCreator]

        private weak var manager: SupportForEach!

        @usableFromInline
        let contentType: ViewCreator.Type

        @usableFromInline
        private(set) var isReleased: Bool = false

        init(_ dynamicValue: Relay<Value>, content: @escaping (Value.Element) -> Content) {
            self.contentType = Content.self
            self._dynamicContent = dynamicValue.map {
                $0.map { element in
                    {
                        content(element)
                    }
                }
            }
        }

        @usableFromInline
        func syncManager() {
            guard !self.isReleased, let manager = self.manager else {
                return
            }

            self.isReleased = true
            manager.viewsDidChange(self.view, self.$dynamicContent)
        }

        @usableFromInline
        func setManager(_ manager: SupportForEach) {
            self.manager = manager
            
            guard !self.isReleased else {
                return
            }
        }
    }
}

@usableFromInline
protocol ForEachEnviromentType: class {
    var contentType: ViewCreator.Type { get }
    func syncManager()
    func setManager(_ manager: SupportForEach)

    var isReleased: Bool { get }
}

@usableFromInline
protocol ForEachEnviromentShared: ViewCreator {
    var enviroment: ForEachEnviromentType { get }
}

@frozen
public struct UICForEach<Content, Value>: ViewCreator, ForEachEnviromentShared where Content: ViewCreator, Value: Collection {
    private let privateEnviroment: Enviroment

    @usableFromInline
    var enviroment: ForEachEnviromentType {
        self.privateEnviroment
    }

    public init(_ dynamicValue: Relay<Value>, content: @escaping (Value.Element) -> Content) {
        self.privateEnviroment = .init(dynamicValue, content: content)
    }

    public init(_ value: Value, content: @escaping (Value.Element) -> Content) {
        self.privateEnviroment = .init(.constant(value), content: content)
    }

    @inline(__always)
    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        EmptyView()
            .height(equalTo: 0, priority: .defaultHigh)
            .width(equalTo: 0, priority: .defaultHigh)
            .onNotRendered {
                (viewCreator as! Self).privateEnviroment.$view.ref($0)
            }
            .onRendered { _ in
                (viewCreator as! Self).privateEnviroment.syncManager()
            }
            .releaseUIView()
    }
}
