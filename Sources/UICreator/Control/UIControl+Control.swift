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

private var kControlMutable: UInt = 0
internal extension UIControl {
    var controlMemory: Mutable<ControlPayload> {
        OBJCSet(self, &kControlMutable) {
            .init(value: .init())
        }
    }
}

extension Control {
    // swiftlint:disable function_body_length cyclomatic_complexity
    public func removeEvent(_ event: UIControl.Event) {
        self.onRendered {
            guard let view = $0 as? UIControl else {
                Fatal.Builder("UIView is not a UIControl").die()
            }

            view.removeTarget($0, action: nil, for: event)
            let control = view.controlMemory

            switch event {
            case .touchDown:
                control.update {
                    $0.touchDown = nil
                }
            case .touchDownRepeat:
                control.update {
                    $0.touchDownRepeat = nil
                }
            case .touchDragInside:
                control.update {
                    $0.touchDragInside = nil
                }
            case .touchDragOutside:
                control.update {
                    $0.touchDragOutside = nil
                }
            case .touchDragEnter:
                control.update {
                    $0.touchDragEnter = nil
                }
            case .touchDragExit:
                control.update {
                    $0.touchDragExit = nil
                }
            case .touchUpInside:
                control.update {
                    $0.touchUpInside = nil
                }
            case .touchUpOutside:
                control.update {
                    $0.touchUpOutside = nil
                }
            case .touchCancel:
                control.update {
                    $0.touchCancel = nil
                }

            case .valueChanged:
                control.update {
                    $0.valueChanged = nil
                }
            case .primaryActionTriggered:
                control.update {
                    $0.primaryActionTriggered = nil
                }

            case .editingDidBegin:
                control.update {
                    $0.editingDidBegin = nil
                }
            case .editingChanged:
                control.update {
                    $0.editingChanged = nil
                }
            case .editingDidEnd:
                control.update {
                    $0.editingDidEnd = nil
                }
            case .editingDidEndOnExit:
                control.update {
                    $0.editingDidEndOnExit = nil
                }

            case .allTouchEvents:
                control.update {
                    $0.allTouchEvents = nil
                }
            case .allEditingEvents:
                control.update {
                    $0.allEditingEvents = nil
                }
            case .applicationReserved:
                control.update {
                    $0.applicationReserved = nil
                }
            case .systemReserved:
                control.update {
                    $0.systemReserved = nil
                }
            case .allEvents:
                control.update {
                    $0.allEvents = nil
                }

            default:
                control.update {
                    $0.allEvents = nil
                }
            }
        }
    }
}
