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

#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 13, tvOS 13, *)
/// `LivePreview` is the main class that will manipulate the view creator for SwiftUI. It is necessary to use it as SwiftUI.View
public struct LivePreview: SwiftUI.View {

    let view: ViewCreator

    /// The init supports directly constructor of view creator or it can be used the callback constructor. Since view creator doesn’t have a default constructor, it is needed to be created outside of LivePreview.
    public init(_ initClass: ViewCreator) {
        self.view = UICCenter {
            initClass
        }
    }

    /// Create LivePreview with content callback
    public init(content: @escaping () -> ViewCreator) {
        self.view = UICCenter(content: content)
    }

    public var body: some SwiftUI.View {
        Previewer(view)
    }
}

@available(iOS 13, tvOS 13, *)
/// This is an internal class used to display the view creator in SwiftUI views.
public struct Previewer: UIViewRepresentable {

    public typealias UIViewType = UIView

    let view: ViewCreator

    public init(_ initClass: ViewCreator) {
        self.view = initClass
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Previewer>) {}

    public func makeUIView(context: UIViewRepresentableContext<Previewer>) -> UIView {
        return self.view.releaseUIView()
    }
}

#endif
