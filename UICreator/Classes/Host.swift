//
//  Host.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public class Host: Root, ViewControllerType, UIViewCreator {
//    let contentHosted: ViewCreator
    public init(size: CGSize = .zero, content: @escaping () -> ViewCreator) {
//        self.contentHosted = content()
        super.init(loader: nil)
        self.uiView.frame = .init(origin: self.uiView.frame.origin, size: size)
        _ = self.uiView.add(content().uiView)
    }

    public required init(_ view: View!) {
        fatalError("init(_:) has not been implemented")
    }

    public required init(loader: (() -> View)? = nil) {
        fatalError("init(loader:) has not been implemented")
    }
}

extension Host: ViewControllerAppearStates {
    var hosted: ViewCreator? {
        return (self.uiView.subviews.first(where: { $0.ViewCreator != nil }))?.ViewCreator
    }

    public func viewWillAppear(_ animated: Bool) {
        (self.hosted as? ViewControllerAppearStates)?.viewWillAppear(animated)
    }

    public func viewDidAppear(_ animated: Bool) {
        (self.hosted as? ViewControllerAppearStates)?.viewDidAppear(animated)
    }

    public func viewWillDisappear(_ animated: Bool) {
        (self.hosted as? ViewControllerAppearStates)?.viewWillDisappear(animated)
    }

    public func viewDidDisappear(_ animated: Bool) {
        (self.hosted as? ViewControllerAppearStates)?.viewDidDisappear(animated)
    }
}
