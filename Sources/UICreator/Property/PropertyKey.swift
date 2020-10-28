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
import ConstraintBuilder

@frozen
public struct PropertyKey {
    @usableFromInline
    weak var uiView: CBView?

    internal init() {
        self.uiView = nil
    }

    internal init(_ uiView: CBView) {
        self.uiView = uiView
    }

    @inline(__always) @inlinable
    public var sizeCategory: UIContentSizeCategory {
        self.uiView?.traitCollection.preferredContentSizeCategory ?? .unspecified
    }

    @inline(__always) @inlinable
    public var horizontalSizeClass: UIUserInterfaceSizeClass {
        self.uiView?.traitCollection.horizontalSizeClass ?? .unspecified
    }

    @inline(__always) @inlinable
    public var verticalSizeClass: UIUserInterfaceSizeClass {
        self.uiView?.traitCollection.verticalSizeClass ?? .unspecified
    }

    @inline(__always) @inlinable @available(iOS 13.0, tvOS 13.0, *)
    public var accessibilityContrast: UIAccessibilityContrast {
        self.uiView?.traitCollection.accessibilityContrast ?? .unspecified
    }

    @inlinable
    public var colorScheme: ColorScheme {
        if #available(iOS 12, tvOS 12, *) {
            return .uiTraitCollection(self.uiView?.traitCollection ?? {
                if #available(iOS 13, tvOS 13, *) {
                    return .current
                }

                return .init(userInterfaceStyle: .light)
            }())
        }

        guard let traitCollection = self.uiView?.traitCollection else {
            return .light
        }

        return .uiTraitCollection(traitCollection)
    }

    @inline(__always) @inlinable
    public var accessibilityInvertColors: Bool {
        UIAccessibility.isInvertColorsEnabled
    }

    @inline(__always) @inlinable
    public var accessibilityGrayscaleEnabled: Bool {
        UIAccessibility.isGrayscaleEnabled
    }

    @inline(__always) @inlinable
    public var accessibilityEnabled: Bool {
        UIAccessibility.isAssistiveTouchRunning
    }

    @inline(__always) @inlinable
    public var accessibilityReduceTransparency: Bool {
        UIAccessibility.isReduceTransparencyEnabled
    }

    @inline(__always) @inlinable
    public var accessibilityReduceMotion: Bool {
        UIAccessibility.isReduceMotionEnabled
    }

    @inline(__always) @inlinable
    public var applicationState: UIApplication.State {
        UIApplication.shared.applicationState
    }

    @inline(__always) @inlinable
    public var layoutDirection: UITraitEnvironmentLayoutDirection {
        self.uiView?.traitCollection.layoutDirection ?? .unspecified
    }

    @inline(__always) @inlinable
    public var openURL: URLCaller {
        .init()
    }
}
