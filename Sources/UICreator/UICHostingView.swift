//
//  UICHostingView.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 24/04/20.
//

import Foundation
import UIKit
import ConstraintBuilder

public class UICHostingView: UIViewController {
    private var strongContentView: UIView?
    private var contentBuilder: ViewCreator?

    private weak var contentView: ViewCreator! {
        willSet {
            self.contentBuilder = nil
        }
    }

    var hostedView: ViewCreator! {
        self.contentView ?? self.contentBuilder
    }

    public init() {
        self.contentBuilder = nil
        super.init(nibName: nil, bundle: nil)
    }

    public init(content: @escaping () -> ViewCreator) {
        self.contentBuilder = content()
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        UICreator.Fatal
            .Builder("init(coder:) has not been implemented")
            .die()
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
        guard let contentBuilder = self.contentBuilder else {
            Fatal.noContentCreator.die()
        }

        self.contentView = contentBuilder

        let contentView: UIView! = contentBuilder.releaseUIView()
        self.view = contentView
    }

    @available(iOS 11.0, tvOS 11, *)
    override public func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        self.view.setNeedsUpdateConstraints()
    }
}

extension UICHostingView {
    enum Fatal: String, FatalType {
        case noContentCreator = """
        UICHostingView is trying to get the ViewCreator but no content has been set
        """
    }
}

//private func unzip(_ callback: @escaping () -> ViewCreator) -> ViewCreator {
//    let viewCreator = callback()
//    if let uicView = viewCreator as? UICView {
//        
//    }
//}
//
//private func unzip<View>(_ callback: @escaping () -> View) -> View where View: ViewCreator {
//    let viewCreator = callback()
//}
