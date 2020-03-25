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

/**
`protocol ViewCreator` is the **Main** engine that do all the magic for views.

The protocol provides six functions. The `onNotRendered(_:)`, `onRendered(_:)`, `onInTheScene(_:)` that is metods that append callback to view stack
 and the `commitNotRendered()`, `commitRendered()`, `commitInTheScene` that will execute the **subviews** associated callbacks provided by `watchingViews`.
 The basic views may hold subviews, but views like `UIStackView` may return as watchingViews its arrangedSubviews.

The commits functions and UIView's life cycle:
    - `commitNotRendered()` should be executed at `willMove(toSuperview:)`.
    - `commitRendered()` should be executed at `didMoveToSuperview()`.
    - `commitInTheScene()` should be executed at `didMoveToWindow()`.

After committed the callbacks are removed from the stack of Handlers and cannot be redone.

Definitions of UIView as ViewBuild:
    - **root** are views that implements the `var body: UIView` as TemplateView and should add the body as subviews. This core implements the `class View` that does this, so you may change the superclass that your view is extending.
    - **leaf** are views that is the last view in the hierarchy of builders views, so it may manage it self content. This core has `Stack` as `UIStackView`, `Child` as `UIView`, `Table` as `UITableView`. If the view is to much complex and there is no way to keep the right hierarchy of ViewBuilder's methods, you can use the `UICHost` view in the middle of subviews that will keep the integrity of the hierarchy by calling the commits methods for its subviews.
*/

public protocol ViewCreator: class {
    /// It is executed in `willMove(toSubview:)` and depends of superview to call the `commitNotRendered()`.
    @discardableResult
    func onNotRendered(_ handler: @escaping (UIView) -> Void) -> Self

    /// It is executed in `didMoveToSuperview()` and depends of superview to call the `commitRendered()`.
    @discardableResult
    func onRendered(_ handler: @escaping (UIView) -> Void) -> Self

    /// It is executed in `didMoveToWindow()` and depends of superview to call the `commitInTheScene()`.
    @discardableResult
    func onInTheScene(_ handler: @escaping (UIView) -> Void) -> Self

    @discardableResult
    func onLayout(_ handler: @escaping (UIView) -> Void) -> Self

    @discardableResult
    func onAppear(_ handler: @escaping (UIView) -> Void) -> Self

    @discardableResult
    func onDisappear(_ handler: @escaping (UIView) -> Void) -> Self
}

struct DynamicWeakObject<Object> where Object: AnyObject {
    private weak var __weak_uiView: Object!
    private var __strong_uiView: Object!

    weak var object: Object! {
        self.__strong_uiView ?? self.__weak_uiView
    }

    private init(weak object: Object!) {
        self.__weak_uiView = object
        self.__strong_uiView = nil
    }

    private init(strong object: Object!) {
        self.__weak_uiView = nil
        self.__strong_uiView = object
    }

    static func `weak`(_ object: Object) -> Self {
        .init(weak: object)
    }

    static func strong(_ object: Object) -> Self {
        .init(strong: object)
    }

    static var `nil`: Self {
        .init(weak: nil)
    }

    var isWeaked: Bool {
        self.__weak_uiView != nil
    }
}

struct ViewCreatorLoadManager {
    let viewObject: Mutable<DynamicWeakObject<UIView>> = .init(value: .nil)
    let loadViewHandler: Mutable<(() -> UIView)?> = .init(value: nil)
    let tree: Mutable<Tree>
    let render: Mutable<Render>
    let appearsManager: AppearsUtilCreator

    init(_ manager: ViewCreator) {
        self.tree = .init(value: .init(manager))
        self.render = .init(value: .create(manager))
        self.appearsManager = AppearsUtilCreator()

        self.render.value.onNotRendered { [unowned manager] in
            $0.onAppear {
                manager.appearUtil.action($0)
            }

            $0.onDisappear {
                manager.disappearUtil.action($0)
            }

            $0.onLayout {
                manager.layoutUtil.action($0)
            }
        }
    }
}

private var kViewLoadManager: UInt = 0
extension ViewCreator {
    var mem_objects: ViewCreatorLoadManager {
        OBJCSet(self, &kViewLoadManager, policity: .OBJC_ASSOCIATION_COPY) {
            .init(self)
        }
    }
}

private extension ViewCreator {

    private(set) var viewObject: DynamicWeakObject<UIView> {
        get { self.mem_objects.viewObject.value }
        set { self.mem_objects.viewObject.value = newValue }
    }

