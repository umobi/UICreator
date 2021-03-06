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

private struct MEMViewCreator {
    let viewObject: Mutable<MemorySwitch> = .init(value: .nil)
    let loadViewHandler: Mutable<(() -> UIView)?> = .init(value: nil)
    let tree: Mutable<Tree>
    let render: Render
    let viewMethods: ViewMethods
    let isReleased: Mutable<Bool> = .init(value: false)

    init(_ manager: ViewCreator) {
        self.tree = .init(value: .init(manager))
        self.render = .create(manager)
        self.viewMethods = ViewMethods()

        self.render.onNotRendered { [unowned manager] in
            $0.onAppear {
                manager.appear.commit(in: $0)
            }

            $0.onDisappear {
                manager.disappear.commit(in: $0)
            }

            $0.onLayout {
                manager.layout.commit(in: $0)
            }

            $0.onTrait {
                manager.trait.commit(in: $0)
            }
        }
    }
}

extension MEMViewCreator {
    struct ViewMethods {
        let appear: Mutable<UIHandler<UIView>> = .init(value: .init())
        let disappear: Mutable<UIHandler<UIView>> = .init(value: .init())
        let layout: Mutable<UIHandler<UIView>> = .init(value: .init())
        let trait: Mutable<UIHandler<UIView>> = .init(value: .init())
    }
}

private var kMEMViewCreator: UInt = 0
extension ViewCreator {
    private var storedMemory: MEMViewCreator {
        OBJCSet(self, &kMEMViewCreator, policity: .OBJC_ASSOCIATION_COPY) {
            .init(self)
        }
    }

    fileprivate(set) var viewObject: MemorySwitch {
        get { self.storedMemory.viewObject.value }
        set { self.storedMemory.viewObject.value = newValue }
    }

    var appear: UIHandler<UIView> {
        get { self.storedMemory.viewMethods.appear.value }
        set { self.storedMemory.viewMethods.appear.value = newValue }
    }

    var disappear: UIHandler<UIView> {
        get { self.storedMemory.viewMethods.disappear.value }
        set { self.storedMemory.viewMethods.disappear.value = newValue }
    }

    var layout: UIHandler<UIView> {
        get { self.storedMemory.viewMethods.layout.value }
        set { self.storedMemory.viewMethods.layout.value = newValue }
    }

    var trait: UIHandler<UIView> {
        get { self.storedMemory.viewMethods.trait.value }
        set { self.storedMemory.viewMethods.trait.value = newValue }
    }

    fileprivate(set) var loadViewHandler: (() -> UIView)? {
        get { self.storedMemory.loadViewHandler.value }
        set { self.storedMemory.loadViewHandler.value = newValue }
    }

    var render: Render {
        self.storedMemory.render
    }

    fileprivate var isReleased: Bool {
        get { self.storedMemory.isReleased.value }
        set { self.storedMemory.isReleased.value = newValue }
    }

    var tree: Tree {
        get { self.storedMemory.tree.value }
        set { self.storedMemory.tree.value = newValue }
    }
}

struct ViewCreatorUIViewSwitcher {
    static func `switch`(_ viewCreator: ViewCreator?, _ uiView: UIView?) {
        if let viewCreator = viewCreator {
            guard let uiView = uiView else {
                viewCreator.viewObject = .nil
                return
            }

            if viewCreator.isReleased {
                viewCreator.viewObject = .weak(uiView)
                UIView.set(uiView, viewCreator, .strong)
                return
            }


            viewCreator.viewObject = .strong(uiView)
            UIView.set(uiView, viewCreator, .weak)
            return
        }

        if let uiView = uiView {
            UIView.set(uiView, nil, .weak)
            return
        }
    }
}

extension ViewCreator {
    var uiView: UIView! {
        self.viewObject.castedObject()
    }

    var isViewWeaked: Bool {
        self.viewObject.isWeak
    }

    var isViewLoaded: Bool {
        self.uiView != nil
    }

    private func loadViewIfNeeded() -> UIView! {
        if self.isViewLoaded {
            return self.uiView
        }

        let loadView: UIView! = {
            if let loadHandler = self.loadViewHandler {
                self.loadViewHandler = nil
                let view = loadHandler()
                return view
            }

            if let viewMaker = self as? ViewRepresentable {
                return viewMaker.privateMakeUIView()
            }

            if let viewMaker = self as? ViewControllerRepresentable {
                return viewMaker.privateMakeUIView()
            }

            if let uicView = self as? UICView {
                return uicView.makeView()
            }

            ViewCreatorFatal.alreadyLoadedView.die()
        }()

        if loadView.viewCreator === self {
            ViewCreatorUIViewSwitcher.switch(self, loadView)
        }

        return loadView
    }

    func releaseUIView() -> UIView! {
        let uiView: UIView! = self.loadViewIfNeeded()
        self.isReleased = true

        guard uiView.viewCreator === self else {
            return uiView
        }
        
        ViewCreatorUIViewSwitcher.switch(self, uiView)
        return uiView
    }
}

extension ViewCreator {
    @discardableResult
    func loadView(_ handler: @escaping () -> UIView) -> Self {
        self.loadViewHandler = handler
        return self
    }

    func releaseLoader() {
        self.loadViewHandler = nil
    }
}

enum ViewCreatorFatal: String, FatalType {
    case alreadyLoadedView = """
    ViewCreator is trying to load a view, but it may be already loaded or some weird error occurred
    """
}
