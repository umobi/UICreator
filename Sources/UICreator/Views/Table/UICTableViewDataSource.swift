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

class UICTableViewDataSource: NSObject, UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = tableView.modifier?.numberOfSections ?? 0
        tableView.sizeManager.sections(count: numberOfSections)
        return numberOfSections
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let modifier = tableView.modifier else {
            tableView.sizeManager.rows(count: .zero, in: section)
            return 0
        }

        let numberOfRows = modifier.numberOfRows(in: section)
        tableView.sizeManager.rows(count: numberOfRows, in: section)
        return numberOfRows
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = tableView.modifier?.row(at: indexPath) else {
            Fatal.Builder("UICList can't load row for indexPath at \(indexPath)").die()
        }

        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: row.id,
                for: indexPath
            ) as? Views.TableViewCell
        else {
            Fatal.Builder("UICList can't dequeue cell for indexPath at \(indexPath)").die()
        }

        cell.prepare(row.content, axis: .horizontal)
        tableView.commitCell(cell)

        tableView.append(cell)
        return cell
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let reusableView = tableView.reusableView(at: indexPath) else {
            return false
        }

        guard case .row(let trailingActions, let leadingActions, _, _) = reusableView.row.type else {
            return false
        }

        return !(trailingActions + leadingActions).isEmpty
    }
}