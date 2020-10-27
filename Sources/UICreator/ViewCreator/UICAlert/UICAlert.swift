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
public struct UICAlert {
    private let title: String
    private let message: String?
    private let style: UIAlertController.Style
    private let action: [Action]

    public init(_ title: String) {
        self.title = title
        self.message = nil
        self.style = .alert
        self.action = [.init(
            "Cancelar",
            .cancel,
            handler: { $0?.dismiss(animated: true, completion: nil) }
        )]
    }

    public init(style: UIAlertController.Style) {
        self.title = ""
        self.message = nil
        self.style = style
        self.action = [.init(
            "Cancelar",
            .cancel,
            handler: { $0?.dismiss(animated: true, completion: nil) }
        )]
    }

    fileprivate init(_ original: UICAlert, editable: Editable) {
        self.title = editable.title
        self.message = editable.message
        self.style = editable.style
        self.action = editable.action
    }

    @usableFromInline
    internal func makeUIAlertController() -> UIAlertController {
        let alert = UIAlertController(
            title: self.title,
            message: self.message,
            preferredStyle: self.style
        )

        self.action.forEach { payload in
            alert.addAction(
                .init(
                    title: payload.title,
                    style: payload.style,
                    handler: { [weak alert] _ in payload.handler?(alert) }
                )
            )
        }

        return alert
    }
}

public extension UICAlert {

    @inline(__always)
    func title(_ string: String) -> Self {
        self.edit {
            $0.title = string
        }
    }

    @inline(__always)
    func message(_ string: String) -> Self {
        self.edit {
            $0.message = string
        }
    }

    @inline(__always)
    func style(_ style: UIAlertController.Style) -> Self {
        self.edit {
            $0.style = style
        }
    }

    @inline(__always)
    func cancelButton(
        _ title: String,
        _ handler: @escaping (UIViewController?) -> Void) -> Self {

        self.edit {
            $0.addAction(title, style: .cancel, handler)
        }
    }

    @inline(__always)
    func cancelButton(_ title: String) -> Self {
        self.edit {
            $0.addAction(title, style: .cancel)
        }
    }

    @inline(__always)
    func otherButton(
        _ title: String,
        _ handler: @escaping (UIViewController?) -> Void) -> Self {

        self.edit {
            $0.addAction(title, style: .default, handler)
        }
    }
    @inline(__always)
    func otherButton(_ title: String) -> Self {
        self.edit {
            $0.addAction(title, style: .default)
        }
    }

    @inline(__always)
    func destructiveButton(
        _ title: String,
        _ handler: @escaping (UIViewController?) -> Void) -> Self {

        self.edit {
            $0.addAction(title, style: .destructive, handler)
        }
    }

    @inline(__always)
    func destructiveButton(_ title: String) -> Self {
        self.edit {
            $0.addAction(title, style: .destructive)
        }
    }
}

extension UICAlert {
    @usableFromInline
    struct Editable {
        @MutableBox var title: String
        @MutableBox var message: String?
        @MutableBox var style: UIAlertController.Style
        @MutableBox var action: [Action]

        @usableFromInline
        init(_ original: UICAlert) {
            self._title = .init(wrappedValue: original.title)
            self._message = .init(wrappedValue: original.title)
            self._style = .init(wrappedValue: original.style)
            self._action = .init(wrappedValue: original.action)
        }

        @usableFromInline
        func addAction(
            _ title: String,
            style: UIAlertAction.Style,
            _ handler: @escaping (UIViewController?) -> Void) {

            if style != .default {
                self.action = self.action.filter { $0.style != style }
            }

            self.action.append(.init(
                title,
                style,
                handler: {
                    handler($0)
                    $0?.dismiss(animated: true, completion: nil)
                }
            ))
        }

        @usableFromInline
        func addAction(_ title: String, style: UIAlertAction.Style) {
            if style != .default {
                self.action = self.action.filter { $0.style != style }
            }

            self.action.append(.init(
                title,
                style,
                handler: { $0?.dismiss(animated: true, completion: nil) }
            ))
        }
    }

    @inline(__always)
    func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}
