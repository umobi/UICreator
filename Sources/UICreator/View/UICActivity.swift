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

public class ActivityIndicatorView: UIActivityIndicatorView {

    init() {
        super.init(frame: .zero)
        self.makeSelfImplemented()
    }

    public override init(style: UIActivityIndicatorView.Style) {
        fatalError("init(style:) has not been implemented")
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
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

public struct UICActivity: UIViewCreator {
    public typealias View = ActivityIndicatorView

    private let style: View.Style

    public init(_ style: View.Style) {
        self.style = style
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return View().onNotRendered {
            ($0 as? View)?.style = _self.style
        }
    }
}

public extension UIViewCreator where View: UIActivityIndicatorView {

    func color(_ color: UIColor) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.color = color
        }
    }

    func hidesWhenStopped(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.hidesWhenStopped = flag
        }
    }
}

public extension UIViewCreator where View: UIActivityIndicatorView {
    func isLoading(_ isLoading: Relay<Bool>) -> UICModifiedView<View> {
        self.onNotRendered { view in
            weak var view = view
            isLoading.sync {
                if $0 {
                    (view as? View)?.startAnimating()
                    return
                }

                (view as? View)?.stopAnimating()
            }
        }
    }
}

public extension UIViewCreator where View: UIActivityIndicatorView {
    func color(_ color: Relay<UIColor>) -> UICModifiedView<View> {
        self.onNotRendered { view in
            weak var view = view
            color.sync {
                (view as? View)?.color = $0
            }
        }
    }
}
