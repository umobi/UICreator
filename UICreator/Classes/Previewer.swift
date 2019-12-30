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

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, tvOS 13, *)
public struct LivePreview<View: ViewCreator>: SwiftUI.View {

    let view: View
    public init(_ initClass: View) {
        self.view = initClass
    }

    public init(content: () -> View) {
        self.view = content()
    }

    public var body: some SwiftUI.View {
        Previewer<View>(view)
    }
}

@available(iOS 13, tvOS 13, *)
public struct Previewer<View: ViewCreator>: UIViewRepresentable {
    public func makeUIView(context: UIViewRepresentableContext<Previewer<View>>) -> UIView {
        return self.view.uiView
    }

    public typealias UIViewType = UIView

    let view: View

    public init(_ initClass: View) {
        self.view = initClass
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}

#endif
