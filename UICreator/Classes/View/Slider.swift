//
//  Slider.swift
//  UICreator
//
//  Created by brennobemoura on 26/12/19.
//

import Foundation
import UIKit

#if os(iOS)
public class Slider: UISlider, ViewBuilder, Control {
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

public extension ViewBuilder where Self: Slider {
    func maximumValue(_ value: Float) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.maximumValue = value
        }
    }

    func minimumValue(_ value: Float) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.minimumValue = value
        }
    }

    func isContinuous(_ flag: Bool) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.isContinuous = flag
        }
    }

    func maximumTrackTintColor(_ tintColor: UIColor) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.maximumTrackTintColor = tintColor
        }
    }

    func minimumTrackTintColor(_ tintColor: UIColor) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.minimumTrackTintColor = tintColor
        }
    }

    func maximumValueImage(_ image: UIImage?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.maximumValueImage = image
        }
    }

    func minimumValueImage(_ image: UIImage?) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.minimumValueImage = image
        }
    }

    func maximumTrackImage(_ image: UIImage?, for state: State = .normal) -> Self {
        self.appendRendered {
            ($0 as? Self)?.setMaximumTrackImage(image, for: state)
        }
    }

    func minimumTrackImage(_ image: UIImage?, for state: State = .normal) -> Self {
        self.appendRendered {
            ($0 as? Self)?.setMinimumTrackImage(image, for: state)
        }
    }

    func thumbImage(_ image: UIImage?, for state: State = .normal) -> Self {
        self.appendRendered {
            ($0 as? Self)?.setThumbImage(image, for: state)
        }
    }

    func value(_ value: Float) -> Self {
        self.appendBeforeRendering {
            ($0 as? Self)?.value = value
        }
    }
}

public extension ViewBuilder where Self: UISlider & Control {
    func onValueChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onEvent(.valueChanged, handler)
    }
}
#endif
