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
import UIContainer

public class RootView: UIView {
    var willCommitNotRenderedHandler: (() -> Void)?
    var didCommitNotRenderedHandler: (() -> Void)?

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        self.willCommitNotRenderedHandler?()
        self.willCommitNotRenderedHandler = nil

        self.commitNotRendered()

        self.didCommitNotRenderedHandler?()
        self.didCommitNotRenderedHandler = nil
    }

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

    override var watchingViews: [UIView] {
        return [self] + self.subviews
    }
}

private var kViewDidLoad: UInt = 0
@objc extension Root {

    private(set) var didViewLoad: Bool {
        get { (objc_getAssociatedObject(self, &kViewDidLoad) as? Bool) ?? false }
        set { (objc_setAssociatedObject(self, &kViewDidLoad, newValue, .OBJC_ASSOCIATION_RETAIN)) }
    }

    open func viewDidLoad() {
        self.didViewLoad = true
    }
}

open class Root: ViewCreator {
    public typealias View = RootView

    public init() {
        self.uiView = View.init(builder: self)
    }
}

private var kTemplateViewDidConfiguredView: UInt = 0
extension TemplateView where Self: Root {
    private var didConfiguredView: Bool {
        get { (objc_getAssociatedObject(self, &kTemplateViewDidConfiguredView) as? Bool) ?? false }
        nonmutating
        set { objc_setAssociatedObject(self, &kTemplateViewDidConfiguredView, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    internal func viewDidChanged() {
        guard !self.didConfiguredView else {
            return
        }

        self.didConfiguredView = true

        if self.uiView.subviews.isEmpty {
            (self.uiView as? View)?.willCommitNotRenderedHandler = { [unowned self] in
                _ = self.uiView.add(self.body.uiView)
            }
        }

        (self.uiView as? View)?.didCommitNotRenderedHandler = { [unowned self] in
            if !self.didViewLoad {
                self.viewDidLoad()
            }
        }
    }
}
