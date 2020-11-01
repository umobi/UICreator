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
public struct Pan: UIGestureCreator {
    public typealias Gesture = UIPanGestureRecognizer

    public init() {}

    @inline(__always)
    public static func _makeUIGesture(_ gestureCreator: GestureCreator) -> UIGestureRecognizer {
        Gesture()
    }
}

#if os(iOS)
public extension UIGestureCreator where Gesture: UIPanGestureRecognizer {
    @inlinable
    func maximumNumber(ofTouches number: Int) -> UICModifiedGesture<Gesture> {
        self.onModify {
            ($0 as? Gesture)?.maximumNumberOfTouches = number
        }
    }

    @inlinable
    func minimumNumber(ofTouches number: Int) -> UICModifiedGesture<Gesture> {
        self.onModify {
            ($0 as? Gesture)?.minimumNumberOfTouches = number
        }
    }
}
#endif

public extension UIViewCreator {

    @inlinable
    func onPanMaker<Pan>(_ panConfigurator: @escaping () -> Pan) -> UICNotRenderedModifier<View> where Pan: UIGestureCreator, Pan.Gesture: UIPanGestureRecognizer {
        self.onNotRendered {
            panConfigurator().add($0)
        }
    }

    @inlinable
    func onPan(_ handler: @escaping (CBView) -> Void) -> UICNotRenderedModifier<View> {
        self.onPanMaker {
            Pan()
                .onRecognized {
                    handler($0.view!)
                }
        }
    }
}
