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

import UIKit
import ConstraintBuilder

@frozen
public struct UICNotRenderedModifier<View>: UIViewCreator where View: CBView {
    private let notRenderedHandler: (CBView) -> Void
    private let content: ViewCreator

    @usableFromInline
    internal init<Content>(_ content: Content, onNotRendered: @escaping (CBView) -> Void) where Content: UIViewCreator, Content.View == View {
        self.content = content
        self.notRenderedHandler = onNotRendered
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return _self.content
            .releaseUIView()
            .onNotRendered(_self.notRenderedHandler)
    }
}

@frozen
public struct UICRenderedModifier<View>: UIViewCreator where View: CBView {
    private let renderedHandler: (CBView) -> Void
    private let content: ViewCreator

    @usableFromInline
    internal init<Content>(_ content: Content, onRendered: @escaping (CBView) -> Void) where Content: UIViewCreator, Content.View == View {
        self.content = content
        self.renderedHandler = onRendered
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return _self.content
            .releaseUIView()
            .onRendered(_self.renderedHandler)
    }
}

@frozen
public struct UICInTheSceneModifier<View>: UIViewCreator where View: CBView {
    private let inTheSceneHandler: (CBView) -> Void
    private let content: ViewCreator

    @usableFromInline
    internal init<Content>(_ content: Content, onInTheScene: @escaping (CBView) -> Void) where Content: UIViewCreator, Content.View == View {
        self.content = content
        self.inTheSceneHandler = onInTheScene
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return _self.content
            .releaseUIView()
            .onInTheScene(_self.inTheSceneHandler)
    }
}

@frozen
public struct UICLayoutModifier<View>: UIViewCreator where View: CBView {
    private let layoutHandler: (CBView) -> Void
    private let content: ViewCreator

    @usableFromInline
    internal init<Content>(_ content: Content, onLayout: @escaping (CBView) -> Void) where Content: UIViewCreator, Content.View == View {
        self.content = content
        self.layoutHandler = onLayout
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return _self.content
            .releaseUIView()
            .onLayout(_self.layoutHandler)
    }
}

@frozen
public struct UICAppearModifier<View>: UIViewCreator where View: CBView {
    private let appearHandler: (CBView) -> Void
    private let content: ViewCreator

    @usableFromInline
    internal init<Content>(_ content: Content, onAppear: @escaping (CBView) -> Void) where Content: UIViewCreator, Content.View == View {
        self.content = content
        self.appearHandler = onAppear
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return _self.content
            .releaseUIView()
            .onAppear(_self.appearHandler)
    }
}

@frozen
public struct UICDisappearModifier<View>: UIViewCreator where View: CBView {
    private let disappearHandler: (CBView) -> Void
    private let content: ViewCreator

    @usableFromInline
    internal init<Content>(_ content: Content, onDisappear: @escaping (CBView) -> Void) where Content: UIViewCreator, Content.View == View {
        self.content = content
        self.disappearHandler = onDisappear
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return _self.content
            .releaseUIView()
            .onDisappear(_self.disappearHandler)
    }
}
