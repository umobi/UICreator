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

public protocol ViewCreatorNoLayoutConstraints {}

class ViewAdaptor: UIView, ViewCreatorNoLayoutConstraints {
    struct Weak<Object: NSObject> {
        weak var object: Object!
    }

    enum Store {
        case view(Weak<UIView>)
        case viewController(Weak<UIViewController>)
        case none

        var uiView: UIView! {
            switch self {
            case .view(let weakObject):
                return weakObject.object
            case .viewController(let weakObject):
                return weakObject.object?.view
            case .none:
                return nil
            }
        }
    }

    var store: Store = .none

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self)?.willMove(toSuperview: newSuperview)
        RenderManager(self.store.uiView)?.willMove(toSuperview: self)
    }

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            RenderManager(self)?.isHidden(newValue)
            RenderManager(self.store.uiView)?.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            RenderManager(self)?.frame(newValue)
            RenderManager(self.store.uiView)?.frame(self.store.uiView.frame)
        }
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self)?.didMoveToSuperview()
        RenderManager(self.store.uiView)?.didMoveToSuperview()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self)?.didMoveToWindow()
        RenderManager(self.store.uiView)?.didMoveToWindow()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self)?.layoutSubviews()
        RenderManager(self.store.uiView)?.layoutSubviews()
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        RenderManager(self.store.uiView)?.traitDidChange()
    }
}

class Adaptor: ViewCreator {
    public typealias View = ViewAdaptor

    enum Adaptable {
        case view(ViewCreator)
        case viewController(ViewCreator)

        var viewCreator: ViewCreator {
            switch self {
            case .view(let viewCreator):
                return viewCreator
            case .viewController(let viewCreator):
                return viewCreator
            }
        }
    }

    init(_ adapt: Adaptable) {
        let viewCreator = adapt.viewCreator
        viewCreator.tree.supertree?.append(self)
        viewCreator.tree.supertree?.remove(viewCreator)
        self.tree.append(viewCreator)

        switch adapt {
        case .view:
            let hostedView: UIView! = viewCreator.releaseUIView()

            self.loadView {
                View.init(builder: self)
            }.onNotRendered {
                ($0 as? View)?.store = .view(.init(object: hostedView))
                ($0 as? View)?.add(priority: .required, hostedView)
            }

        case .viewController:
            let hostedController: UIViewController! = viewCreator.releaseUIView().next as? UIViewController

            self.loadView {
                View.init(builder: self)
            }.onNotRendered {
                ($0 as? View)?.store = .viewController(.init(object: hostedController))
            }.onInTheScene {
                $0.viewController.addChild(hostedController)
                $0.add(priority: .required, hostedController.view)
                hostedController.didMove(toParent: $0.viewController)
            }
        }
    }

    func removeSubviews() {
        self.uiView?.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
