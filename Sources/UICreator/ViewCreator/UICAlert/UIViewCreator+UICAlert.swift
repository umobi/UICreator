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

public extension UIViewCreator {
    func alert(_ isPresenting: Relay<Bool>, _ handler: @escaping () -> UICAlert) -> UICModifiedView<View> {
        self.onInTheScene {
            weak var view = $0
            weak var alertView: UIViewController?

            let listenerView = Views.ListenerView {
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
