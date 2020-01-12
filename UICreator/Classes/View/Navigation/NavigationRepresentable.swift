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
import UIContainer

public protocol NavigationRepresentable: TemplateView {
    var navigationLoader: (UIViewController) -> UINavigationController { get }
    var navigationBar: UINavigationBar { get }

//    init(_ content: @escaping () -> ViewCreator)

    @discardableResult
    func push(animated: Bool, content: @escaping () -> ViewCreator) -> Self

    @discardableResult
    func push(animated: Bool, _ viewController: UIViewController) -> Self

    @discardableResult
    func pop(animated: Bool) -> Self

    @discardableResult
    func popToRoot(animated: Bool) -> Self

    @discardableResult
    func popTo(view: ViewCreator, animated: Bool) -> Self
}

class ContentHandler {
    let content: () -> ViewCreator
    init(_ content: @escaping () -> ViewCreator) {
        self.content = content
    }
}

private var kContentHandler: UInt = 0
private var kNavigationController: UInt = 0
public extension NavigationRepresentable {
    internal weak var navigationController: UINavigationController! {
        return (self.uiView.subviews.first(where: {
            $0 is _Container<UIViewController>
        }) as? _Container<UIViewController>)?.view as? UINavigationController
    }

    var navigationBar: UINavigationBar {
        return self.navigationController.navigationBar
    }

    internal var content: ContentHandler? {
        get { objc_getAssociatedObject(self, &kContentHandler) as? ContentHandler }
        nonmutating
        set { objc_setAssociatedObject(self, &kContentHandler, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var body: ViewCreator {
        Container {
            guard let content = self.content?.content else {
                fatalError()
            }

            self.content = nil
            return self.navigationLoader(ContainerController(Host(content: content)))
        }
    }

    @discardableResult
    func push(animated: Bool, content: @escaping () -> ViewCreator) -> Self {
        self.navigationController.pushViewController(ContainerController(Host(content: content)), animated: animated)
        return self
    }

    @discardableResult
    func push(animated: Bool, _ viewController: UIViewController) -> Self {
        self.navigationController.pushViewController(viewController, animated: animated)
        return self
    }

    @discardableResult
    func pop(animated: Bool) -> Self {
        self.navigationController.popViewController(animated: animated)
        return self
    }

    @discardableResult
    func popToRoot(animated: Bool) -> Self {
        self.navigationController.popToRootViewController(animated: animated)
        return self
    }

    @discardableResult
    func popTo(view: ViewCreator, animated: Bool) -> Self {
        guard let viewController = self.navigationController.viewControllers.first(where: {
            guard let controller = $0 as? ContainerController<Host> else {
                return false
            }

            return controller.contentView.uiView.subviews.first(where: {
                $0 === view.uiView
            }) != nil
        }) else {
            fatalError("\(type(of: view)) is not on first hierarchy")
        }

        self.navigationController.popToViewController(viewController, animated: animated)
        return self
    }
}
