//
//  Toggle.swift
//  UICreator
//
//  Created by brennobemoura on 25/12/19.
//

import Foundation
import UIKit

#if os(iOS)
public class Switch: UISwitch, ViewBuilder, Control {
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

public extension ViewBuilder where Self: Switch {
    init(on: Bool) {
        self.init()
        self.isOn = on
    }

    func isOn(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.isOn = flag
        }
    }

    func offImage(_ image: UIImage?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.offImage = image
        }
    }

    func onImage(_ image: UIImage?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.onImage = image
        }
    }

    func onTintColor(_ color: UIColor?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.onTintColor = color
        }
    }

    func thumbTintColor(_ color: UIColor?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.thumbTintColor = color
        }
    }
}

public extension ViewBuilder where Self: UISwitch & Control {
    func onValueChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.appendRendered {
            _ = ($0 as? Self)?.onEvent(.valueChanged, handler)
        }
    }
}
#endif

