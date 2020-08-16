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

//swiftlint:disable colon file_length
internal class UICAppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    //swiftlint:disable weak_delegate
    private lazy var appDelegate: UIApplicationDelegate? = {
        let appDelegate = customAppDelegate
        customAppDelegate = nil
        return appDelegate
    }()

    fileprivate var strongDelegate: UIApplicationDelegate {
        guard let appDelegate = self.appDelegate else {
            fatalError()
        }

        return appDelegate
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

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

    override func responds(to aSelector: Selector!) -> Bool {
        if aSelector == #selector(self.application(_:didFinishLaunchingWithOptions:)) {
            return super.responds(to: aSelector)
        }

        return self.appDelegate?.responds(to: aSelector) ?? false
    }
}

extension UICAppDelegate {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        self.strongDelegate.application!(
            application,
            willFinishLaunchingWithOptions: launchOptions
        )
    }
}

extension UICAppDelegate {
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        self.strongDelegate.application!(
            app,
            open: url,
            options: options
        )
    }

    @available(*, deprecated, message: "deprecated in iOS 9")
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        self.strongDelegate.application!(
            application,
            handleOpen: url
        )
    }

    @available(*, deprecated, message: "deprecated in iOS 9")
    func application(
        _ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any) -> Bool {

        self.strongDelegate.application!(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation
        )
    }
}

extension UICAppDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        self.strongDelegate.applicationWillTerminate!(application)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        self.strongDelegate.applicationWillResignActive!(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.strongDelegate.applicationWillEnterForeground!(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.strongDelegate.applicationDidBecomeActive!(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.strongDelegate.applicationDidEnterBackground!(application)
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        self.strongDelegate.applicationDidFinishLaunching!(application)
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        self.strongDelegate.applicationDidReceiveMemoryWarning!(application)
    }
}

extension UICAppDelegate {
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        self.appDelegate?.applicationProtectedDataWillBecomeUnavailable?(application)
    }

    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        self.appDelegate?.applicationProtectedDataDidBecomeAvailable?(application)
    }
}

extension UICAppDelegate {
    func applicationSignificantTimeChange(_ application: UIApplication) {
        self.strongDelegate.applicationSignificantTimeChange!(application)
    }

    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        self.appDelegate?.applicationShouldRequestHealthAuthorization?(application)
    }
}

extension UICAppDelegate {
    func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        self.appDelegate?.application?(application, didUpdate: userActivity)
    }
}

extension UICAppDelegate {
    func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
        self.appDelegate?.application?(application, willEncodeRestorableStateWith: coder)
    }

    func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
        self.appDelegate?.application?(application, didDecodeRestorableStateWith: coder)
    }
}

extension UICAppDelegate {
    func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
        self.strongDelegate.application!(application, didChangeStatusBarFrame: oldStatusBarFrame)
    }

    func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        self.strongDelegate.application!(application, willChangeStatusBarFrame: newStatusBarFrame)
    }

    func application(
        _ application: UIApplication,
        didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation) {
        self.strongDelegate.application!(application, didChangeStatusBarOrientation: oldStatusBarOrientation)
    }

    func application(
        _ application: UIApplication,
        willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation,
        duration: TimeInterval) {

        self.strongDelegate.application!(
            application,
            willChangeStatusBarOrientation: newStatusBarOrientation,
            duration: duration
        )
    }
}

extension UICAppDelegate {
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {

        self.appDelegate?.application?(
            application,
            didFailToRegisterForRemoteNotificationsWithError: error
        )
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        self.appDelegate?.application?(
            application,
            didRegisterForRemoteNotificationsWithDeviceToken: deviceToken
        )
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        self.strongDelegate.application!(
            application,
            didReceiveRemoteNotification: userInfo,
            fetchCompletionHandler: completionHandler
        )
    }

    @available(*, deprecated, message: "deprecated in iOS 10")
    func application(
        _ application: UIApplication,
        didReceive notification: UILocalNotification) {

        self.appDelegate?.application?(
            application,
            didReceive: notification
        )
    }

    @available(*, deprecated, message: "deprecated in iOS 10")
    func application(
        _ application: UIApplication,
        didRegister notificationSettings: UIUserNotificationSettings) {

        self.appDelegate?.application?(
            application,
            didRegister: notificationSettings
        )
    }

    @available(*, deprecated, message: "deprecated in iOS 10")
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        self.appDelegate?.application?(
            application,
            didReceiveRemoteNotification: userInfo
        )
    }
}

extension UICAppDelegate {
    func application(
        _ application: UIApplication,
        handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?,
        reply: @escaping ([AnyHashable : Any]?) -> Void) {

        self.strongDelegate.application!(
            application,
            handleWatchKitExtensionRequest: userInfo,
            reply: reply
        )
    }
}

