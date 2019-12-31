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

extension TableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = self.group?.header(at: section) else {
            return nil
        }

        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: header.0) as? TableViewHeaderFooterCell else {
            fatalError()
        }

        cell.prepareCell(builder: header.1)
        self.creatorDelegate?.header(at: section, content: cell.builder)
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = self.group?.footer(at: section) else {
            return nil
        }

        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: footer.0) as? TableViewHeaderFooterCell else {
            fatalError()
        }

        cell.prepareCell(builder: footer.1)
        self.creatorDelegate?.footer(at: section, content: cell.builder)
        return cell
    }
}

extension TableView {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard self.group?.header(at: section) != nil else {
            return .zero
        }

        return self.creatorDelegate?.tableView(tableView, heightForHeaderAt: section) ?? tableView.sectionHeaderHeight
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard self.group?.footer(at: section) != nil else {
            return .zero
        }

        return self.creatorDelegate?.tableView(tableView, heightForHeaderAt: section) ?? tableView.sectionFooterHeight
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard self.group?.row(at: indexPath) != nil else {
            return .zero
        }

        return self.creatorDelegate?.tableView(tableView, heightForRowAt: indexPath) ?? tableView.rowHeight
    }
}

extension TableView {
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard self.group?.header(at: section) != nil else {
            return .zero
        }

        return self.creatorDelegate?.tableView(tableView, estimatedHeightForHeaderAt: section) ?? 1
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        guard self.group?.footer(at: section) != nil else {
            return .zero
        }

        return self.creatorDelegate?.tableView(tableView, estimatedHeightForHeaderAt: section) ?? 1
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard self.group?.row(at: indexPath) != nil else {
            return .zero
        }

        return self.creatorDelegate?.tableView(tableView, estimatedHeightForRowAt: indexPath) ?? tableView.estimatedRowHeight
    }
}
