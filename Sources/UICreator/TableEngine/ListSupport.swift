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

@usableFromInline
protocol ListSupport: class {
    func reloadData()
    var modifier: ListModifier? { get set }

    func register(
        _ rows: [List.Identifier<String, Row>],
        _ headers: [List.Identifier<String, Row>],
        _ footers: [List.Identifier<String, Row>]
    )
}

extension ListSupport {
    @usableFromInline
    func setNeedsReloadData() {
        guard modifier == nil || !(modifier is ListState.Append) else {
            return
        }

        self.reloadData()
    }
}

extension ListSupport {
    func invalidateState(_ newState: List) {
        let footers = self.modifier?.footers ?? []
        let headers = self.modifier?.headers ?? []
        let rows = self.modifier?.rows ?? []

        self.modifier = self.modifier?.update(newState)

        self.register({
            self.modifier?.rows.filter { row in
                !rows.contains(where: { $0.id == row.id })
            } ?? []
        }(), {
            self.modifier?.headers.filter { header in
                !headers.contains(where: { $0.id == header.id })
            } ?? []
        }(), {
            self.modifier?.footers.filter { footer in
                !footers.contains(where: { $0.id == footer.id })
            } ?? []
        }())
        
        self.setNeedsReloadData()
    }
}
