//
//  Image.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation

public class Image: UIImageView, ViewBuilder {
    
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

public extension ViewBuilder where Self: UIImageView {
    init() {
        self.init(image: nil, highlightedImage: nil)
    }

    init(_ image: UIImage?, highlightedImage: UIImage?) {
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
