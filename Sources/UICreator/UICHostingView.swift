//
//  UICHostingView.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 24/04/20.
//

import Foundation
import UIKit
import UIContainer
import ConstraintBuilder

public class UICHostingView: UIViewController {
    private var strongContentView: UIView? = nil
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
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let strongView = self.strongContentView, strongView.superview == nil else {
            return
        }

        self.strongContentView = nil

        AddSubview(self.view).addSubview(strongView)

        Constraintable.activate(
            strongView.cbuild.edges
        )
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let view = self.hostedView.uiView else {
            return
        }

        self.strongContentView = view
        view.removeFromSuperview()
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

    override public func viewDidLoad() {
        super.viewDidLoad()

        guard let contentBuilder = self.contentBuilder else {
            fatalError()
        }

        let hostView = UICHost(content: { contentBuilder })
        self.contentView = hostView

        let contentView: UIView! = hostView.releaseUIView()
        AddSubview(self.view).addSubview(contentView)

        Constraintable.activate(
            contentView.cbuild.edges
        )
    }

    @available(iOS 11.0, tvOS 11, *)
    override public func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        self.view.setNeedsUpdateConstraints()
    }
}
