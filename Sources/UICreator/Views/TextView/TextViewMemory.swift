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

private var kTextViewMemory = 0
private extension UITextView {
    struct Memory {
        @MutableBox var didChange: ((UITextView) -> Void)?
        @MutableBox var didBeginEditing: ((UITextView) -> Void)?
        @MutableBox var didEndEditing: ((UITextView) -> Void)?
        @MutableBox var didChangeSelection: ((UITextView) -> Void)?

        @MutableBox var shouldBeginEditing: ((UITextView) -> Bool)?
        @MutableBox var shouldEndEditing: ((UITextView) -> Bool)?
        
        @MutableBox var shouldChangeTextByReplacement: ((UITextView, NSRange, String) -> Bool)?
        @MutableBox var shouldInteractWithURLInRange: ((UITextView, URL, NSRange, UITextItemInteraction) -> Bool)?
        @MutableBox var shouldInteractWithAttachmentInRange: ((UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)?

        @MutableBox var delegate: UICTextViewDelegate?
    }

    var memory: Memory {
        OBJCSet(
            self,
            &kTextViewMemory,
            policity: .OBJC_ASSOCIATION_COPY,
            orLoad: Memory.init
        )
    }
}

extension UITextView {
    @usableFromInline
    func setDelegateIfNeeded() {
        guard self.memory.delegate == nil else {
            return
        }

        let delegate = UICTextViewDelegate()
        self.memory.delegate = delegate
        self.delegate = delegate
    }
}

extension UITextView {
    @inline(__always)
    func didChange() {
        self.memory.didChange?(self)
    }

    @inline(__always)
    func didBeginEditing() {
        self.memory.didBeginEditing?(self)
    }

    @inline(__always)
    func didEndEditing() {
        self.memory.didEndEditing?(self)
    }

    @inline(__always)
    func didChangeSelection() {
        self.memory.didChangeSelection?(self)
    }
}

extension UITextView {
    @inline(__always)
    func shouldBeginEditing() -> Bool {
        self.memory.shouldBeginEditing?(self) ?? true
    }

    @inline(__always)
    func shouldEndEditing() -> Bool {
        self.memory.shouldEndEditing?(self) ?? true
    }
}

extension UITextView {
    @inline(__always)
    func shouldChangeText(_ range: NSRange, by replacement: String) -> Bool {
        self.memory.shouldChangeTextByReplacement?(self, range, replacement) ?? true
    }

    @inline(__always)
    func shouldInteract(_ url: URL, in range: NSRange, _ interaction: UITextItemInteraction) -> Bool {
        self.memory.shouldInteractWithURLInRange?(self, url, range, interaction) ?? false
    }

    @inline(__always)
    func shouldInteract(_ attachment: NSTextAttachment, in range: NSRange, _ interaction: UITextItemInteraction) -> Bool {
        self.memory.shouldInteractWithAttachmentInRange?(self, attachment, range, interaction) ?? false
    }
}

private extension UITextView {

    @inline(__always)
    func onHandler<Parameters, Return>(
        _ keyPath: ReferenceWritableKeyPath<Memory, ((Parameters) -> Return)?>,
        handler: @escaping (Parameters) -> Return,
        returning: @escaping (Return?, Return) -> Return) -> Self {

        self.setDelegateIfNeeded()

        let old = self.memory[keyPath: keyPath]
        self.memory[keyPath: keyPath] = {
            returning(old?($0), handler($0))
        }

        return self
    }

    @inline(__always)
    func onHandler<P1, P2, P3, Return>(
        _ keyPath: ReferenceWritableKeyPath<Memory, ((P1, P2, P3) -> Return)?>,
        handler: @escaping (P1, P2, P3) -> Return,
        returning: @escaping (Return?, Return) -> Return) -> Self {

        self.setDelegateIfNeeded()

        let old = self.memory[keyPath: keyPath]
        self.memory[keyPath: keyPath] = {
            returning(old?($0, $1, $2), handler($0, $1, $2))
        }

        return self
    }

    @inline(__always)
    func onHandler<P1, P2, P3, P4, Return>(
        _ keyPath: ReferenceWritableKeyPath<Memory, ((P1, P2, P3, P4) -> Return)?>,
        handler: @escaping (P1, P2, P3, P4) -> Return,
        returning: @escaping (Return?, Return) -> Return) -> Self {

        self.setDelegateIfNeeded()

        let old = self.memory[keyPath: keyPath]
        self.memory[keyPath: keyPath] = {
            returning(old?($0, $1, $2, $3), handler($0, $1, $2, $3))
        }

        return self
    }
}

public extension UITextView {

    @discardableResult
    func onDidChanged(_ handler: @escaping (UITextView) -> Void) -> Self {
        self.onHandler(
            \.didChange,
            handler: handler,
            returning: { _, _ in }
        )
    }

    @discardableResult
    func onDidBeginEditing(_ handler: @escaping (UITextView) -> Void) -> Self {
        self.onHandler(
            \.didBeginEditing,
            handler: handler,
            returning: { _, _ in }
        )
    }

    @discardableResult
    func onDidEndEditing(_ handler: @escaping (UITextView) -> Void) -> Self {
        self.onHandler(
            \.didEndEditing,
            handler: handler,
            returning: { _, _ in }
        )
    }

    @discardableResult
    func onDidChangeSelection(_ handler: @escaping (UITextView) -> Void) -> Self {
        self.onHandler(
            \.didChangeSelection,
            handler: handler,
            returning: { _, _ in }
        )
    }
}

public extension UITextView {

    @discardableResult
    func onShouldBeginEditing(_ handler: @escaping (UITextView) -> Bool) -> Self {
        self.onHandler(
            \.shouldBeginEditing,
            handler: handler,
            returning: { ($0 ?? true) && $1 }
        )
    }

    @discardableResult
    func onShouldEndEditing(_ handler: @escaping (UITextView) -> Bool) -> Self {
        self.onHandler(
            \.shouldEndEditing,
            handler: handler,
            returning: { ($0 ?? true) && $1 }
        )
    }
}

public extension UITextView {

    @discardableResult
    func onShouldChangeTextByReplacement(_ handler: @escaping (UITextView, NSRange, String) -> Bool) -> Self {
        self.onHandler(
            \.shouldChangeTextByReplacement,
            handler: handler,
            returning: { ($0 ?? true) && $1 }
        )
    }

    @discardableResult
    func onShouldInteractWithURLInRange(_ handler: @escaping (UITextView, URL, NSRange, UITextItemInteraction) -> Bool) -> Self {
        self.onHandler(
            \.shouldInteractWithURLInRange,
            handler: handler,
            returning: { ($0 ?? true) && $1 }
        )
    }

    @discardableResult
    func onShouldInteractWithAttachmentInRange(_ handler: @escaping (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool) -> Self {
        self.onHandler(
            \.shouldInteractWithAttachmentInRange,
            handler: handler,
            returning: { ($0 ?? true) && $1 }
        )
    }
}
