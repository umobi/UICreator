//
//  Toggle.swift
//  UICreator
//
//  Created by brennobemoura on 25/12/19.
//

import Foundation
import UIKit

#if os(iOS)
public class _Switch: UISwitch {
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.commitNotRendered()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }
}

public class Switch: UIViewCreator, Control {
    public typealias View = _Switch

    public init(on: Bool) {
        self.uiView = View.init(builder: self)
        (self.uiView as? View)?.isOn = on
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
#endif

