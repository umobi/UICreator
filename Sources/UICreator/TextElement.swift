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

/// `TextElement` may be removed from this project.
/// It turns some shared methods needed in some view creators.
/// The problem that makes TextElement unnecessary is that it always will need to extend
/// it when creating text elements like Label using `UICViewRepresentable`.
public protocol TextElement: UIViewCreator {
    func text(_ string: String?) -> Self
    func text(_ attributedText: NSAttributedString?) -> Self

    func textColor(_ color: UIColor?) -> Self
    func font(_ font: UIFont, isDynamicTextSize: Bool) -> Self

    func textScale(_ scale: CGFloat) -> Self
    func textAlignment(_ alignment: NSTextAlignment) -> Self

    init(_ text: String?)
    init(_ attributedText: NSAttributedString?)

    func adjustsFontForContentSizeCategory(_ flag: Bool) -> Self
}

public extension TextElement {
    func textScale(_ scale: CGFloat) -> Self {
        Fatal.Builder("text(scale:) not implemented").warning()
        return self
    }
}
