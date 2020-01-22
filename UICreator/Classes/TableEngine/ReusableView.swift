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

protocol ReusableView {
    var contentView: UIView { get }
    var builder: ViewCreator! { get nonmutating set }
    func prepareCell(builder: UICList.Element.Builder)
}

extension ReusableView {
    func prepareCell(builder: UICList.Element.Builder) {
        if self.contentView.subviews.first is PlaceholderView {
            self.contentView.subviews.forEach {
                $0.removeFromSuperview()
            }

            self.builder = nil
        }

        if self.builder != nil {
            self.contentView.subviews.forEach {
                $0.removeFromSuperview()
            }
        }

        let builder = builder()
        self.builder = builder
        _ = self.contentView.add(builder.releaseUIView())

        if self.contentView.subviews.first is PlaceholderView {
            self.contentView.subviews.first?.snp.makeConstraints {
                $0.height.equalTo(0)
            }
        }
    }
}
