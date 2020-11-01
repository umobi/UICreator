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
public struct UICMenu: UICMenuElement {
    //swiftlint:disable identifier_name
    let id: ObjectIdentifier?
    let children: [UICMenuElement]
    let title: String?
    let image: UIImage?
    let options: Set<Options>
    let provider: (() -> ViewCreator)?

    @frozen
    public enum Options {
        case inline
        case destructive
    }

    public init(title: String, options: Set<Options> = []) {
        self.id = nil
        self.title = title
        self.image = nil
        self.options = options
        self.children = []
        self.provider = nil
    }

    public init(image: UICImage, options: Set<Options> = []) {
        self.id = nil
        self.image = image.uiImage
        self.title = nil
        self.options = options
        self.children = []
        self.provider = nil
    }

    public init(image: UICImage, title: String, options: Set<Options> = []) {
        self.id = nil
        self.title = title
        self.image = image.uiImage
        self.options = options
        self.children = []
        self.provider = nil
    }

    fileprivate init(_ original: UICMenu, editable: Editable) {
        self.id = editable.id
        self.title = editable.title
        self.image = editable.image
        self.options = editable.options
        self.children = editable.children
        self.provider = editable.provider
    }
}

extension UICMenu {
    @usableFromInline
    struct Editable {
        //swiftlint:disable identifier_name
        @MutableBox @usableFromInline
        var id: ObjectIdentifier?

        @MutableBox @usableFromInline
        var children: [UICMenuElement]

        @MutableBox @usableFromInline
        var title: String?

        @MutableBox @usableFromInline
        var image: UIImage?

        @MutableBox @usableFromInline
        var options: Set<Options>

        @MutableBox @usableFromInline
        var provider: (() -> ViewCreator)?

        @usableFromInline
        init(_ original: UICMenu) {
            self._id = .init(wrappedValue: original.id)
            self._children = .init(wrappedValue: original.children)
            self._title = .init(wrappedValue: original.title)
            self._image = .init(wrappedValue: original.image)
            self._options = .init(wrappedValue: original.options)
            self._provider = .init(wrappedValue: original.provider)
        }
    }

    @usableFromInline
    func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

extension UICMenu {
    //swiftlint:disable identifier_name
    func id(_ id: ObjectIdentifier) -> Self {
        self.edit {
            $0.id = id
        }
    }
}

public extension UICMenu {
    @inlinable
    func title(_ title: String) -> Self {
        self.edit {
            $0.title = title
        }
    }

    @inlinable
    func image(_ image: UICImage) -> Self {
        self.edit {
            $0.image = image.uiImage
        }
    }

    @inlinable
    func provider(_ content: @escaping () -> ViewCreator) -> Self {
        self.edit {
            $0.provider = content
        }
    }
}

public extension UICMenu {
    @inlinable
    func children(@UICMenuBuilder _ contents: @escaping () -> UICMenuElement) -> Self {
        self.edit {
            $0.children = contents().zip
        }
    }
}

public extension UICMenu {

    @inlinable
    func options(_ options: Options...) -> Self {
        self.edit {
            $0.options = .init(options)
        }
    }

    @inlinable
    func options(_ options: Set<Options>) -> Self {
        self.edit {
            $0.options = options
        }
    }
}

extension UICMenu.Options {
    @available(iOS 13, tvOS 13, *)
    var uiOptions: UIMenu.Options {
        switch self {
        case .destructive:
            return .destructive
        case .inline:
            return .displayInline
        }
    }
}

#if os(iOS)
public extension UIViewCreator {
    @inlinable @available(iOS 13, *)
    func contextMenu(_ content: @escaping () -> UICMenu) -> UICInTheSceneModifier<View> {
        self.onInTheScene {
            $0.addInteraction(UIContextMenuInteraction.interaction(
                UICMenu.Delegate(content())
            ))
        }
    }
}
#endif

#if os(iOS)
extension UICMenu {
    @available(iOS 13, *)
    var uiMenu: UIMenu {
        .init(
            title: self.title ?? "",
            image: self.image,
            identifier: {
                guard let id = self.id else {
                    return nil
                }

                return .init(rawValue: "\(id)")
            }(),
            options: .init(self.options.map { $0.uiOptions }),
            children: self.children.map { $0.uiMenuElement }
        )
    }
}
#endif
