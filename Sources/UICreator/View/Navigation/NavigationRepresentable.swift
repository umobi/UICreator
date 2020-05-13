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

public protocol NavigationRepresentable: UICView {
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

struct ContentHandler {
    let content: () -> ViewCreator
    init(_ content: @escaping () -> ViewCreator) {
        self.content = content
    }
}

private extension UIView {
    var lowerNavigationController: UINavigationController? {
        if self.next is UINavigationController {
            return self.next as? UINavigationController
        }

        return self.subviews.first(where: {
            $0.lowerNavigationController != nil
        })?.lowerNavigationController
    }
}

func OBJCSet<Object>(_ index: Any, _ key: UnsafeRawPointer, policity: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN, orLoad: @escaping () -> Object) -> Object {
    guard let object = objc_getAssociatedObject(index, key) as? Object else {
        let object = orLoad()
        objc_setAssociatedObject(index, key, object, policity)
        return object
    }

    return object
}

public struct NavigationModifier {
    private weak var navigationRepresentable: NavigationRepresentable!

    public init(_ navigationRepresentable: NavigationRepresentable) {
        self.navigationRepresentable = navigationRepresentable
    }

    public var navigationController: UINavigationController! {
        return self.navigationRepresentable.navigationController
    }
}

private var kContentHandler: UInt = 0
public extension NavigationRepresentable {
    internal var navigationController: UINavigationController! {
        return self.uiView.lowerNavigationController
    }

    var navigationBar: UINavigationBar {
        return self.navigationController.navigationBar
    }

    private var contentMutable: Mutable<ContentHandler?> {
        OBJCSet(self, &kContentHandler) {
            .init(value: nil)
        }
    }

    internal var content: ContentHandler? {
        get { self.contentMutable.value }
        set { self.contentMutable.value = newValue }
    }

    var body: ViewCreator {
        UICContainer { [unowned self] in
            guard let content = self.content?.content else {
                fatalError()
            }

            self.content = nil
            return self.navigationLoader(UICHostingView(content: content))
        }
    }

    @discardableResult
    func push(animated: Bool, content: @escaping () -> ViewCreator) -> Self {
        self.navigationController.pushViewController(UICHostingView(content: content), animated: animated)
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
            $0.view.contains(view)
        }) else {
            fatalError("\(type(of: view)) is not on first hierarchy")
        }

        self.navigationController.popToViewController(viewController, animated: animated)
        return self
    }
}

public extension UIView {
    func contains(_ viewCreator: ViewCreator) -> Bool {
        return self.contains(where: {
            $0 === viewCreator
        })
    }

    func contains(where handler: @escaping (ViewCreator) -> Bool) -> Bool {
        if let viewCreator = self.viewCreator, handler(viewCreator) {
            return true
        }

        if let hostingView = self.next as? UICHostingView {
            return hostingView.hostedView.uiView.contains(where: handler)
        }

        return self.subviews.contains(where: {
            $0.contains(where: handler)
        })
    }
}
