//
//  Input.swift
//  UICreator
//
//  Created by brennobemoura on 25/12/19.
//

import Foundation
import UIKit

public class Input: UIInputView, ViewBuilder {
    required override init(frame: CGRect, inputViewStyle: UIInputView.Style) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var watchingViews: [UIView] {
        return self.subviews
    }

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

public extension ViewBuilder where Self: Input {
    init(size: CGSize = .zero, style: UIInputView.Style = .keyboard, content: () -> UIView) {
        self.init(frame: .init(origin: .zero, size: size), inputViewStyle: style)
        _ = self.add(content())
    }

    func allowsSelfsSizing(_ flag: Bool) -> Self {
        self.allowsSelfSizing = flag
        return self
    }
}
