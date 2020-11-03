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

@frozen
public struct UICTabItem {

    let title: String?
    let image: UIImage?
    let selectedImage: UIImage?
    let tabSystem: UITabBarItem.SystemItem?
    let tag: Int
    let content: ViewCreator

    private let collection: [UICTabItem]?

    internal var zip: [UICTabItem] {
        if let collection = self.collection {
            return collection
        }

        return [self]
    }

    init(_ collection: [UICTabItem]) {
        self.collection = collection
        self.title = nil
        self.content = UICEmptyView()
        self.image = nil
        self.selectedImage = nil
        self.tabSystem = nil
        self.tag = 0
    }

    public init(content: () -> ViewCreator) {
        self.title = nil
        self.content = content()
        self.image = nil
        self.selectedImage = nil
        self.tabSystem = nil
        self.tag = 0
        self.collection = nil
    }

    public init(_ title: String, content: () -> ViewCreator) {
        self.title = title
        self.content = content()
        self.image = nil
        self.selectedImage = nil
        self.tabSystem = nil
        self.tag = 0
        self.collection = nil
    }

    public init(_ image: UICImage, content: () -> ViewCreator) {
        self.title = nil
        self.content = content()
        self.image = image.uiImage
        self.selectedImage = nil
        self.tabSystem = nil
        self.tag = 0
        self.collection = nil
    }

    private init(_ original: UICTabItem, editable: Editable) {
        self.title = editable.title
        self.image = editable.image
        self.selectedImage = editable.selectedImage
        self.tabSystem = editable.tabSystem
        self.tag = editable.tag
        self.content = original.content
        self.collection = nil
    }

    var tabItem: UITabBarItem {
        if let tabSystem = self.tabSystem {
            let tabItem = UITabBarItem(tabBarSystemItem: tabSystem, tag: self.tag)
            tabItem.selectedImage = self.selectedImage
            tabItem.title = self.title
            tabItem.image = self.image
            return tabItem
        }

        let tabItem = UITabBarItem()
        tabItem.title = self.title
        tabItem.image = self.image
        tabItem.tag = self.tag
        tabItem.selectedImage = self.selectedImage
        return tabItem
    }
}

public extension UICTabItem {

    @inlinable
    func title(_ title: String?) -> Self {
        self.edit {
            $0.title = title
        }
    }

    @inlinable
    func image(_ image: UICImage?) -> Self {
        self.edit {
            $0.image = image?.uiImage
        }
    }

    @inlinable
    func tag(_ tag: Int) -> Self {
        self.edit {
            $0.tag = tag
        }
    }

    @inlinable
    func selectedImage(_ image: UICImage) -> Self {
        self.edit {
            $0.selectedImage = image.uiImage
        }
    }

    @inlinable
    func systemItem(_ systemItem: UITabBarItem.SystemItem) -> Self {
        self.edit {
            $0.tabSystem = systemItem
        }
    }
}

extension UICTabItem {

    @usableFromInline
    struct Editable {

        @MutableBox @usableFromInline
        var title: String?

        @MutableBox @usableFromInline
        var image: UIImage?

        @MutableBox @usableFromInline
        var selectedImage: UIImage?

        @MutableBox @usableFromInline
        var tabSystem: UITabBarItem.SystemItem?

        @MutableBox @usableFromInline
        var tag: Int

        @usableFromInline
        init(_ tabItem: UICTabItem) {
            self._title = .init(wrappedValue: tabItem.title)
            self._image = .init(wrappedValue: tabItem.image)
            self._selectedImage = .init(wrappedValue: tabItem.selectedImage)
            self._tabSystem = .init(wrappedValue: tabItem.tabSystem)
            self._tag = .init(wrappedValue: tabItem.tag)
        }
    }

    @inline(__always) @usableFromInline
    func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}
