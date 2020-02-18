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

public protocol CollectionLayout {
    associatedtype Layout: UICollectionViewLayout
    var dynamicCollectionViewLayout: Layout { get }
}

public class _CollectionView: UICollectionView {

    override open var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            RenderManager(self).isHidden(newValue)
        }
    }

    override open var frame: CGRect {
        get { super.frame }
        set {
            super.frame = newValue
            RenderManager(self).frame(newValue)
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        RenderManager(self).willMove(toSuperview: newSuperview)
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        RenderManager(self).didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        RenderManager(self).didMoveToWindow()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        RenderManager(self).layoutSubviews()
    }
}

public class UICCollection: UIViewCreator, HasViewDelegate, HasViewDataSource {
    public typealias View = _CollectionView
    init(layout: () -> UICollectionViewLayout) {
        self.uiView = View(frame: .zero, collectionViewLayout: layout())
        self.uiView.updateBuilder(self)
    }

    public func delegate(_ delegate: UICollectionViewDelegate?) -> Self {
        (self.uiView as? View)?.delegate = delegate
        return self
    }

    public func dataSource(_ dataSource: UICollectionViewDataSource?) -> Self {
        (self.uiView as? View)?.dataSource = dataSource
        return self
    }
}

public extension UIViewCreator where View: UICollectionView {
    func addCell(for identifier: String, _ cellClass: AnyClass?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.register(cellClass, forCellWithReuseIdentifier: identifier)
        }
    }

    func addCell(for identifier: String, _ uiNib: UINib?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.register(uiNib, forCellWithReuseIdentifier: identifier)
        }
    }

    func addSupplementary(for identifier: String, viewOfKind kind: String, _ cellClass: AnyClass?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.register(cellClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        }
    }

    func addSupplementary(for identifier: String, viewOfKind kind: String, _ uiNib: UINib?) -> Self {
        self.onNotRendered {
            ($0 as? View)?.register(uiNib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        }
    }

    func allowsMultipleSelection(_ flag: Bool) -> Self {
        self.onRendered {
            ($0 as? View)?.allowsMultipleSelection = flag
        }
    }

    func allowsSelection(_ flag: Bool) -> Self {
        self.onRendered {
            ($0 as? View)?.allowsSelection = flag
        }
    }

    func background<Background: ViewCreator>(_ content: @escaping () -> Background) -> Self {
        self.onNotRendered {
            ($0 as? View)?.backgroundView = UICHost(content: content).releaseUIView()
        }
    }

    #if os(iOS)
    func isPaged(_ flag: Bool) -> Self {
        self.onNotRendered {
            ($0 as? View)?.isPagingEnabled = flag
        }
    }
    #endif
}
