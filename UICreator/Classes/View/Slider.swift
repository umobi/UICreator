//
//  Slider.swift
//  UICreator
//
//  Created by brennobemoura on 26/12/19.
//

import Foundation
import UIKit

#if os(iOS)
public class _Slider: UISlider {
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

public class Slider: UIViewCreator, Control {
    public typealias View = _Slider

    init() {
        self.uiView = .init()
    }
}

public extension UIViewCreator where View: UISlider {
    func maximumValue(_ value: Float) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.maximumValue = value
        }
    }

    func minimumValue(_ value: Float) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.minimumValue = value
        }
    }

    func isContinuous(_ flag: Bool) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.isContinuous = flag
        }
    }

    func maximumTrackTintColor(_ tintColor: UIColor) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.maximumTrackTintColor = tintColor
        }
    }

    func minimumTrackTintColor(_ tintColor: UIColor) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.minimumTrackTintColor = tintColor
        }
    }

    func maximumValueImage(_ image: UIImage?) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.maximumValueImage = image
        }
    }

    func minimumValueImage(_ image: UIImage?) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.minimumValueImage = image
        }
    }

    func maximumTrackImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.onRendered {
            ($0 as? View)?.setMaximumTrackImage(image, for: state)
        }
    }

    func minimumTrackImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.onRendered {
            ($0 as? View)?.setMinimumTrackImage(image, for: state)
        }
    }

    func thumbImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.onRendered {
            ($0 as? View)?.setThumbImage(image, for: state)
        }
    }

    func value(_ value: Float) -> Self {
        self.self.onNotRendered {
            ($0 as? View)?.value = value
        }
    }
}

public extension UIViewCreator where Self: Control, View: UISlider {
    func onValueChanged(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onEvent(.valueChanged, handler)
    }
}
#endif
