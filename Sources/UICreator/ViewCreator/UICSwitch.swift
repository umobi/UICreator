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

#if os(iOS)
@frozen
public struct UICSwitch: UIViewCreator {
    public typealias View = UISwitch

    @Relay private var isOn: Bool

    public init(isOn: Bool) {
        self._isOn = .constant(isOn)
    }

    public init(isOn: Relay<Bool>) {
        self._isOn = isOn
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return Views.Switch()
            .onEvent(.valueChanged) {
                _self.isOn = ($0 as? View)?.isOn ?? false
            }
            .onNotRendered {
                weak var view = $0 as? View

                _self.$isOn.distinctSync {
                    view?.isOn = $0
                }
            }
    }
}

public extension UIViewCreator where View: UISwitch {

    @inlinable
    func isOn(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.isOn = flag
        }
    }

    @inlinable
    func offImage(_ image: UICImage?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.offImage = image?.uiImage
        }
    }

    @inlinable
    func onImage(_ image: UICImage?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.onImage = image?.uiImage
        }
    }

    @inlinable
    func onTintColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.onTintColor = color
        }
    }

    @inlinable
    func thumbTintColor(_ color: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.thumbTintColor = color
        }
    }
}

#endif
