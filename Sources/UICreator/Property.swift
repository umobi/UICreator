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

@propertyWrapper
public struct Property<Key> {
    @Value private var value: Key
    private let keyPath: KeyPath<PropertyKey, Key>

    /// Before using it on ViewCreator, you should call .dynamicProperty(_:)
    public init(_ keyPath: KeyPath<PropertyKey, Key>) {
        self.keyPath = keyPath
        self._value = .init(wrappedValue: PropertyKey()[keyPath: keyPath])
    }

    public var wrappedValue: Key {
        self.value
    }

    public var projectedValue: Relay<Key> {
        self.$value
    }
}

private extension Property {
    static func notification(_ notificationName: NSNotification.Name, _ view: UIView, handler: @escaping (UIView) -> Void) {
        NotificationCenter.default.addObserver(
            forName: notificationName,
            object: nil,
            queue: nil,
            using: { [weak view] _ in
                guard let view = view else {
                    return
                }

                handler(view)
            }
        )
    }
}

internal extension Property {
    func assign(_ view: UIView) {
        switch self.keyPath {
        case \PropertyKey.accessibilityInvertColors:
            Self.notification(
                UIAccessibility.invertColorsStatusDidChangeNotification,
                view,
                handler: {
                    self.value = PropertyKey($0)[keyPath: self.keyPath]
                }
            )

        case \PropertyKey.accessibilityGrayscaleEnabled:
            Self.notification(
                UIAccessibility.grayscaleStatusDidChangeNotification,
                view,
                handler: {
                    self.value = PropertyKey($0)[keyPath: self.keyPath]
                }
            )

        case \PropertyKey.accessibilityReduceTransparency:
            Self.notification(
                UIAccessibility.reduceTransparencyStatusDidChangeNotification,
                view,
                handler: {
                    self.value = PropertyKey($0)[keyPath: self.keyPath]
                })

        case \PropertyKey.accessibilityReduceMotion:
            Self.notification(
                UIAccessibility.reduceMotionStatusDidChangeNotification,
                view,
                handler: {
                    self.value = PropertyKey($0)[keyPath: self.keyPath]
                })

        case \PropertyKey.accessibilityEnabled:
            Self.notification(
                UIAccessibility.assistiveTouchStatusDidChangeNotification,
                view,
                handler: {
                    self.value = PropertyKey($0)[keyPath: self.keyPath]
                })

        default:
            view.onTrait {
                self.value = PropertyKey($0)[keyPath: self.keyPath]
            }
        }

        self.value = PropertyKey(view)[keyPath: self.keyPath]
    }
}

public extension ViewCreator {
    func dynamicProperty<P0>(_ p0: Property<P0>) -> Self {
        self.onNotRendered {
            p0.assign($0)
        }
    }

    func dynamicProperty<P0, P1>(
        _ p0: Property<P0>,
        _ p1: Property<P1>) -> Self {

        self.onNotRendered {
            p0.assign($0)
            p1.assign($0)
        }
    }

    func dynamicProperty<P0, P1, P2>(
        _ p0: Property<P0>,
        _ p1: Property<P1>,
        _ p2: Property<P2>) -> Self {

        self.onNotRendered {
            p0.assign($0)
            p1.assign($0)
            p2.assign($0)
        }
    }

    func dynamicProperty<P0, P1, P2, P3>(
        _ p0: Property<P0>,
        _ p1: Property<P1>,
        _ p2: Property<P2>,
        _ p3: Property<P3>) -> Self {

        self.onNotRendered {
            p0.assign($0)
            p1.assign($0)
            p2.assign($0)
            p3.assign($0)
        }
    }

    func dynamicProperty<P0, P1, P2, P3, P4>(
        _ p0: Property<P0>,
        _ p1: Property<P1>,
        _ p2: Property<P2>,
        _ p3: Property<P3>,
        _ p4: Property<P4>) -> Self {

        self.onNotRendered {
            p0.assign($0)
            p1.assign($0)
            p2.assign($0)
            p3.assign($0)
            p4.assign($0)
        }
    }

    func dynamicProperty<P0, P1, P2, P3, P4, P5>(
        _ p0: Property<P0>,
        _ p1: Property<P1>,
        _ p2: Property<P2>,
        _ p3: Property<P3>,
        _ p4: Property<P4>,
        _ p5: Property<P5>) -> Self {

        self.onNotRendered {
            p0.assign($0)
            p1.assign($0)
            p2.assign($0)
            p3.assign($0)
            p4.assign($0)
            p5.assign($0)
        }
    }

    func dynamicProperty<P0, P1, P2, P3, P4, P5, P6>(
        _ p0: Property<P0>,
        _ p1: Property<P1>,
        _ p2: Property<P2>,
        _ p3: Property<P3>,
        _ p4: Property<P4>,
        _ p5: Property<P5>,
        _ p6: Property<P6>) -> Self {

        self.onNotRendered {
            p0.assign($0)
            p1.assign($0)
            p2.assign($0)
            p3.assign($0)
            p4.assign($0)
            p5.assign($0)
            p6.assign($0)
        }
    }

    func dynamicProperty<P0, P1, P2, P3, P4, P5, P6, P7>(
        _ p0: Property<P0>,
        _ p1: Property<P1>,
        _ p2: Property<P2>,
        _ p3: Property<P3>,
        _ p4: Property<P4>,
        _ p5: Property<P5>,
        _ p6: Property<P6>,
        _ p7: Property<P7>) -> Self {

        self.onNotRendered {
            p0.assign($0)
            p1.assign($0)
            p2.assign($0)
            p3.assign($0)
            p4.assign($0)
            p5.assign($0)
            p6.assign($0)
            p7.assign($0)
        }
    }
}
