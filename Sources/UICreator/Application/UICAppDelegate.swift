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

#if swift(>=5.3)
private var globalApp: UICApp?

internal class UICAppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    private var appDelegate: UIApplicationDelegate?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.appDelegate = customAppDelegate
        customAppDelegate = nil

        guard let app = globalApp else {
            return false
        }

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        guard let windowGroup = app.body as? UICWindowGroup else {
            return false
        }

        window.rootViewController = UICHostingController(content: windowGroup.content)
        window.makeKeyAndVisible()

        return self.appDelegate?.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? true
    }
}

extension UICAppDelegate {
    static func register(app: UICApp) {
        globalApp = app
    }
}
#endif

extension UIApplication {
    static var stateNotifications: [Notification.Name] {
        [
            UIApplication.didEnterBackgroundNotification,
            UIApplication.didBecomeActiveNotification,
            UIApplication.willResignActiveNotification
        ]
    }
}
