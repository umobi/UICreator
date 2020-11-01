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
struct Row {
    let content: ViewCreator
    let type: ContentType

    init(_ header: UICHeader, _ index: Int) {
        self.content = header.content()
        self.type = .header(index)
    }

    init(_ footer: UICFooter, _ index: Int) {
        self.content = footer.content()
        self.type = .footer(index)
    }

    init(_ row: UICRow, _ indexPath: IndexPath) {
        self.content = row.content()
        self.type = .row(
            trailingActions: row.trailingActions?().zip ?? [],
            leadingActions: row.leadingActions?().zip ?? [],
            accessoryType: row.accessoryType,
            indexPath: indexPath
        )
    }
}

extension Row {
    @usableFromInline
    enum ContentType {
        case header(Int)
        case footer(Int)

        case row(
                trailingActions: [RowAction],
                leadingActions: [RowAction],
                accessoryType: UITableViewCell.AccessoryType,
                indexPath: IndexPath
             )
    }
}
