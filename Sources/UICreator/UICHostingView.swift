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

public class UICHostingView: UIView {
    private(set) var content: MemorySwitch = .nil

    public override var isHidden: Bool {
        willSet {
            (self.content.object as? ViewCreator)?
                .uiView?
                .isHidden = newValue
        }
    }

    public init(content: @escaping () -> ViewCreator) {
        self.content = .strong(content())
        super.init(frame: .zero)
    }

    public init(view: ViewCreator) {
        self.content = .strong(view)
        super.init(frame: .zero)
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        guard
            newSuperview != nil,
            !self.content.isWeak,
            let content = self.content.object as? ViewCreator
        else {
            return
        }

        let view: UIView! = content.releaseUIView()
        self.content = .weak(content)

        self.add(priority: .required, view)
    }

    override public init(frame: CGRect) {
        Fatal.Builder("init(frame:) not implemented").die()
    }

    required init?(coder: NSCoder) {
        Fatal.Builder("init(coder:) has not been implemented").die()
    }
}
