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

extension UICTableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = self.manager?.numberOfSections ?? 0
        self.sizeManager.sections(count: numberOfSections)
        return numberOfSections
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let manager = self.manager else {
            self.sizeManager.rows(count: .zero, in: section)
            return 0
        }

        let numberOfRows = manager.numberOfRows(in: manager.section(at: section))
        self.sizeManager.rows(count: numberOfRows, in: section)
        return numberOfRows
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = self.manager?.row(at: indexPath) else {
            Fatal.Builder("UICList can't load row for indexPath at \(indexPath)").die()
        }

        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: row.identifier,
                for: indexPath
            ) as? TableViewCell
        else {
            Fatal.Builder("UICList can't dequeue cell for indexPath at \(indexPath)").die()
        }

        cell.prepareCell(row, axis: .horizontal)
        self.commitCell(cell)

        self.appendReusable(cell: cell)
        return cell
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let reusableView = tableView.reusableView(at: indexPath) else {
            return false
        }

        return !(reusableView.cellLoaded.trailingActions + reusableView.cellLoaded.leadingActions).isEmpty
    }
}
