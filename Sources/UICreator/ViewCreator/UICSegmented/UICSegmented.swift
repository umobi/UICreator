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

#if FALSE
@_functionBuilder
public struct SegmentBuilder {
    static public func buildBlock(_ segments: Segment...) -> Segment {
        Segment(collection: segments)
    }
}

public struct Segment {
    public enum Content {
        case image(UICImage)
        case text(String)
        case empty
    }

    @MutableBox var isEnabled: Bool = true
    @MutableBox var contentOffset: CGSize?
    @MutableBox var width: CGFloat?

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

    public init(title: String) {
        self.content = .text(title)
        self.collection = nil
    }

    public init(image: UICImage) {
        self.content = .image(image)
        self.collection = nil
    }

    public func isEnabled(_ flag: Bool) -> Self {
        self.isEnabled = flag
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
}

extension Segment {
    struct Builder {
        typealias SegmentedModified = UICModifiedView<SegmentedControl>

        private let viewCreator: SegmentedModified
        private let segment: Segment
        let index: Int

        init(_ viewCreator: SegmentedModified, segment: Segment, at index: Int) {
            self.viewCreator = viewCreator
            self.segment = segment
            self.index = index
        }

        private init(_ viewCreator: SegmentedModified, _self: Self) {
            self.viewCreator = viewCreator
            self.segment = _self.segment
            self.index = _self.index
        }

        func modify(_ edit: (SegmentedModified, Segment, Int) -> SegmentedModified) -> Self {
            .init(edit(self.viewCreator, self.segment, self.index), _self: self)
        }

        func release() -> SegmentedModified {
            self.viewCreator
        }
    }
}

extension Segment.Builder {

    func content() -> Self {
        self.modify {
            switch $1.content {
            case .image(let image):
                return $0.addSegment(image: image, at: $2)
            case .text(let text):
                return $0.addSegment(title: text, at: $2)
            case .empty:
                return $0.addSegment(title: nil, at: $2)
            }
        }
    }

    func isEnabled() -> Self {
        self.modify {
            $0.isEnabled($1.isEnabled, at: $2)
        }
    }

    func contentOffset() -> Self {
        self.modify {
            guard let contentOffset = $1.contentOffset else {
                return $0
            }

            return $0.contentOffset(contentOffset, at: $2)
        }
    }

    func width() -> Self {
        self.modify {
            guard let width = $1.width else {
                return $0
            }

            return $0.width(width, at: $2)
        }
    }
}

extension Segment {
    func build(_ viewCreator: UICModifiedView<SegmentedControl>, at index: Int) -> UICModifiedView<SegmentedControl> {
        Builder(viewCreator, segment: self, at: index)
            .content()
            .isEnabled()
            .contentOffset()
            .width()
            .release()
    }
}

public struct UICSegmented: UIViewCreator {
    public typealias View = SegmentedControl

    @Relay var selectedSegment: Int
    let segments: () -> Segment

    public init(
        selectedSegment: Relay<Int>,
        @SegmentBuilder _ segments: @escaping () -> Segment) {
        self._selectedSegment = selectedSegment
        self.segments = segments
    }

    public static func makeUIView(_ viewCreator: ViewCreator) -> CBView {
        let _self = viewCreator as! Self

        return _self.segments()
            .zip
            .enumerated()
            .reduce(UICModifiedView { SegmentedControl() }) {
                $1.element.build($0, at: $1.offset)
            }
            .onInTheScene {
                weak var view = $0 as? View
                _self.$selectedSegment.distinctSync {
                    view?.selectedSegmentIndex = $0
                }
            }
            .onEvent(.valueChanged) {
                _self.selectedSegment = ($0 as? View)?.selectedSegmentIndex ?? .zero
            }
            .releaseUIView()
    }
}

private extension UICModifiedView where View: SegmentedControl {
    func addSegment(title: String?, at index: Int? = nil) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.insertSegment(
                withTitle: title,
                at: index ?? ($0 as? View)?.numberOfSegments ?? 0,
                animated: false
            )
        }
    }

    func addSegment(image: UICImage?, at index: Int? = nil) -> UICModifiedView<View> {
        self.onNotRendered {
            ($0 as? View)?.insertSegment(
                with: image?.uiImage,
                at: index ?? ($0 as? View)?.numberOfSegments ?? 0,
                animated: false
            )
        }
    }
}

public extension UIViewCreator where View: UISegmentedControl {

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
}

public extension UIViewCreator where View: UISegmentedControl {
    func onValueChange(_ handler: @escaping (UIView) -> Void) -> UICModifiedView<View> {
        self.onEvent(.valueChanged, handler)
    }
}
#endif
