//
//  Gradient+ViewBuilder.swift
//  Pods-UICreator_Example
//
//  Created by brennobemoura on 22/12/19.
//

import Foundation
import UIKit
import UIContainer

public extension ViewBuilder where Self: Gradient {
    init(_ colors: [UIColor], direction: Direction = .right) {
        self.init()
        _ = self.colors(colors)
            .direction(direction)
    }

    init(_ colors: UIColor..., direction: Direction = .right) {
        self.init()
        _ = self.colors(colors)
            .direction(direction)
    }

    func colors(_ colors: UIColor...) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.colors = colors
        }
    }

    func colors(_ colors: [UIColor]) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.colors = colors
        }
    }

    func direction(_ direction: Gradient.Direction) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.direction = direction
        }
    }

    func animation(_ layerHandler: @escaping (CAGradientLayer) -> Void) -> Self {
        self.appendRendered {
            ($0 as? Self)?.animates {
                layerHandler($0)
            }
        }
    }
}
