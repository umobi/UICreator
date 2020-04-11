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

#if os(iOS)
public class _Switch: UISwitch {

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

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self)?.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self)?.didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self)?.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        RenderManager(self)?.traitDidChange()
    }
}

public class UICSwitch: UIViewCreator, Control {
    public typealias View = _Switch

    public init(on: Bool) {
        self.loadView { [unowned self] in
            let view = View.init(builder: self)
            return view
        }
        .onNotRendered {
            ($0 as? View)?.isOn = on
        }
    }
}

public extension UIViewCreator where View: UISwitch {

    func isOn(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.isOn = flag
        }
    }

    func offImage(_ image: UIImage?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.offImage = image
        }
    }

    func onImage(_ image: UIImage?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.onImage = image
        }
    }

    func onTintColor(_ color: UIColor?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.onTintColor = color
        }
    }

    func thumbTintColor(_ color: UIColor?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.thumbTintColor = color
        }
    }
}

public extension UIViewCreator where Self: Control, View: UISwitch {
    func onValueChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onEvent(.valueChanged, handler)
    }
}

public extension UICSwitch {
    convenience init(_ value: Value<Bool>) {
        self.init(on: value.wrappedValue)

        let relay = value.asRelay
        var isLocked = false

        _ = self.onNotRendered { [relay] in
            weak var view = $0 as? View

            relay.sync {
                guard !isLocked else {
                    return
                }

                isLocked = true
                view?.setOn($0, animated: true)
                isLocked = false
            }
        }
        .onValueChanged {
            guard !isLocked else {
                return
            }

            isLocked = true
            value.wrappedValue = ($0 as? View)?.isOn ?? false
            isLocked = false
        }
    }
}

#endif
