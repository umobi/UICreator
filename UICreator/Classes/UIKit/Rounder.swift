//
//  Rounder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit
import UIContainer

extension Rounder {
    convenience public init(radius: CGFloat, content: @escaping () -> UIView) {
        self.init(content(), radius: radius)
    }
}
