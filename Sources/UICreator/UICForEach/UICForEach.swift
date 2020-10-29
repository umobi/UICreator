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

@frozen
public struct UICForEach<Content, Value>: ViewCreator, ForEachEnviromentShared where Content: ViewCreator, Value: Collection {
    private let privateEnviroment: Enviroment

    @usableFromInline
    var enviroment: ForEachEnviromentType {
        self.privateEnviroment
    }

    public init(_ dynamicValue: Relay<Value>, content: @escaping (Value.Element) -> Content) {
        self.privateEnviroment = .init(dynamicValue, content: content)
    }

    public init(_ value: Value, content: @escaping (Value.Element) -> Content) {
        self.privateEnviroment = .init(.constant(value), content: content)
    }

    @inline(__always)
    public static func _makeUIView(_ viewCreator: ViewCreator) -> CBView {
        UICEmptyView()
            .height(equalTo: 0, priority: .defaultHigh)
            .width(equalTo: 0, priority: .defaultHigh)
            .onNotRendered {
                (viewCreator as! Self).privateEnviroment.ref($0)
            }
            .onRendered { _ in
                (viewCreator as! Self).privateEnviroment.syncManager()
            }
            .releaseUIView()
    }
}

extension UICForEach {
    @usableFromInline
    class Enviroment: ForEachEnviromentType {
        @UICOutlet var view: CBView!
        @Relay private var dynamicContent: [() -> ViewCreator]

        private weak var manager: SupportForEach!

        @usableFromInline
        let contentType: ViewCreator.Type

        @usableFromInline
        private(set) var isReleased: Bool = false

        init(_ dynamicValue: Relay<Value>, content: @escaping (Value.Element) -> Content) {
            self.contentType = Content.self
            self._dynamicContent = dynamicValue.map {
                $0.map { element in
                    {
                        content(element)
                    }
                }
            }
        }

        @usableFromInline
        func syncManager() {
            guard !self.isReleased, let manager = self.manager else {
                return
            }

            self.isReleased = true
            manager.viewsDidChange(self.view, self.$dynamicContent)
        }

        @usableFromInline
        func setManager(_ manager: SupportForEach) {
            self.manager = manager

            guard !self.isReleased else {
                return
            }
        }

        fileprivate func ref(_ view: UIView) {
            self._view.ref(view)
        }
    }
}