extension UICAppDelegate {
    func application(
        _ application: UIApplication,
        shouldAllowExtensionPointIdentifier
            extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {

        self.appDelegate?.application?(
            application,
            shouldAllowExtensionPointIdentifier: extensionPointIdentifier
        ) ?? true
    }
}

extension UICAppDelegate {
    func application(
        _ application: UIApplication,
        shouldSaveApplicationState coder: NSCoder) -> Bool {

        self.strongDelegate.application!(
            application,
            shouldSaveApplicationState: coder
        )
    }

    func application(
        _ application: UIApplication,
        shouldRestoreApplicationState coder: NSCoder) -> Bool {

        self.appDelegate?.application?(
            application,
            shouldRestoreApplicationState: coder
        ) ?? true
    }

    @available(iOS 13.2, tvOS 13.2, *)
    func application(
        _ application: UIApplication,
        shouldSaveSecureApplicationState coder: NSCoder) -> Bool {

        self.strongDelegate.application!(
            application,
            shouldSaveSecureApplicationState: coder
        )
    }

    @available(iOS 13.2, tvOS 13.2, *)
    func application(
        _ application: UIApplication,
        shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {

        self.appDelegate?.application?(
            application,
            shouldRestoreSecureApplicationState: coder
        ) ?? true
    }
}

extension UICAppDelegate {
    @available(*, deprecated, message: "deprecated in iOS 10")
    func application(
        _ application: UIApplication,
        handleActionWithIdentifier identifier: String?,
        for notification: UILocalNotification,
        completionHandler: @escaping () -> Void) {

        self.appDelegate?.application?(
            application,
            handleActionWithIdentifier: identifier,
            for: notification,
            completionHandler: completionHandler
        )
    }

    @available(*, deprecated, message: "deprecated in iOS 10")
    func application(
        _ application: UIApplication,
        handleActionWithIdentifier identifier: String?,
        forRemoteNotification userInfo: [AnyHashable : Any],
        completionHandler: @escaping () -> Void) {

        self.appDelegate?.application?(
            application,
            handleActionWithIdentifier: identifier,
            forRemoteNotification: userInfo,
            completionHandler: completionHandler
        )
    }

    @available(*, deprecated, message: "deprecated in iOS 10")
    func application(
        _ application: UIApplication,
        handleActionWithIdentifier identifier: String?,
        forRemoteNotification userInfo: [AnyHashable : Any],
        withResponseInfo responseInfo: [AnyHashable : Any],
        completionHandler: @escaping () -> Void) {

        self.appDelegate?.application?(
            application,
            handleActionWithIdentifier: identifier,
            forRemoteNotification: userInfo,
            withResponseInfo: responseInfo,
            completionHandler: completionHandler
        )
    }

    @available(*, deprecated, message: "deprecated in iOS 10")
    func application(
        _ application: UIApplication,
        handleActionWithIdentifier identifier: String?,
        for notification: UILocalNotification,
        withResponseInfo responseInfo: [AnyHashable : Any],
        completionHandler: @escaping () -> Void) {

        self.appDelegate?.application?(
            application,
            handleActionWithIdentifier: identifier,
            for: notification,
            withResponseInfo: responseInfo,
            completionHandler: completionHandler
        )
    }
}

extension UICAppDelegate {
    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        self.appDelegate?.application?(
            application,
            continue: userActivity,
            restorationHandler: restorationHandler
        ) ?? false
    }

    func application(
        _ application: UIApplication,
        willContinueUserActivityWithType userActivityType: String) -> Bool {

        self.appDelegate?.application?(
            application,
            willContinueUserActivityWithType: userActivityType
        ) ?? false
    }

    func application(
        _ application: UIApplication,
        didFailToContinueUserActivityWithType userActivityType: String,
        error: Error) {

        self.appDelegate?.application?(
            application,
            didFailToContinueUserActivityWithType: userActivityType,
            error: error
        )
    }
}

extension UICAppDelegate {
    func application(
        _ application: UIApplication,
        performFetchWithCompletionHandler
            completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        self.strongDelegate.application!(
            application,
            performFetchWithCompletionHandler: completionHandler
        )
    }

    func application(
        _ application: UIApplication,
        handleEventsForBackgroundURLSession identifier: String,
        completionHandler: @escaping () -> Void) {

        self.appDelegate?.application?(
            application,
            handleEventsForBackgroundURLSession: identifier,
            completionHandler: completionHandler
        )
    }
}

extension UICAppDelegate {
    func application(
        _ application: UIApplication,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void) {

        self.appDelegate?.application?(
            application,
            performActionFor: shortcutItem,
            completionHandler: completionHandler
        )
    }
}

extension UICAppDelegate {
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        self.strongDelegate.application!(
            application,
            supportedInterfaceOrientationsFor: window
        )
    }

    func application(
        _ application: UIApplication,
        viewControllerWithRestorationIdentifierPath identifierComponents: [String],
        coder: NSCoder) -> UIViewController? {

        self.appDelegate?.application?(
            application,
            viewControllerWithRestorationIdentifierPath: identifierComponents,
            coder: coder
        )
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
