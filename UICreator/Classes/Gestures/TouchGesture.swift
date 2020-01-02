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

public class TouchGesture: UIGestureRecognizer {
    public var numberOfTouchedRequired: Int = 1
    private var _numberOfTouches: Int = 0
    private var lastDateTouched: Date? = nil
    public var cancelWhenTouchMoves: Bool = false
    public var lastLocation: CGPoint? = nil

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

public class Touch: UIGesture {
    public typealias Gesture = TouchGesture

    public required init(target view: UIView!) {
        self.setGesture(Gesture.init(target: view))
        self.gesture.parent = self
    }
}

public extension UIGesture where Gesture: TouchGesture {
    #if os(iOS)
    func number(ofTouchesRequired number: Int) -> Self {
        (self.gesture as? Gesture)?.numberOfTouchedRequired = number
        return self
    }

    func cancelWhenTouchMoves(_ flag: Bool) -> Self {
        (self.gesture as? Gesture)?.cancelWhenTouchMoves = flag
        return self
    }
    #endif
}

public extension UIViewCreator {
    func onTouchMaker(_ touchConfigurator: (Touch) -> Touch) -> Self {
        self.uiView.addGesture(touchConfigurator(Touch(target: self.uiView)))
        return self
    }

    func onTouch(_ handler: @escaping (UIView) -> Void) -> Self {
        return self.onTouchMaker {
            $0.onRecognized { _ in
                handler(self.uiView)
            }
        }
    }
}
