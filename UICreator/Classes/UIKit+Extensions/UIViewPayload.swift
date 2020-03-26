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

private struct UIViewPayload {
    typealias AppearState = UIView.AppearState

    let viewCreator: Mutable<MEMOpaque> = .init(value: .nil)
    let appearState: Mutable<AppearState> = .init(value: .unset)

    let appearMethods: Mutable<UIViewAppearHandler> = .init(value: .init())
    let tabBarItem: Mutable<UITabBarItem?> = .init(value: nil)
}

struct UIViewAppearHandler: MutableEditable {
    let appearHandler: UIHandler<UIView>?
    let disappearHandler: UIHandler<UIView>?
    let layoutHandler: UIHandler<UIView>?

    init() {
        self.appearHandler = nil
        self.disappearHandler = nil
        self.layoutHandler = nil
    }

    private init(_ original: UIViewAppearHandler, editable: Editable) {
        self.appearHandler = editable.appearHandler
        self.disappearHandler = editable.disappearHandler
        self.layoutHandler = editable.layoutHandler
    }

    func edit(_ edit: @escaping (Editable) -> Void) -> UIViewAppearHandler {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    class Editable {
        var appearHandler: UIHandler<UIView>?
        var disappearHandler: UIHandler<UIView>?
        var layoutHandler: UIHandler<UIView>?

        init(_ methods: UIViewAppearHandler) {
            self.appearHandler = methods.appearHandler
            self.disappearHandler = methods.disappearHandler
            self.layoutHandler = methods.layoutHandler
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

    private var appearMethods: Mutable<UIViewAppearHandler> {
        self.payload.appearMethods
    }

    var opaqueViewCreator: MEMOpaque {
        get { self.payload.viewCreator.value }
        set { self.payload.viewCreator.value = newValue }
    }

    var appearState: AppearState {
        get { self.payload.appearState.value }
        set { self.payload.appearState.value = newValue }
    }

    var tabBarItem: UITabBarItem? {
        get { self.payload.tabBarItem.value }
        set { self.payload.tabBarItem.value = newValue }
    }

    var appearHandler: UIHandler<UIView>? {
        get { self.appearMethods.value.appearHandler }
        set {
            self.appearMethods.update {
                $0.appearHandler = newValue
            }
        }
    }

    var disappearHandler: UIHandler<UIView>? {
        get { self.appearMethods.value.disappearHandler }
        set {
            self.appearMethods.update {
                $0.disappearHandler = newValue
            }
        }
    }

    var layoutHandler: UIHandler<UIView>? {
        get { self.appearMethods.value.layoutHandler }
        set {
            self.appearMethods.update {
                $0.layoutHandler = newValue
            }
        }
    }
}
