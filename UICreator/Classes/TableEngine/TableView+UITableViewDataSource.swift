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

extension TableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        let estimatedSections = self.group?.numberOfSections ?? 0
        return creatorDataSource?.numberOfSections(estimatedSections) ?? estimatedSections
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let group = self.group else {
            return 0
        }

        let numberOfRows = group.numberOfRows(in: group.section(at: section))
        if let creatorDataSource = self.creatorDataSource {
            return creatorDataSource.numberOfRows(in: section, estimatedRows: numberOfRows)
        }

        return numberOfRows
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = self.group?.row(at: indexPath) else {
            fatalError()
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: row.0, for: indexPath) as? TableViewCell else {
            fatalError()
        }

        cell.prepareCell(builder: row.1)
        self.creatorDataSource?.cell(at: indexPath, content: cell.builder)

        self.commitCell(cell)
        return cell
    }
}
