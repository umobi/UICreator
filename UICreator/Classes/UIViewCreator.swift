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

public protocol UIViewCreator: ViewCreator {
    associatedtype View: UIView
}

open class Context {
    required public init() {}

    private var onContextChangeHandler: (() -> Void)? = nil
    internal func onContextChange(_ handler: @escaping () -> Void) {
        self.onContextChangeHandler = handler
    }

    internal func notifyContextChange() {
        self.onContextChangeHandler?()
    }

    func sync(context: Context) {
        let all = self.onContextChangeHandler
        self.onContextChangeHandler = {
            context.onContextChangeHandler?()
            all?()
        }
    }
}

public protocol ViewContext {

}

public protocol UIViewContext: ViewContext, ViewCreator {
    associatedtype Context: UICreator.Context
    func bindContext(_ context: Context)
}

private var kContext: UInt = 0

internal extension ViewContext {
    private(set) var context: Context? {
        get { objc_getAssociatedObject(self, &kContext) as? Context }
        nonmutating
        set { objc_setAssociatedObject(self, &kContext, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }

    func update(context: Context?) {
        guard let context = context else {
            return
        }

        let storedContext = self.context
        self.context = context
        if let oldContext = storedContext {
            context.sync(context: oldContext)
        }
        self.context?.notifyContextChange()
    }
}

extension UIViewContext {
    public var context: Context {
        get { (objc_getAssociatedObject(self, &kContext) as? Context) ?? {
            let context = Context.init()

            weak var uiView = self.uiView

            context.onContextChange {
                if uiView?.superview == nil {
                    _ = uiView?.viewCreator?.onRendered {
                        guard let _self = $0.viewCreator as? Self else {
                            return
                        }

                        _self.bindContext(_self.context)
                    }

                    return
                }

                guard let _self = uiView?.viewCreator as? Self else {
                    return
                }
                _self.bindContext(_self.context)
            }
            self.update(context: context)
            return context
        }() }
    }
}
