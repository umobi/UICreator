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
import UIContainer

public struct UICResized {

    private let superview: UIView

    public init(_ superview: UIView) {
        self.superview = superview
        self.addHandler = nil
    }

    public init(size: CGSize? = nil, superview: UIView? = nil) {
        if let superview = superview {
            superview.frame = {
                if let size = size {
                    return .init(origin: .zero, size: size)
                }

                return .zero
            }()
            self.addHandler = nil
            self.superview = superview
            return
        }

        self.superview = UIView(frame: .init(origin: .zero, size: size ?? .zero))
        self.addHandler = nil
    }

    private init(_ original: UICResized, addHandler: @escaping (UIView) -> Void) {
        self.superview = original.superview
        self.addHandler = addHandler
    }

    private let addHandler: ((UIView) -> Void)?
    public func onAdd(_ handler: @escaping (UIView) -> Void) -> Self {
        .init(self, addHandler: handler)
    }

    public func addSubview(_ subview: UIView) -> UICWeakResized {
        AddSubview(self.superview)?.addSubview(subview)

        weak var _subview = subview
        subview.appendLayout { _ in
            _subview?.snp.makeConstraints {
                $0.edges.equalTo(0)
            }

            _subview = nil
        }

        self.addHandler?(self.superview)

        return .init(self.superview, subview: subview, self.addHandler)
    }
}

public struct UICWeakResized {
    weak var superview: UIView!
    weak var subview: UIView!

    fileprivate let height: UILayoutPriority?
    fileprivate let width: UILayoutPriority?
    fileprivate let addHandler: ((UIView) -> Void)?

    init(_ superview: UIView!, subview: UIView!,_ addHandler: ((UIView) -> Void)?) {
        self.superview = superview
        self.subview = subview
        self.height = nil
        self.width = nil
        self.addHandler = addHandler
    }

    private init(_ original: UICWeakResized, height: UILayoutPriority?, width: UILayoutPriority?) {
        self.superview = original.superview
        self.subview = original.subview
        self.height = height ?? original.height
        self.width = width ?? original.width
        self.addHandler = original.addHandler
    }

    public func height(_ priority: UILayoutPriority) -> Self {
        .init(self, height: priority, width: nil)
    }

    public func width(_ priority: UILayoutPriority) -> Self {
        .init(self, height: nil, width: priority)
    }
}

public extension UICWeakResized {
    private struct Copy {
        let subview: UIView
        let superview: UIView
        let height: UILayoutPriority?
        let width: UILayoutPriority?
        let addHandler: ((UIView) -> Void)?

        init?(_ original: UICWeakResized) {
            guard let superview = original.superview, let subview = original.subview else {
                return nil
            }

            guard subview.superview === superview, superview.subviews.contains(subview) else {
                return nil
            }

            self.superview = original.superview
            self.subview = original.subview
            self.height = original.height
            self.width = original.width
            self.addHandler = original.addHandler
        }

        func size(for subview: UIView, with size: CGSize) -> CGSize {
            guard size != .zero else {
                return subview.frame.size
            }

            return subview.systemLayoutSizeFitting(
                size,
                withHorizontalFittingPriority: self.width ?? .fittingSizeLevel,
                verticalFittingPriority: self.height ?? .fittingSizeLevel
            )
        }

        fileprivate func updateSuperview(_ size: CGSize) {
            let oldSize = self.superview.frame.size
            self.superview.frame.size = size

            self.subview.snp.remakeConstraints {
                $0.trailing.leading.equalTo(0).priority(self.width ?? .fittingSizeLevel)
                $0.top.bottom.equalTo(0).priority(self.height ?? .fittingSizeLevel)
            }

            self.superview.snp.remakeConstraints {
                $0.width.equalTo(size.width).priority(self.width ?? .fittingSizeLevel)
                $0.height.equalTo(size.height).priority(self.height ?? .fittingSizeLevel)
            }

            self.addHandler?(self.superview)
        }
    }

    private func copy() -> Copy? {
        return Copy(self)
    }

    mutating func dealloac() {
        self.subview = nil
        self.superview = nil
    }

    func watch(in resizableView: UIView!) {
        var muttable: UICWeakResized? = self

        muttable?.subview.appendLayout { [self] in
            guard let copy = self.copy() else {
                muttable?.dealloac()
                return
            }

            let size = copy.size(for: $0, with: copy.superview.frame.size)
            copy.updateSuperview(size)
            $0.frame.size = size
        }

        resizableView.appendLayout { [self] in
            guard let copy = self.copy() else {
                muttable?.dealloac()
                return
            }

            copy.updateSuperview($0.frame.size)
            copy.subview.setNeedsLayout()
        }

        if resizableView.frame.size != .zero {
            muttable?.copy()?.updateSuperview(resizableView.frame.size)
            muttable?.subview?.setNeedsLayout()
        }
    }

    func watch() {
        var muttable: UICWeakResized? = self

        muttable?.subview.appendLayout { [self] in
            guard let copy = self.copy() else {
                muttable?.dealloac()
                return
            }

            let size = copy.size(for: $0, with: copy.superview.frame.size)
            copy.updateSuperview(size)
            $0.frame.size = size
        }

        muttable?.superview.appendLayout { [self] _ in
            guard let copy = self.copy() else {
                muttable?.dealloac()
                return
            }

            copy.subview.setNeedsLayout()
        }

        if muttable?.superview.frame.size != .zero {
            muttable?.subview?.setNeedsLayout()
        }
    }
}
