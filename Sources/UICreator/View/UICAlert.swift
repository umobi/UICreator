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

    private init(_ original: UICAlert, editable: Editable) {
        self.title = editable.title
        self.message = editable.message
        self.style = editable.style
        self.action = editable.action
    }

    private func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    public func title(_ string: String) -> Self {
        self.edit {
            $0.title = string
        }
    }

    public func message(_ string: String) -> Self {
        self.edit {
            $0.message = string
        }
    }

    public func style(_ style: UIAlertController.Style) -> Self {
        self.edit {
            $0.style = style
        }
    }

    public func cancelButton(
        _ title: String,
        _ handler: @escaping (UIViewController?) -> Void) -> Self {

        self.edit {
            $0.addAction(title, style: .cancel, handler)
        }
    }

    public func cancelButton(_ title: String) -> Self {
        self.edit {
            $0.addAction(title, style: .cancel)
        }
    }

    public func otherButton(
        _ title: String,
        _ handler: @escaping (UIViewController?) -> Void) -> Self {

        self.edit {
            $0.addAction(title, style: .default, handler)
        }
    }

    public func otherButton(_ title: String) -> Self {
        self.edit {
            $0.addAction(title, style: .default)
        }
    }

    public func destructiveButton(
        _ title: String,
        _ handler: @escaping (UIViewController?) -> Void) -> Self {

        self.edit {
            $0.addAction(title, style: .destructive, handler)
        }
    }

    public func destructiveButton(_ title: String) -> Self {
        self.edit {
            $0.addAction(title, style: .destructive)
        }
    }

    private class Editable {
        var title: String
        var message: String?
        var style: UIAlertController.Style
        fileprivate var action: [Action]

        init(_ original: UICAlert) {
            self.title = original.title
            self.message = original.title
            self.style = original.style
            self.action = original.action
        }

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

    fileprivate func makeUIAlertController() -> UIAlertController {
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

private class ListenerView: UIView {
    let onOutOfWindow: (() -> Void)?

    init(_ handler: @escaping () -> Void) {
        self.onOutOfWindow = handler
        super.init(frame: .zero)
    }

    override init(frame: CGRect) {
        self.onOutOfWindow = nil
        super.init(frame: frame)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        guard self.window == nil else {
            return
        }

        self.onOutOfWindow?()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

public extension UIViewCreator {
    func alert(_ isPresenting: Relay<Bool>, _ handler: @escaping () -> UICAlert) -> UICModifiedView<View> {
        self.onInTheScene {
            weak var view = $0
            weak var alertView: UIViewController?

            let listenerView = ListenerView {
                guard isPresenting.wrappedValue else {
                    return
                }

                guard let alertView = alertView else {
                    isPresenting.wrappedValue = false
                    return
                }

                if !alertView.isBeingPresented {
                    return
                }

                isPresenting.wrappedValue = false
            }

            isPresenting.sync {
                guard $0 else {
                    alertView?.dismiss(animated: true, completion: nil)
                    return
                }

                let alertController: () -> UIViewController = {
                    listenerView.removeFromSuperview()
                    let alertView = handler().makeUIAlertController()
                    alertView.view.addSubview(listenerView)
                    return alertView
                }

                if let oldAlertView = alertView {
                    oldAlertView.dismiss(animated: false) {
                        view?.viewController?.present(
                            alertController(),
                            animated: false,
                            completion: nil
                        )
                    }
                    return
                }

                view?.viewController?.present(
                    alertController(),
                    animated: true,
                    completion: nil
                )
            }
        }
    }
}

private extension UICAlert {
    struct Action {
        let title: String
        let style: UIAlertAction.Style
        let handler: ((UIViewController?) -> Void)?

        internal init(
            _ title: String,
            _ style: UIAlertAction.Style,
            handler: ((UIViewController?) -> Void)?) {

            self.title = title
            self.style = style
            self.handler = handler
        }
    }
}
