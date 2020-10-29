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
public struct Tap: UIGestureCreator {
    public typealias Gesture = UITapGestureRecognizer

    public init() {}

    @inline(__always)
    public static func _makeUIGesture(_ gestureCreator: GestureCreator) -> UIGestureRecognizer {
        Gesture()
    }
}

public extension UIGestureCreator where Gesture: UITapGestureRecognizer {
    @inlinable
    func number(ofTapsRequired number: Int) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.numberOfTapsRequired = number
        }
    }

    #if os(iOS)
    @inlinable
    func number(ofTouchesRequired number: Int) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.numberOfTouchesRequired = number
        }
    }
    #endif
}

public extension UIViewCreator {
    @inlinable
    func onTapMaker<Tap>(_ tapConfigurator: @escaping () -> Tap) -> UICModifiedView<View> where Tap: UIGestureCreator, Tap.Gesture: UITapGestureRecognizer {
        self.onNotRendered {
            tapConfigurator().add($0)
        }
    }

    @inlinable
    func onTap(_ handler: @escaping (CBView) -> Void) -> UICModifiedView<View> {
        self.onTapMaker {
            Tap()
                .onRecognized {
                    handler($0.view!)
                }
        }
    }
}
