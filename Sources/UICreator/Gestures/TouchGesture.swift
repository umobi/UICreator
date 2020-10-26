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

public class TouchGestureRecognizer: UIGestureRecognizer {
    public var numberOfTouchedRequired: Int = 1
    private var _numberOfTouches: Int = 0
    private var lastDateTouched: Date?
    public var cancelWhenTouchMoves: Bool = false
    public var lastLocation: CGPoint?

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .possible {
            self.lastLocation = self.location(in: self.view)
            if let lastDate = self.lastDateTouched, Date().timeIntervalSince(lastDate) > 0.250 {
                self._numberOfTouches = 1
            } else {
                self._numberOfTouches += 1
            }

            self.lastDateTouched = .init()

            if self._numberOfTouches == numberOfTouchedRequired {
                self.state = .began
            } else {
                self.state = .cancelled
            }
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.cleanVariables()

        if cancelWhenTouchMoves, let oldLocation = self.lastLocation {
            let newLocation = self.location(in: self.view)
            if abs(oldLocation.x - newLocation.x) > 10 || abs(oldLocation.y - newLocation.y) > 10 {
                self.state = .ended
                self.lastLocation = nil
                return
            }
        }

        self.state = .changed
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .ended
        self.lastLocation = nil
        self.cleanVariables()
    }

    private func cleanVariables() {
        self._numberOfTouches = 0
        self.lastDateTouched = nil
    }

    public override func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.cancelsTouchesInView && [State]([.began, .changed]).first(where: { $0 == self.state }) != nil
    }
}

public struct Touch: UIGestureCreator {
    public typealias Gesture = TouchGestureRecognizer

    public init() {}

    public static func makeUIGesture(_ gestureCreator: GestureCreator) -> UIGestureRecognizer {
        Gesture()
    }
}

#if os(iOS)
public extension UIGestureCreator where Gesture: TouchGestureRecognizer {
    func number(ofTouchesRequired number: Int) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.numberOfTouchedRequired = number
        }
    }

    func cancelWhenTouchMoves(_ flag: Bool) -> UICModifiedGesture<Gesture> {
        self.onModify {
            $0.cancelWhenTouchMoves = flag
        }
    }
}
#endif

public extension UIViewCreator {
    func onTouchMaker<Touch>(_ touchConfigurator: @escaping () -> Touch) -> UICModifiedView<View> where Touch: UIGestureCreator, Touch.Gesture: TouchGestureRecognizer {
        self.onNotRendered {
            touchConfigurator().add($0)
        }
    }

    func onTouch(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onTouchMaker {
            Touch()
                .onRecognized {
                    handler($0.view!)
                }
        }
    }
}
