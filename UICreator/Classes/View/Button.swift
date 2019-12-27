//
//  Button.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public class _Button: UIButton {
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

public class Button: UIViewCreator, Control {
    public typealias View = _Button

    public init(_ title: String?, type: UIButton.ButtonType? = nil) {
        if let type = type {
            self.uiView = View.init(type: type)
            (self.uiView as? View)?.setTitle(title, for: .normal)
            return
        }

        self.uiView = View.init(builder: self)
        (self.uiView as? View)?.setTitle(title, for: .normal)
    }
}

public extension UIViewCreator where View: UIButton {

    func title(_ string: String?, for state: UIControl.State = .normal) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.setTitle(string, for: state)
        }
    }

    func title(_ attributedText: NSAttributedString?, for state: UIControl.State = .normal) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.setTitle(attributedText?.string, for: state)
            ($0 as? View)?.titleLabel?.attributedText = attributedText
        }
    }

    func title(color: UIColor?, for state: UIControl.State = .normal) -> Self {
        return self.onNotRendered {
            ($0 as? View)?.setTitleColor(color, for: state)
        }
    }

    func font(_ font: UIFont, isDynamicTextSize: Bool = false) -> Self {
        return self.onRendered {
            ($0 as? View)?.titleLabel?.font = font
            ($0 as? View)?.titleLabel?.isDynamicTextSize = isDynamicTextSize
        }
    }
}

public extension UIViewCreator where View: UIButton, Self: Control {
    func onTouchInside(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onEvent(.touchUpInside, handler)
    }
}