    var isViewWeaked: Bool {
        self.viewObject.isWeaked
    }

    func setView(_ uiView: UIView, asWeak: Bool = false) {
        self.viewObject = {
            if asWeak {
                return .weak(uiView)
            }

            return .strong(uiView)
        }()

        if let root = self as? (Root & TemplateView) {
            root.viewDidChanged()
        }
    }
}

internal extension ViewCreator {
    weak var uiView: UIView! {
        self.viewObject.object
    }

    func releaseUIView() -> UIView! {
        let uiView: UIView! = self.loadViewIfNeeded()
        guard uiView.viewCreator === self else {
            return uiView
        }
        uiView.setCreator(self, policity: .OBJC_ASSOCIATION_RETAIN)
        self.setView(uiView, asWeak: true)
        return uiView
    }
}

extension ViewCreator {
    private(set) var loadViewHandler: (() -> UIView)? {
        get { self.mem_objects.loadViewHandler.value }
        set { self.mem_objects.loadViewHandler.value = newValue }
    }

    var isViewLoaded: Bool {
        self.uiView != nil
    }

    func loadViewIfNeeded() -> UIView! {
        if self.isViewLoaded {
            return self.uiView
        }

        let loadView: UIView! = {
            if let loadHandler = self.loadViewHandler {
                print("[ViewCreator] setter:loadView \(ObjectIdentifier(self))")
                let view = loadHandler()
                self.loadViewHandler = nil
                return view
            }

            if let viewMaker = self as? UIViewMaker {
                return viewMaker.makeView()
            }

            fatalError()
        }()

        if loadView.viewCreator === self {
            self.setView(loadView, asWeak: true)
        }

        return loadView
    }

    @discardableResult
    func loadView(_ handler: @escaping () -> UIView) -> Self {
        print("[ViewCreator] setter:loadView \(ObjectIdentifier(self))")
        self.loadViewHandler = handler
        print(self.loadViewHandler)
        return self
    }

    fileprivate func releaseLoader() {
        self.loadViewHandler = nil
    }
}

class ReplacementTree {
    private let manager: ViewCreator

    init(_ manager: ViewCreator) {
        self.manager = manager
    }

    func swap(_ newManager: ViewCreator) {
        newManager.setView(self.manager.uiView, asWeak: self.manager.isViewWeaked)
        self.manager.uiView.setCreator(newManager, policity: self.manager.isViewWeaked ? .OBJC_ASSOCIATION_RETAIN : .OBJC_ASSOCIATION_ASSIGN)

        self.manager.tree.supertree?.append(newManager)
        self.manager.tree.supertree?.remove(self.manager)
    }

    func commit(_ newManager: ViewCreator) {
        newManager.render.repeat()
        newManager.releaseLoader()
    }

    private func recursive(_ newManager: ViewCreator) {
        self.swap(newManager)

        var toAppend = newManager.tree.leafs

//        guard (self.manager.tree.leafs.allSatisfy { old in
//            if toAppend.contains(where: { type(of: $0.leaf) == type(of: old.leaf) }) {
//                return true
//            }
//
//            return false
//        }) else {
//            self.manager.root?.uiView.subviews.forEach {
//                $0.removeFromSuperview()
//            }
//        }

        self.manager.tree.leafs.forEach { old in
            if let new = toAppend.enumerated().first(where: { type(of: $0.element.leaf) == type(of: old.leaf) }) {
                if ReplacementTree(old.leaf).replace(with: new.element.leaf) {
                    toAppend.remove(at: new.offset)
                    return
                }
            }

            if let oldLeaf = old.leaf {
                oldLeaf.tree.supertree?.remove(oldLeaf)
                oldLeaf.uiView.removeFromSuperview()
            }
        }

        self.commit(newManager)
    }

    func replace(with newManager: ViewCreator) -> Bool {
        if let maker = newManager as? UIViewMaker, let adaptor = self.manager as? Adaptor {
            adaptor.removeSubviews()
            let newAdaptor = maker.makeView().viewCreator as! Adaptor
            self.swap(newAdaptor)
            self.commit(newAdaptor)
            return true
        }

        guard type(of: self.manager) == type(of: newManager) else {
            return false
        }

        self.recursive(newManager)

        return true
    }
}

extension Render {
    func `repeat`() {
        if self.manager.uiView.superview != nil {
            self.commit(.notRendered)
            self.commit(.rendered)
        }

        if self.manager.uiView.window != nil {
            self.commit(.inTheScene)
        }
    }
}
