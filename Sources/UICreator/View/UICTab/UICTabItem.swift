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

public struct UICTabItem {

    let title: String?
    let image: UIImage?
    let selectedImage: UIImage?
    let tabSystem: UITabBarItem.SystemItem?
    let tag: Int
    let content: () -> ViewCreator

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
        self.content = {
            fatalError()
        }
        self.image = nil
        self.selectedImage = nil
        self.tabSystem = nil
        self.tag = 0
    }

    public init(content: @escaping () -> ViewCreator) {
        self.title = nil
        self.content = content
        self.image = nil
        self.selectedImage = nil
        self.tabSystem = nil
        self.tag = 0
        self.collection = nil
    }

    public init(title: String, content: @escaping () -> ViewCreator) {
        self.title = title
        self.content = content
        self.image = nil
        self.selectedImage = nil
        self.tabSystem = nil
        self.tag = 0
        self.collection = nil
    }

    public init(image: UIImage, content: @escaping () -> ViewCreator) {
        self.title = nil
        self.content = content
        self.image = image
        self.selectedImage = nil
        self.tabSystem = nil
        self.tag = 0
        self.collection = nil
    }

    public func title(_ title: String?) -> Self {
        self.edit {
            $0.title = title
        }
    }

    public func image(_ image: UIImage?) -> Self {
        self.edit {
            $0.image = image
        }
    }

    public func tag(_ tag: Int) -> Self {
        self.edit {
            $0.tag = tag
        }
    }

    public func selectedImage(_ image: UIImage) -> Self {
        self.edit {
            $0.selectedImage = image
        }
    }

    public func systemItem(_ systemItem: UITabBarItem.SystemItem) -> Self {
        self.edit {
            $0.tabSystem = systemItem
        }
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

    private func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    private class Editable {
        var title: String?
        var image: UIImage?
        var selectedImage: UIImage?
        var tabSystem: UITabBarItem.SystemItem?
        var tag: Int

        init(_ tabItem: UICTabItem) {
            self.title = tabItem.title
            self.image = tabItem.image
            self.selectedImage = tabItem.selectedImage
            self.tabSystem = tabItem.tabSystem
            self.tag = tabItem.tag
        }
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
