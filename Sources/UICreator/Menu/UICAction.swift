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

public struct UICAction: UICMenuElement {
    let title: String?
    let image: UIImage?
    //swiftlint:disable identifier_name
    let id: ObjectIdentifier?
    let attributes: Set<Attributes>
    let state: State
    let tapHandler: () -> Void

    public enum Attributes {
        case hidden
        case destructive
        case disabled
    }

    public enum State {
        case on
        case off
        case mixed
    }

    public init(title: String, onTap: @escaping () -> Void) {
        self.title = title
        self.image = nil
        self.id = nil
        self.attributes = []
        self.state = .on
        self.tapHandler = onTap
    }

    public init(image: UICImage, onTap: @escaping () -> Void) {
        self.title = nil
        self.image = image.uiImage
        self.id = nil
        self.attributes = []
        self.state = .on
        self.tapHandler = onTap
    }

    public init(image: UICImage, title: String, onTap: @escaping () -> Void) {
        self.title = title
        self.image = image.uiImage
        self.id = nil
        self.attributes = []
        self.state = .on
        self.tapHandler = onTap
    }

    fileprivate init(_ original: UICAction, editable: Editable) {
        self.title = editable.title
        self.image = editable.image
        self.id = editable.id
        self.attributes = editable.attributes
        self.state = editable.state
        self.tapHandler = original.tapHandler
    }
}

private extension UICAction {
    class Editable {
        var title: String?
        var image: UIImage?
        var id: ObjectIdentifier?
        var attributes: Set<Attributes>
        var state: State

        init(_ original: UICAction) {
            self.title = original.title
            self.image = original.image
            self.id = original.id
            self.attributes = original.attributes
            self.state = original.state
        }
    }

    func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

extension UICAction {
    //swiftlint:disable identifier_name
    func id(_ id: ObjectIdentifier) -> Self {
        self.edit {
            $0.id = id
        }
    }
}

public extension UICAction {
    func title(_ title: String) -> Self {
        self.edit {
            $0.title = title
        }
    }

    func image(_ image: UICImage) -> Self {
        self.edit {
            $0.image = image.uiImage
        }
    }

    func state(_ state: State) -> Self {
        self.edit {
            $0.state = state
        }
    }
}

public extension UICAction {
    func attributes(_ attributes: Set<Attributes>) -> Self {
        self.edit {
            $0.attributes = attributes
        }
    }

    func attributes(_ attributes: Attributes...) -> Self {
        self.edit {
            $0.attributes = .init(attributes)
        }
    }
}

extension UICAction.Attributes {
    @available(iOS 13, tvOS 13, *)
    var uiAttributes: UIAction.Attributes {
        switch self {
        case .destructive:
            return .destructive
        case .disabled:
            return .disabled
        case .hidden:
            return .hidden
        }
    }
}

extension UICAction.State {
    @available(iOS 13, tvOS 13, *)
    var uiState: UIAction.State {
        switch self {
        case .on:
            return .on
        case .off:
            return .off
        case .mixed:
            return .mixed
        }
    }
}

#if os(iOS)
extension UICAction {
    @available(iOS 13, *)
    var uiAction: UIAction {
        .init(
            title: self.title ?? "",
            image: self.image,
            identifier: {
                //swiftlint:disable identifier_name
                guard let id = self.id else {
                    return nil
                }

                return .init("\(id)")
            }(),
            discoverabilityTitle: nil,
            attributes: .init(self.attributes.map { $0.uiAttributes }),
            state: self.state.uiState,
            handler: { _ in
                self.tapHandler()
            }
        )
    }
}
#endif
