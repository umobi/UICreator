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
