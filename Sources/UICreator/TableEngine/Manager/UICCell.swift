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

struct UICCell {
    let rowManager: ListManager.RowManager
    let identifier: String

    init(_ identifier: String, _ manager: ListManager.RowManager) {
        self.rowManager = manager
        self.identifier = identifier
    }
}

extension UICCell {
    struct Loaded {
        let cell: UICCell
        let trailingActions: [RowAction]
        let leadingActions: [RowAction]

        fileprivate init(_ cell: UICCell) {
            self.cell = cell
            self.trailingActions = cell.rowManager.payload.trailingActions?().zip ?? []
            self.leadingActions = cell.rowManager.payload.leadingActions?().zip ?? []
        }
    }

    var load: Loaded {
        return .init(self)
    }
}
