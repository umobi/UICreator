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

public protocol UICView: ViewCreator {
    func viewDidLoad()
    var body: ViewCreator { get }
}

public extension UICView {
    func viewDidLoad() {}
}

private var kTemplateViewDidConfiguredView: UInt = 0
private var kViewDidLoad: UInt = 0

private extension UICView {
    var didViewLoadMutable: Mutable<Bool> {
        OBJCSet(self, &kViewDidLoad) {
            .init(value: false)
        }
    }

    var didConfiguredViewMutable: Mutable<Bool> {
        OBJCSet(self, &kTemplateViewDidConfiguredView) {
            .init(value: false)
        }
    }
}

extension UICView {
    private var didConfiguredView: Bool {
        get { self.didConfiguredViewMutable.value }
        set { self.didConfiguredViewMutable.value = newValue }
    }

    private(set) var didViewLoad: Bool {
        get { self.didViewLoadMutable.value }
        set { self.didViewLoadMutable.value = newValue }
    }

    func makeView() -> UIView {
        guard !self.didConfiguredView else {
            fatalError()
        }

        self.didConfiguredView = true
        let view = RootView(builder: self)
        let body = self.body
        self.tree.append(body)

        self.onNotRendered {
            $0.add(priority: .required, body.releaseUIView())
        }.onNotRendered { [weak self] _ in
            guard let self = self else {
                fatalError()
            }

            if !self.didViewLoad {
                self.didViewLoad = true
                self.viewDidLoad()
            }
        }

        return view
    }
}
