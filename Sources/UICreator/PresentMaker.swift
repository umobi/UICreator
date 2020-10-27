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

@frozen
public struct PresentMaker {
    let onCompletion: (() -> Void)?
    let presentingStyle: UIModalPresentationStyle
    let transitionStyle: UIModalTransitionStyle
    
    @usableFromInline
    let animated: Bool
    @usableFromInline
    let viewToPresent: () -> ViewCreator

    public init(_ content: @escaping () -> ViewCreator) {
        self.viewToPresent = content
        self.onCompletion = nil
        if #available(iOS 13, tvOS 13, *) {
            self.presentingStyle = .automatic
        } else {
            self.presentingStyle = .currentContext
        }
        self.transitionStyle = .coverVertical
        self.animated = true
    }

    private init(_ original: PresentMaker, editable: Editable) {
        self.viewToPresent = original.viewToPresent
        self.presentingStyle = editable.presentingStyle
        self.transitionStyle = editable.transitionStyle
        self.onCompletion = editable.onCompletion
        self.animated = editable.animated
    }

    @inlinable
    public func presentingStyle(_ style: UIModalPresentationStyle) -> Self {
        self.edit {
            $0.presentingStyle = style
        }
    }

    @inlinable
    public func transitionStyle(_ style: UIModalTransitionStyle) -> Self {
        self.edit {
            $0.transitionStyle = style
        }
    }

    @inlinable
    public func onCompletion(_ handler: @escaping () -> Void) -> Self {
        self.edit {
            $0.onCompletion = handler
        }
    }

    @inlinable
    public func animated(_ flag: Bool) -> Self {
        self.edit {
            $0.animated = flag
        }
    }

    @usableFromInline
    func setViewController(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = self.presentingStyle
        viewController.modalTransitionStyle = self.transitionStyle
    }
}

extension PresentMaker {
    @usableFromInline
    struct Editable {

        @MutableBox @usableFromInline
        var presentingStyle: UIModalPresentationStyle

        @MutableBox @usableFromInline
        var transitionStyle: UIModalTransitionStyle

        @MutableBox @usableFromInline
        var onCompletion: (() -> Void)?

        @MutableBox @usableFromInline
        var animated: Bool

        @usableFromInline
        init(_ present: PresentMaker) {
            self._presentingStyle = .init(wrappedValue: present.presentingStyle)
            self._transitionStyle = .init(wrappedValue: present.transitionStyle)
            self._onCompletion = .init(wrappedValue: present.onCompletion)
            self._animated = .init(wrappedValue: present.animated)
        }
    }

    @usableFromInline @inline(__always)
    func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}
