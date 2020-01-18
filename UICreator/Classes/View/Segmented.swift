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

public class SegmentedControl: UISegmentedControl {
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.commitNotRendered()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }
}

public class Segment {
    public enum Content {
        case image(UIImage)
        case text(String)
        case empty
    }

    private let content: Content
    private var isEnabled: Bool = true
    private var contentOffset: CGSize? = nil
    private var width: CGFloat? = nil
    private var onSelected: ((UIView) -> Void)? = nil
    private var isSelected: Bool = false

    public init(content: Content) {
        self.content = content
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

    internal func apply(in segmented: Segmented, at index: Int) {
        switch self.content {
        case .image(let image):
            _ = segmented.addSegment(image: image, at: index)
        case .text(let text):
            _ = segmented.addSegment(title: text, at: index)
        case .empty:
            _ = segmented.addSegment(title: nil, at: index)
        }

        _ = segmented.isEnabled(self.isEnabled, at: index)

        if let contentOffset = self.contentOffset {
            _ = segmented.contentOffset(contentOffset, at: index)
        }

        if let width = self.width {
            _ = segmented.width(width, at: index)
        }

        if let onSelected = self.onSelected {
            _ = segmented.onSelectedIndex {
                if $0 == index {
                    onSelected(segmented.releaseUIView())
                }
            }
        }

        if self.isSelected {
            _ = segmented.selectedSegment(at: index)
        }
    }
}

public class Segmented: UIViewCreator, Control {
    public typealias View = SegmentedControl

    public init(_ segments: Segment...) {
        self.uiView = View.init(builder: self)
        self.addSegments(segments)
    }

    public init(_ segments: [Segment]) {
        self.uiView = View.init(builder: self)
        self.addSegments(segments)
    }

    private func addSegments(_ segments: [Segment]) {
        segments.enumerated().forEach {
            $0.element.apply(in: self, at: $0.offset)
        }
    }
}

public extension UIViewCreator where View: UISegmentedControl {
    func addSegment(title: String?, at index: Int? = nil) -> Self {
        self.onNotRendered {
            ($0 as? View)?.insertSegment(withTitle: title, at: index ?? ($0 as? View)?.numberOfSegments ?? 0, animated: false)
        }
    }
    func addSegment(image: UIImage?, at index: Int? = nil) -> Self {
        self.onNotRendered {
            ($0 as? View)?.insertSegment(with: image, at: index ?? ($0 as? View)?.numberOfSegments ?? 0, animated: false)
        }
    }

    @available(iOS 13, tvOS 13, *)
    func selectedTintColor(_ tintColor: UIColor?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.selectedSegmentTintColor = tintColor
        }
    }

    func adjustSegmentByContentWidths(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.apportionsSegmentWidthsByContent = flag
        }
    }

    func isEnabled(_ flag: Bool, at index: Int) -> Self {
        self.onRendered {
            ($0 as? View)?.setEnabled(flag, forSegmentAt: index)
        }
    }

    func contentOffset(_ offset: CGSize, at index: Int) -> Self {
        self.onRendered {
            ($0 as? View)?.setContentOffset(offset, forSegmentAt: index)
        }
    }

    func width(_ constant: CGFloat, at index: Int) -> Self {
        self.onRendered {
            ($0 as? View)?.setWidth(constant, forSegmentAt: index)
        }
    }

    func titleFont(_ font: UIFont, for state: UIControl.State = .normal) -> Self {
        self.onNotRendered {
            let oldAttributes = ($0 as? View)?.titleTextAttributes(for: state) ?? [:]
            ($0 as? View)?.setTitleTextAttributes(oldAttributes.merging([.font: font]) { $1 }, for: state)
        }
    }

    func titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        self.onNotRendered {
            let oldAttributes = ($0 as? View)?.titleTextAttributes(for: state) ?? [:]
            ($0 as? View)?.setTitleTextAttributes(oldAttributes.merging([.foregroundColor: color]) { $1 }, for: state)
        }
    }

    func titleAttributes(_ attributes: [NSAttributedString.Key: Any], for state: UIControl.State = .normal) -> Self {
        self.onNotRendered {
            _ = ($0 as? View)?.setTitleTextAttributes(attributes, for: state)
        }
    }

    func isMomentary(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.isMomentary = flag
        }
    }

    func tintColor(_ tintColor: UIColor?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.tintColor = tintColor
        }
    }

    func selectedSegment(at index: Int) -> Self {
        self.onInTheScene {
            ($0 as? View)?.selectedSegmentIndex = index
        }
    }
}

public extension Control where Self: UIViewCreator, View: UISegmentedControl {
    func onValueChange(_ handler: @escaping (UIView) -> Void) -> Self {
        self.onEvent(.valueChanged, handler)
    }

    func onSelectedIndex(_ handler: @escaping (Int) -> Void) -> Self {
        self.onEvent(.valueChanged) { uiView in
            guard let selected = (uiView as? View)?.selectedSegmentIndex else {
                return
            }

            handler(selected)
        }
    }
}
