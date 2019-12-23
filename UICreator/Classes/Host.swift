//
//  Host.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

public class Host: UIContainer.View, ViewControllerType {
    convenience public init(size: CGSize = .zero, _ content: () -> UIView) {
        self.init(frame: .init(origin: .zero, size: size))
        _ = self.add(content())
    }
}

extension Host: ViewControllerAppearStates {
    public func viewWillAppear(_ animated: Bool) {
       self.subviews.forEach {
           ($0 as? ViewControllerAppearStates)?.viewWillAppear(animated)
       }
    }

    public func viewDidAppear(_ animated: Bool) {
       self.subviews.forEach {
           ($0 as? ViewControllerAppearStates)?.viewDidAppear(animated)
       }
    }

    public func viewWillDisappear(_ animated: Bool) {
       self.subviews.forEach {
           ($0 as? ViewControllerAppearStates)?.viewWillDisappear(animated)
       }
    }

    public func viewDidDisappear(_ animated: Bool) {
       self.subviews.forEach {
           ($0 as? ViewControllerAppearStates)?.viewDidDisappear(animated)
       }
    }
}
