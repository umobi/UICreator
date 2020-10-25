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

public class ViewControllerAdaptor<ViewController>: UIView, ViewCreatorNoLayoutConstraints where ViewController: CBViewController {
    private var adaptedViewController: Reference<ViewController>

    init(_ viewController: ViewController) {
        self.adaptedViewController = .strong(viewController)
        super.init(frame: .zero)
        self.makeSelfImplemented()
    }

    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        if !self.adaptedViewController.isWeak {
            let viewController = self.adaptedViewController.value!
            self.adaptedViewController = .weak(viewController)

            self.viewController.addChild(viewController)
            self.add(priority: .required, viewController.view)
            viewController.didMove(toParent: self.viewController)
        }

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

    var dynamicViewController: ViewController {
        self.adaptedViewController.value
    }
}

public class UICControllerAdapt<ViewController>: UICViewControllerCreator where ViewController: UIViewController {
    public typealias View = ViewControllerAdaptor<ViewController>

    private let viewControllerHandler: () -> ViewController

    public init(_ viewControllerHandler: @escaping () -> ViewController) {
        self.viewControllerHandler = viewControllerHandler
    }

    static public func makeUIView(_ viewCreator: _ViewCreator) -> UIView {
        ViewControllerAdaptor((viewCreator as! Self).viewControllerHandler())
    }
}

public class ControllerView<ViewController: UIViewController>: UIView {
    weak var view: ViewController!

    public func contain(viewController: ViewController, parentView: UIViewController? = nil) {
        guard let parentView = parentView ?? self.viewController else {
            Fatal.Builder("UICContainer.ContainerView couldn't get parent viewController").die()
        }

        self.view?.view.removeFromSuperview()

        self.view = viewController
        parentView.addChild(viewController)
        CBSubview(self).addSubview(viewController.view)

        Constraintable.activate {
            viewController.view.cbuild
                .edges
        }

        viewController.didMove(toParent: parentView)
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

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.renderManager.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.renderManager.didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.renderManager.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.renderManager.traitDidChange()
    }
}

public class UICContainer<ViewController: UIViewController>: UIViewCreator {
    public typealias View = ControllerView<ViewController>

    public required init(_ content: @escaping () -> ViewController) {
        self.loadView { [unowned self] in
            return View.init(builder: self)
        }
        .onInTheScene {
            ($0 as? View)?.contain(viewController: content())
        }
    }
}
