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

public class SegmentedControl: UISegmentedControl {

    init() {
        super.init(frame: .zero)
        self.makeSelfImplemented()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            self.renderManager.isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            self.renderManager.frame(newValue)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.renderManager.willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.renderManager.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.renderManager.didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.renderManager.layoutSubviews()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.renderManager.traitDidChange()
    }
}

@_functionBuilder
public struct SegmentBuilder {
    static public func buildBlock(_ segments: Segment...) -> Segment {
        Segment(collection: segments)
    }
}

public struct Segment {
    public enum Content {
        case image(UIImage)
        case text(String)
        case empty
    }

    @MutableBox var isEnabled: Bool = true
    @MutableBox var contentOffset: CGSize?
    @MutableBox var width: CGFloat?
    @MutableBox var onSelected: ((UIView) -> Void)?
    @MutableBox private var isSelected: Bool = false

    private let content: Content
    private let collection: [Segment]?

    var zip: [Segment] {
        if let collection = self.collection {
            return collection
        }

        return [self]
    }

    fileprivate init(collection: [Segment]) {
        self.collection = collection
        self.content = .empty
    }

    public init(content: Content) {
        self.content = content
        self.collection = nil
    }

    public func isEnabled(_ flag: Bool) -> Self {
        self.isEnabled = flag
        return self
    }

    public func isSelected(_ flag: Bool) -> Self {
        self.isSelected = flag
        return self
    }

    public func contentOffset(_ offset: CGSize) -> Self {
        self.contentOffset = offset
        return self
    }

    public func width(_ width: CGFloat) -> Self {
        self.width = width
        return self
    }

    public func onSelected(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onSelected = handler
        return self
    }

    internal func apply(in segmented: UICModifiedView<SegmentedControl>, at index: Int) -> UICModifiedView<SegmentedControl> {
        switch self.content {
        case .image(let image):
            return segmented.addSegment(image: image, at: index)
        case .text(let text):
            return segmented.addSegment(title: text, at: index)
        case .empty:
            return segmented.addSegment(title: nil, at: index)
        }

        return segmented.isEnabled(self.isEnabled, at: index)

        if let contentOffset = self.contentOffset {
            return segmented.contentOffset(contentOffset, at: index)
        }

        if let width = self.width {
            return segmented.width(width, at: index)
        }

        if let onSelected = self.onSelected {
            return segmented.onSelectedIndex {
                if $0 == index {
                    onSelected(segmented.releaseUIView())
                }
            }
        }

        if self.isSelected {
            return segmented.selectedSegment(at: index)
        }
    }
}

public struct UICSegmented: UIViewCreator {
    public typealias View = SegmentedControl

    let segments: () -> Segment

    public init(@SegmentBuilder _ segments: @escaping () -> Segment) {
        self.segments = segments
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return _self.segments()
            .zip
            .enumerated()
            .reduce(UICModifiedView { SegmentedControl() }) {
                $1.element.apply(in: $0, at: $1.offset)
            }
            .releaseUIView()
    }
}

public extension UIViewCreator where View: UISegmentedControl {
    func addSegment(title: String?, at index: Int? = nil) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.insertSegment(
                withTitle: title,
                at: index ?? ($0 as? View)?.numberOfSegments ?? 0,
                animated: false
            )
        }
    }
    
    func addSegment(image: UIImage?, at index: Int? = nil) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.insertSegment(
                with: image,
                at: index ?? ($0 as? View)?.numberOfSegments ?? 0,
                animated: false
            )
        }
    }

    @available(iOS 13, tvOS 13, *)
    func selectedTintColor(_ tintColor: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.selectedSegmentTintColor = tintColor
        }
    }

    func adjustSegmentByContentWidths(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.apportionsSegmentWidthsByContent = flag
        }
    }

    func isEnabled(_ flag: Bool, at index: Int) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.setEnabled(flag, forSegmentAt: index)
        }
    }

    func contentOffset(_ offset: CGSize, at index: Int) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.setContentOffset(offset, forSegmentAt: index)
        }
    }

    func width(_ constant: CGFloat, at index: Int) -> UICModifiedView<View> {
        self.onRendered {
            ($0 as? View)?.setWidth(constant, forSegmentAt: index)
        }
    }

    func titleFont(_ font: UIFont, for state: UIControl.State = .normal) -> UICModifiedView<View> {
        self.onNotRendered {
            let oldAttributes = ($0 as? View)?.titleTextAttributes(for: state) ?? [:]
            ($0 as? View)?.setTitleTextAttributes(oldAttributes.merging([.font: font]) { $1 }, for: state)
        }
    }

    func titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> UICModifiedView<View> {
        self.onNotRendered {
            let oldAttributes = ($0 as? View)?.titleTextAttributes(for: state) ?? [:]
            ($0 as? View)?.setTitleTextAttributes(oldAttributes.merging([.foregroundColor: color]) { $1 }, for: state)
        }
    }

    func titleAttributes(_ attributes: [NSAttributedString.Key: Any], for state: UIControl.State = .normal) -> UICModifiedView<View> {
        self.onNotRendered {
            _ = ($0 as? View)?.setTitleTextAttributes(attributes, for: state)
        }
    }

    func isMomentary(_ flag: Bool) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.isMomentary = flag
        }
    }

    func tintColor(_ tintColor: UIColor?) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.tintColor = tintColor
        }
    }

    func selectedSegment(at index: Int) -> UICModifiedView<View> {
        self.onInTheScene {
            ($0 as? View)?.selectedSegmentIndex = index
        }
    }
}

public extension UIViewCreator where View: UISegmentedControl {
    func onValueChange(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onEvent(.valueChanged, handler)
    }

    func onSelectedIndex(_ handler: @escaping (Int) -> Void) -> UICModifiedView<View> {
        self.onEvent(.valueChanged) { uiView in
            guard let selected = (uiView as? View)?.selectedSegmentIndex else {
                return
            }

            handler(selected)
        }
    }
}
