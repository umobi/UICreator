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

extension ListSupport where Self: UITableView {
    @discardableResult
    func dynamicData(@UICViewBuilder _ contents: () -> ViewCreator) -> Self {
        let contents = contents().zip

        return self.onInTheScene { view in
            OperationQueue.main.addOperation {
                let modifier = ListState(self, contents)
                let tableView: Self! = view as? Self

                tableView.register(
                    modifier.rows,
                    modifier.headers,
                    modifier.footers
                )

                tableView.modifier = modifier
                tableView.strongDelegate(UICTableViewDelegate())
                tableView.strongDataSource(UICTableViewDataSource())
            }
        }
    }
}

extension ListSupport where Self: UITableView {
    @usableFromInline
    func register(
        _ rows: [List.Identifier<String, Row>],
        _ headers: [List.Identifier<String, Row>],
        _ footers: [List.Identifier<String, Row>]) {

        rows.forEach {
            self.register(Views.TableViewCell.self, forCellReuseIdentifier: $0.id)
        }

        headers.forEach {
            self.register(Views.TableViewHeaderFooterCell.self, forHeaderFooterViewReuseIdentifier: $0.id)
        }

        footers.forEach {
            self.register(Views.TableViewHeaderFooterCell.self, forHeaderFooterViewReuseIdentifier: $0.id)
        }
    }
}

private var kTableDelegate = 0
private var kTableDataSource = 0
extension UITableView {

    @inline(__always)
    func strongDelegate(_ delegate: UITableViewDelegate) {
        self.delegate = delegate
        objc_setAssociatedObject(self, &kTableDelegate, delegate, .OBJC_ASSOCIATION_RETAIN)
    }

    @inline(__always)
    func strongDataSource(_ dataSource: UITableViewDataSource) {
        self.dataSource = dataSource
        objc_setAssociatedObject(self, &kTableDataSource, dataSource, .OBJC_ASSOCIATION_RETAIN)
    }
}
