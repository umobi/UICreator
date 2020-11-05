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
public struct UICDisappearModifier<View>: UIViewCreator where View: CBView {
    private let disappearHandler: (CBView) -> Void
    private let content: ViewCreator

    @usableFromInline
    internal init<Content>(_ content: Content, onDisappear: @escaping (CBView) -> Void) where Content: UIViewCreator, Content.View == View {
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

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return _self.content
            .releaseUIView()
            .orDynamic(View.self)
            .onDisappear(_self.disappearHandler)
            .reset()
    }
}
