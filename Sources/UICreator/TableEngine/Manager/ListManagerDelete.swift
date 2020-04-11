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

extension ListManager {
    class Delete: ListCollectionManager {
        private let manager: ListManager

        var sections: [ListManager.SectionManager] {
            return self.manager.sections
        }

        private var disableIndexPath: [IndexPath] = []
        private var disableSections: [Int] = []

        init(_ manager: ListManager) {
            self.manager = manager
        }

        func disableIndexPath(_ indexPath: IndexPath) -> Self {
            self.disableIndexPath.append(indexPath)
            return self
        }

        func disableIndexPaths(_ indexPaths: [IndexPath]) -> Self {
            self.disableIndexPath = indexPaths
            return self
        }

        func disableSections(_ sections: [Int]) -> Self {
            self.disableSections = sections
            return self
        }

        func numberOfRows(in section: ListManager.SectionManager) -> Int {
            let numberOfRows = self.manager.numberOfRows(in: section)

            guard self.disableIndexPath.contains(where: {
                $0.section == section.index
            }) else { return numberOfRows }

            return numberOfRows - self.disableIndexPath.reduce(0) { $0 + ($1.section == section.index ? 1 : 0 )}
        }

        var numberOfSections: Int {
            return self.manager.numberOfSections - IndexSet(self.disableSections).count
        }
    }
}

