//
//  Input.swift
//  UICreator
//
//  Created by brennobemoura on 25/12/19.
//

import Foundation
import UIKit

public class InputView: UIInputView {
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

public class Input: UIViewCreator {
    public typealias View = InputView

    public init(size: CGSize = .zero, style: UIInputView.Style = .keyboard, content: () -> ViewCreator) {
        self.uiView = View.init(frame: .init(origin: .zero, size: size), inputViewStyle: style)
        _ = self.uiView.add(content().uiView)
    }
}

public extension UIViewCreator where View: UIInputView {
    func allowsSelfsSizing(_ flag: Bool) -> Self {
        (self.uiView as? View)?.allowsSelfSizing = flag
        return self
    }
}
