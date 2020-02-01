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

protocol ListContentDelegate: class {
    func content(_ compactCopy: ListManager.RowManager.Copy, updatedWith sequence: [ListManager.RowManager])
}

protocol ListContentSectionRestore: class {
    func section(at index: Int) -> ListManager.SectionManager
}

extension ListManager {
    final class RowManager {
        let payload: Payload
        let identifier: Int
        let indexPath: IndexPath
        let isDynamic: Bool
        private(set) weak var listManager: (ListManager & ListContentSectionRestore)!
        private(set) weak var forEach: ForEachCreator?

        fileprivate init(_ payload: Payload) {
            self.payload = payload
            self.isDynamic = false
            self.indexPath = .init(row: .zero, section: .zero)
            self.identifier = 0
            self.listManager = nil
            self.forEach = nil
        }

        private init(_ original: RowManager, editable: Editable) {
            self.payload = original.payload
            self.identifier = editable.identifier
            self.indexPath = editable.indexPath
            self.isDynamic = editable.isDynamic
            self.listManager = original.listManager ?? editable.listManager
            self.forEach = original.forEach
            self.forEach?.manager = self
        }

        func identifier(_ id: Int) -> RowManager {
            self.edit {
                $0.identifier = id
            }
        }

        func isDynamic(_ flag: Bool) -> RowManager {
            self.edit {
                $0.isDynamic = flag
            }
        }

        func indexPath(_ indexPath: IndexPath) -> RowManager {
            self.edit {
                $0.indexPath = indexPath
            }
        }

        func listManager(_ listManager: ListManager & ListContentSectionRestore) -> RowManager {
            self.edit {
                $0.listManager = listManager
            }
        }

        @discardableResult
        func loadForEachIfNeeded() -> Bool {
            guard let forEach = self.forEach, !forEach.isLoaded else {
                return false
            }

            forEach.load()
            return forEach.isLoaded
        }

        static func forEach(_ forEachCreator: ForEachCreator) -> RowManager {
            let manager = Payload(row: UICRow {
                forEachCreator
            }).asRowManager

            forEachCreator.manager = manager
            manager.forEach = forEachCreator
            return manager
        }

        private func forEach(_ forEachCreator: ForEachCreator?) -> RowManager {
            self.forEach = forEachCreator
            forEachCreator?.manager = self
            return self
        }
    }
}

extension ListManager.RowManager {
    struct Payload {
        let content: () -> ViewCreator
        let trailingActions: (() -> [RowAction])?
        let leadingActions: (() -> [RowAction])?

        init(header: UICHeader) {
            self.content = header.content
            self.trailingActions = nil
            self.leadingActions = nil
        }

        init(footer: UICFooter) {
            self.content = footer.content
            self.trailingActions = nil
            self.leadingActions = nil
        }

        init(row: UICRow) {
            self.content = row.content
            self.trailingActions = row.trailingActions
            self.leadingActions = row.leadingActions
        }

        var asRowManager: ListManager.RowManager {
            return .init(self)
        }
    }
}

private extension ListManager.RowManager {
    class Editable {
        var identifier: Int
        var isDynamic: Bool
        var indexPath: IndexPath
        weak var listManager: (ListManager & ListContentSectionRestore)!

        fileprivate init(_ content: ListManager.RowManager) {
            self.identifier = content.identifier
            self.isDynamic = content.isDynamic
            self.indexPath = content.indexPath
            self.listManager = content.listManager
        }
    }

    func edit(_ handler: (Editable) -> Void) -> ListManager.RowManager {
        let editable = Editable(self)
        handler(editable)
        return .init(self, editable: editable)
    }
}

extension ListManager.RowManager {
    struct Copy {
        let identifier: Int
        let isDynamic: Bool
        let indexPath: IndexPath
        weak var listManager: (ListManager & ListContentSectionRestore)!
        private weak var forEach: ForEachCreator?

        fileprivate init(_ content: ListManager.RowManager) {
            self.identifier = content.identifier
            self.isDynamic = content.isDynamic
            self.listManager = content.listManager
            self.indexPath = content.indexPath
            self.forEach = content.forEach
        }

        fileprivate func restore(_ payload: Payload) -> ListManager.RowManager {
            ListManager.RowManager(payload)
                .identifier(self.identifier)
                .isDynamic(self.isDynamic)
                .listManager(self.listManager)
                .indexPath(self.indexPath)
                .forEach(self.forEach)
        }
    }

    var compactCopy: Copy {
        return Copy(self)
    }
}

extension ListManager.RowManager: SupportForEach {
    func viewsDidChange(placeholderView: UIView!, _ sequence: Relay<[() -> ViewCreator]>) {
        sequence.next { [compactCopy] in
            compactCopy.listManager
                .section(at: compactCopy.indexPath.section)
                .content(compactCopy, updatedWith: $0.map { content in
                    compactCopy.restore(.init(row: content() as! UICRow))
                })
        }
    }
}
