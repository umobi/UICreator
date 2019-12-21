//
//  UIImageView+ViewBuilder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public extension ViewBuilder where Self: UIImageView {
    init(image: UIImage?, highlightedImage: UIImage?) {
        self.init(image: image, highlightedImage: highlightedImage)
    }

    func content(mode: ContentMode) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.contentMode = mode
        }
    }

    func image(_ image: UIImage?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.image = image
        }
    }

    func tint(color: UIColor?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.tintColor = color
        }
    }

    func rendering(mode: UIImage.RenderingMode) -> Self {
        return self.appendRendered {
            ($0 as? Self)?.image = ($0 as? Self)?.image?.withRenderingMode(mode)
        }
    }
}
