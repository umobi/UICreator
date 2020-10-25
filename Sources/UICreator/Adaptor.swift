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

public protocol ViewCreatorNoLayoutConstraints {}

enum Reference<Value> where Value: NSObject {
    case weak(Weak)
    case strong(Strong)
    case `nil`

    var value: Value! {
        switch self {
        case .weak(let weak):
            return weak.value
        case .strong(let strong):
            return strong.value
        case .nil:
            return nil
        }
    }

    static func strong(_ element: Value) -> Reference<Value> {
        .strong(.init(value: element))
    }

    static func weak(_ element: Value) -> Reference<Value> {
        .weak(.init(value: element))
    }
}

extension Reference {
    struct Weak {
        weak var value: Value!
    }

    struct Strong {
        var value: Value
    }

    var isWeak: Bool {
        if case .weak = self {
            return true
        }

        return false
    }
}

class ViewAdaptor: UIView, ViewCreatorNoLayoutConstraints {
    var adaptedView: Reference<UIView>

    init(_ view: UIView) {
        self.adaptedView = .strong(view)
        super.init(frame: .zero)
        self.makeSelfImplemented()
        self.adaptView()
    }

    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func adaptView() {
        if !self.adaptedView.isWeak {
            let view = self.adaptedView.value!
            self.adaptedView = .weak(view)

            self.add(priority: .required, view)
        }
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.renderManager.willMove(toSuperview: newSuperview)
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

    override var dynamicView: CBView {
        self.adaptedView.value
    }
}

struct UICAdapt<View>: UIViewCreator where View: UIView {
    private let viewHandler: () -> View

    init(_ viewHandler: @escaping () -> View) {
        self.viewHandler = viewHandler
    }

    static func makeUIView(_ viewCreator: ViewCreator) -> UIView {
        ViewAdaptor((viewCreator as! Self).viewHandler())
    }
}
