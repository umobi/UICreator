//
//  UICHostingView.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 24/04/20.
//

import Foundation
import UIKit
import ConstraintBuilder

public class UICHostingController: UIViewController {
    private let viewCreator: ViewCreator

    public init(content: @escaping () -> ViewCreator) {
        self.viewCreator = content()
        super.init(nibName: nil, bundle: nil)
    }

    public init(rootView: ViewCreator) {
        self.viewCreator = rootView
        super.init(nibName: nil, bundle: nil)
    }

    public init() {
        UICreator.Fatal
            .Builder("init() has not been implemented")
            .die()
    }

    required public init?(coder: NSCoder) {
        UICreator.Fatal
            .Builder("init(coder:) has not been implemented")
            .die()
    }

    private var disappearHandler: ((UIViewController) -> Void)?

    func onDisappear(_ handler: @escaping (UIViewController) -> Void) {
        let oldHandler = self.disappearHandler
        self.disappearHandler = {
            oldHandler?($0)
            handler($0)
        }
    }

    func onDismiss(_ handler: @escaping () -> Void) {
        self.onDisappear {
            if $0.isBeingDismissed {
                handler()
            }
        }
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.disappearHandler?(self)
    }

    #if os(iOS)
    public var statusBarStyle: UIStatusBarStyle? = nil {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle ?? UIApplication.shared.statusBarStyle
    }
    #endif

    public override func loadView() {
        self.view = ViewAdaptor(self.viewCreator.releaseUIView())
    }

    @available(iOS 11.0, tvOS 11, *)
    override public func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        self.view.setNeedsUpdateConstraints()
    }
}

extension UICHostingController {
    enum Fatal: String, FatalType {
        case noContentCreator = """
        UICHostingView is trying to get the ViewCreator but no content has been set
        """
    }
}
