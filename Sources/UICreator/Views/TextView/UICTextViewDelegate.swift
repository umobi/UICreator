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
import ConstraintBuilder

class UICTextViewDelegate: NSObject, UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.didChange()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.didBeginEditing()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.didEndEditing()
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.didChangeSelection()
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.shouldBeginEditing()
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.shouldEndEditing()
    }

    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String) -> Bool {
        textView.shouldChangeText(range, by: text)
    }

    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction) -> Bool {
        textView.shouldInteract(URL, in: characterRange, interaction)
    }

    func textView(
        _ textView: UITextView,
        shouldInteractWith textAttachment: NSTextAttachment,
        in characterRange: NSRange,
        interaction: UITextItemInteraction) -> Bool {
        textView.shouldInteract(textAttachment, in: characterRange, interaction)
    }
}
