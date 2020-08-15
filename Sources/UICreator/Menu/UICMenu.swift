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

public struct UICMenu: UICMenuElement {
    let id: ObjectIdentifier?
    let children: [UICMenuElement]
    let title: String?
    let image: UIImage?
    let options: Set<Options>
    let provider: (() -> ViewCreator)?

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

    public init(image: UIImage, options: Set<Options> = []) {
        self.id = nil
        self.image = image
        self.title = nil
        self.options = options
        self.children = []
        self.provider = nil
    }

    public init(image: UIImage, title: String, options: Set<Options> = []) {
        self.id = nil
        self.title = title
        self.image = image
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

private extension UICMenu {
    class Editable {
        var id: ObjectIdentifier?
        var children: [UICMenuElement]
        var title: String?
        var image: UIImage?
        var options: Set<Options>
        var provider: (() -> ViewCreator)?

        init(_ original: UICMenu) {
            self.id = original.id
            self.children = original.children
            self.title = original.title
            self.image = original.image
            self.options = original.options
            self.provider = original.provider
        }
    }

    func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

extension UICMenu {
    func id(_ id: ObjectIdentifier) -> Self {
        self.edit {
            $0.id = id
        }
    }
}

public extension UICMenu {
    func title(_ title: String) -> Self {
        self.edit {
            $0.title = title
        }
    }

    func image(_ image: UIImage) -> Self {
        self.edit {
            $0.image = image
        }
    }

    func provider(_ content: @escaping () -> ViewCreator) -> Self {
        self.edit {
            $0.provider = content
        }
    }
}

public extension UICMenu {
    func children(@UICMenuBuilder _ contents: @escaping () -> UICMenuElement) -> Self {
        self.edit {
            $0.children = contents().zip
        }
    }
}

public extension UICMenu {

    func options(_ options: Options...) -> Self {
        self.edit {
            $0.options = .init(options)
        }
    }

    func options(_ options: Set<Options>) -> Self {
        self.edit {
            $0.options = options
        }
    }
}

extension UICMenu.Options {
    @available(iOS 13, *)
    var uiOptions: UIMenu.Options {
        switch self {
        case .destructive:
            return .destructive
        case .inline:
            return .displayInline
        }
    }
}

public extension ViewCreator {

    @available(iOS 13, *)
    func menu(_ content: @escaping () -> UICMenu) -> Self {
        self.onInTheScene {
            $0.addInteraction(UIContextMenuInteraction.interaction(
                UICMenu.Delegate(content())
            ))
        }
    }
}

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
