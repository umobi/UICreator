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

#if os(iOS)
public struct ScreenEdgePan: UIGestureCreator {
    public typealias Gesture = UIScreenEdgePanGestureRecognizer

    public init() {}
    
    public static func makeUIGesture(_ gestureCreator: GestureCreator) -> UIGestureRecognizer {
        Gesture()
    }
}

public extension UIViewCreator {
    func onScreenEdgePanMaker<ScreenEdgePan>(_ screenEdgePanConfigurator: @escaping () -> ScreenEdgePan) -> UICModifiedView<View> where ScreenEdgePan: UIGestureCreator, ScreenEdgePan.Gesture: UIScreenEdgePanGestureRecognizer {
        self.onNotRendered {
            screenEdgePanConfigurator().add($0)
        }
    }

    func onScreenEdgePan(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onScreenEdgePanMaker {
            ScreenEdgePan()
                .onRecognized {
                    handler($0.view!)
                }
        }
    }
}
#endif
