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

extension UICTableView: ListSupport {}

public extension UICList {
    convenience init(style: UITableView.Style, _ contents: @escaping () -> [ViewCreator]) {
        self.init(style: style, ListManager(contents: contents()))
    }

    private convenience init(style: UITableView.Style, _ manager: ListManager) {
        self.init(style: style)

        self.onNotRendered { [manager] in
            let tableView: View! = $0 as? View
            #if os(iOS)
            tableView.separatorStyle = .none
            #endif

            manager.rowsIdentifier.forEach { [unowned tableView] in
                tableView?.register(TableViewCell.self, forCellReuseIdentifier: $0)
            }

            manager.headersIdentifier.forEach { [unowned tableView] in
                tableView?.register(TableViewHeaderFooterCell.self, forHeaderFooterViewReuseIdentifier: $0)
            }

            manager.footersIdentifier.forEach { [unowned tableView] in
                tableView?.register(TableViewHeaderFooterCell.self, forHeaderFooterViewReuseIdentifier: $0)
            }

            tableView.manager = manager
            tableView.dataSource = tableView
            tableView.delegate = tableView
            manager.list = tableView

        }
    }
}
