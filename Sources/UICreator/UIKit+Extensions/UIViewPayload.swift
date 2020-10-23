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

extension NSObject: Opaque {}

private struct UIViewPayload {
    typealias AppearState = UIView.AppearState

    let viewCreator: Mutable<MemorySwitch> = .init(value: .nil)
    let appearState: Mutable<AppearState> = .init(value: .unset)

    let viewMethods: Mutable<UIViewMethods> = .init(value: .init())
}

struct UIViewMethods: MutableEditable {
    let appearHandler: UIHandler<UIView>?
    let disappearHandler: UIHandler<UIView>?
    let layoutHandler: UIHandler<UIView>?
    let traitHandler: UIHandler<UIView>?

    init() {
        self.appearHandler = nil
        self.disappearHandler = nil
        self.layoutHandler = nil
        self.traitHandler = nil
    }

    private init(_ original: UIViewMethods, editable: Editable) {
        self.appearHandler = editable.appearHandler
        self.disappearHandler = editable.disappearHandler
        self.layoutHandler = editable.layoutHandler
        self.traitHandler = editable.traitHandler
    }

    func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    class Editable {
        var appearHandler: UIHandler<UIView>?
        var disappearHandler: UIHandler<UIView>?
        var layoutHandler: UIHandler<UIView>?
        var traitHandler: UIHandler<UIView>?

        init(_ methods: UIViewMethods) {
            self.appearHandler = methods.appearHandler
            self.disappearHandler = methods.disappearHandler
            self.layoutHandler = methods.layoutHandler
            self.traitHandler = methods.traitHandler
        }
    }
}

private var kViewPayload: UInt = 0
extension UIView {
    private var payload: UIViewPayload {
        OBJCSet(self, &kViewPayload, policity: .OBJC_ASSOCIATION_COPY) {
            .init()
        }
    }

    private var viewMethods: Mutable<UIViewMethods> {
        self.payload.viewMethods
    }

    var opaqueViewCreator: MemorySwitch {
        get { self.payload.viewCreator.value }
        set { self.payload.viewCreator.value = newValue }
    }

    var appearState: AppearState {
        get { self.payload.appearState.value }
        set { self.payload.appearState.value = newValue }
    }

    var appearHandler: UIHandler<UIView>? {
        get { self.viewMethods.value.appearHandler }
        set {
            self.viewMethods.update {
                $0.appearHandler = newValue
            }
        }
    }

    var disappearHandler: UIHandler<UIView>? {
        get { self.viewMethods.value.disappearHandler }
        set {
            self.viewMethods.update {
                $0.disappearHandler = newValue
            }
        }
    }

    var layoutHandler: UIHandler<UIView>? {
        get { self.viewMethods.value.layoutHandler }
        set {
            self.viewMethods.update {
                $0.layoutHandler = newValue
            }
        }
    }

    var traitHandler: UIHandler<UIView>? {
        get { self.viewMethods.value.traitHandler }
        set {
            self.viewMethods.update {
                $0.traitHandler = newValue
            }
        }
    }
}
