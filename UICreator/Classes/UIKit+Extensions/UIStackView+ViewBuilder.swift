//
//  UIStackView+ViewBuilder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public extension ViewBuilder where Self: UIStackView {
    init(axis: NSLayoutConstraint.Axis = .vertical, _ views: UIView...) {
        self.init(arrangedSubviews: views)
        _ = self.axis(axis)
    }

    init(axis: NSLayoutConstraint.Axis = .vertical, _ views: [UIView]) {
        self.init(arrangedSubviews: views)
        _ = self.axis(axis)
    }

    var watchingViews: [UIView] {
        return self.arrangedSubviews
    }

    func spacing(_ constant: CGFloat) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.spacing = constant
        }
    }

    func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.axis = axis
        }
    }

    func distribution(_ distribution: Distribution) -> Self {
        return self.appendBeforeRendering {
            ($0 as? Self)?.distribution = distribution
        }
    }
}
