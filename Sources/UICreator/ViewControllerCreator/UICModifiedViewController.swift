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

import ConstraintBuilder

@frozen
public struct UICNotRenderedModifierController<ViewController>: UIViewControllerCreator where ViewController: CBViewController {
    private let notRenderedHandler: (CBViewController) -> Void
    private let content: ViewControllerCreator

    @usableFromInline
    init<Content>(_ content: Content, onNotRendered: @escaping (CBViewController) -> Void) where Content: UIViewControllerCreator, Content.ViewController == ViewController {
        guard let modified = content as? Self else {
            self.content = content
            self.notRenderedHandler = onNotRendered
            return
        }

        self.content = modified.content
        self.notRenderedHandler = {
            modified.notRenderedHandler($0)
            onNotRendered($0)
        }
    }

    public static func _makeUIViewController(_ viewCreator: ViewCreator) -> CBViewController {
        (viewCreator as! Self).content.releaseViewController()
    }

    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        let notRenderedHandler = _self.notRenderedHandler

        return Views.ViewControllerAdaptor((viewCreator as! Self).releaseViewController())
            .onNotRendered {
                notRenderedHandler(($0 as! Views.ViewControllerAdaptor).dynamicViewController)
            }
    }
}

@frozen
public struct UICRenderedModifierController<ViewController>: UIViewControllerCreator where ViewController: CBViewController {
    private let renderedHandler: (CBViewController) -> Void
    private let content: ViewControllerCreator

    @usableFromInline
    init<Content>(_ content: Content, onRendered: @escaping (CBViewController) -> Void) where Content: UIViewControllerCreator, Content.ViewController == ViewController {
        guard let modified = content as? Self else {
            self.content = content
            self.renderedHandler = onRendered
            return
        }

        self.content = modified.content
        self.renderedHandler = {
            modified.renderedHandler($0)
            onRendered($0)
        }
    }

    public static func _makeUIViewController(_ viewCreator: ViewCreator) -> CBViewController {
        (viewCreator as! Self).content.releaseViewController()
    }

    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        let renderedHandler = _self.renderedHandler
        return Views.ViewControllerAdaptor((viewCreator as! Self).releaseViewController())
            .onRendered {
                renderedHandler(($0 as! Views.ViewControllerAdaptor).dynamicViewController)
            }
    }
}

@frozen
public struct UICInTheSceneModifierController<ViewController>: UIViewControllerCreator where ViewController: CBViewController {
    private let inTheSceneHandler: (CBViewController) -> Void
    private let content: ViewControllerCreator

    @usableFromInline
    init<Content>(_ content: Content, onInTheScene: @escaping (CBViewController) -> Void) where Content: UIViewControllerCreator, Content.ViewController == ViewController {
        guard let modified = content as? Self else {
            self.content = content
            self.inTheSceneHandler = onInTheScene
            return
        }

        self.content = modified.content
        self.inTheSceneHandler = {
            modified.inTheSceneHandler($0)
            onInTheScene($0)
        }
    }

    public static func _makeUIViewController(_ viewCreator: ViewCreator) -> CBViewController {
        (viewCreator as! Self).content.releaseViewController()
    }

    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        let inTheSceneHandler = _self.inTheSceneHandler

        return Views.ViewControllerAdaptor((viewCreator as! Self).releaseViewController())
            .onInTheScene {
                inTheSceneHandler(($0 as! Views.ViewControllerAdaptor).dynamicViewController)
            }
    }
}

@frozen
public struct UICLayoutModifierController<ViewController>: UIViewControllerCreator where ViewController: CBViewController {
    private let layoutHandler: (CBViewController) -> Void
    private let content: ViewControllerCreator

    @usableFromInline
    init<Content>(_ content: Content, onLayout: @escaping (CBViewController) -> Void) where Content: UIViewControllerCreator, Content.ViewController == ViewController {
        guard let modified = content as? Self else {
            self.content = content
            self.layoutHandler = onLayout
            return
        }

        self.content = modified.content
        self.layoutHandler = {
            modified.layoutHandler($0)
            onLayout($0)
        }
    }

    public static func _makeUIViewController(_ viewCreator: ViewCreator) -> CBViewController {
        (viewCreator as! Self).content.releaseViewController()
    }

    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        let layoutHandler = _self.layoutHandler

        return Views.ViewControllerAdaptor((viewCreator as! Self).releaseViewController())
            .onLayout {
                layoutHandler(($0 as! Views.ViewControllerAdaptor).dynamicViewController)
            }
    }
}

@frozen
public struct UICAppearModifierController<ViewController>: UIViewControllerCreator where ViewController: CBViewController {
    private let appearHandler: (CBViewController) -> Void
    private let content: ViewControllerCreator

    @usableFromInline
    init<Content>(_ content: Content, onAppear: @escaping (CBViewController) -> Void) where Content: UIViewControllerCreator, Content.ViewController == ViewController {
        guard let modified = content as? Self else {
            self.content = content
            self.appearHandler = onAppear
            return
        }

        self.content = modified.content
        self.appearHandler = {
            modified.appearHandler($0)
            onAppear($0)
        }
    }

    public static func _makeUIViewController(_ viewCreator: ViewCreator) -> CBViewController {
        (viewCreator as! Self).content.releaseViewController()
    }

    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        let appearHandler = _self.appearHandler
        return Views.ViewControllerAdaptor((viewCreator as! Self).releaseViewController())
            .onAppear {
                appearHandler(($0 as! Views.ViewControllerAdaptor).dynamicViewController)
            }
    }
}

@frozen
public struct UICDisappearModifierController<ViewController>: UIViewControllerCreator where ViewController: CBViewController {
    private let disappearHandler: (CBViewController) -> Void
    private let content: ViewControllerCreator

    @usableFromInline
    init<Content>(_ content: Content, onDisappear: @escaping (CBViewController) -> Void) where Content: UIViewControllerCreator, Content.ViewController == ViewController {
        guard let modified = content as? Self else {
            self.content = content
            self.disappearHandler = onDisappear
            return
        }

        self.content = modified.content
        self.disappearHandler = {
            modified.disappearHandler($0)
            onDisappear($0)
        }
    }

    public static func _makeUIViewController(_ viewCreator: ViewCreator) -> CBViewController {
        (viewCreator as! Self).content.releaseViewController()
    }

    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        let disappearHandler = _self.disappearHandler
        return Views.ViewControllerAdaptor((viewCreator as! Self).releaseViewController())
            .onDisappear {
                disappearHandler(($0 as! Views.ViewControllerAdaptor).dynamicViewController)
            }
    }
}

@frozen
public struct UICModifiedViewController<ViewController>: UIViewControllerCreator where ViewController: CBViewController {
    private let viewControllerCreator: ViewControllerCreator

    @inline(__always)
    fileprivate init<Content>(_ viewControllerCreator: Content) where Content: UIViewControllerCreator, Content.ViewController == ViewController {
        self.viewControllerCreator = viewControllerCreator
    }

    public static func _makeUIViewController(_ viewCreator: ViewCreator) -> CBViewController {
        (viewCreator as! Self).viewControllerCreator.releaseViewController()
    }
}

public extension UIViewControllerCreator {
    @inline(__always)
    func eraseToModifiedViewController() -> UICModifiedViewController<ViewController> {
        UICModifiedViewController(self)
    }
}
