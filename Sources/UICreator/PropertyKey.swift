//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import UIKit

public struct PropertyKey {
    private weak var uiView: UIView?

    internal init() {
        self.uiView = nil
    }

    internal init(_ uiView: UIView) {
        self.uiView = uiView
    }

    public var sizeCategory: UIContentSizeCategory {
        self.uiView?.traitCollection.preferredContentSizeCategory ?? .unspecified
    }

    public var horizontalSizeClass: UIUserInterfaceSizeClass {
        self.uiView?.traitCollection.horizontalSizeClass ?? .unspecified
    }

    public var verticalSizeClass: UIUserInterfaceSizeClass {
        self.uiView?.traitCollection.verticalSizeClass ?? .unspecified
    }

    @available(iOS 13.0, tvOS 13.0, *)
    public var accessibilityContrast: UIAccessibilityContrast {
        self.uiView?.traitCollection.accessibilityContrast ?? .unspecified
    }

    public var accessibilityInvertColors: Bool {
        UIAccessibility.isInvertColorsEnabled
    }

    public var accessibilityGrayscaleEnabled: Bool {
        UIAccessibility.isGrayscaleEnabled
    }

    public var accessibilityEnabled: Bool {
        UIAccessibility.isAssistiveTouchRunning
    }

    public var accessibilityReduceTransparency: Bool {
        UIAccessibility.isReduceTransparencyEnabled
    }

    public var accessibilityReduceMotion: Bool {
        UIAccessibility.isReduceMotionEnabled
    }

    public var layoutDirection: UITraitEnvironmentLayoutDirection {
        self.uiView?.traitCollection.layoutDirection ?? .unspecified
    }
}
