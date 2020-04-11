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

protocol ListSectionDelegate {
    func content(_ section: ListManager.SectionManager.Copy, updateSections: [ListManager.SectionManager])
    func content(updateSection: ListManager.SectionManager)
}

extension ListManager {
    final class SectionManager {
        let rows: [RowManager]
        let header: RowManager?
        let footer: RowManager?

        let identifier: Int
        let index: Int
        let isDynamic: Bool

        private(set) weak var listManager: (ListManager & ListSectionDelegate)!
        private(set) weak var forEach: ForEachCreator?

        init(_ listManager: ListManager & ListSectionDelegate) {
            self.rows = []
            self.header = nil
            self.footer = nil
            self.identifier = 0
            self.index = 0
            self.isDynamic = false
            self.listManager = listManager
            self.forEach = nil
        }

        private init(_ original: SectionManager, editable: Editable) {
            self.rows = editable.rows.enumerated().map {
                $0.element.indexPath(.init(row: $0.offset, section: editable.index))
            }
            self.header = editable.header?.indexPath(.init(row: 0, section: editable.index))
            self.footer = editable.footer?.indexPath(.init(row: 0, section: editable.index))
            self.identifier = editable.identifier
            self.index = editable.index
            self.isDynamic = editable.isDynamic
            self.listManager = editable.listManager
            self.forEach = original.forEach
            self.forEach?.manager = self
        }

        func rows(_ rows: [RowManager]) -> SectionManager {
            self.edit {
                $0.rows = rows.enumerated().map {
                    $0.element
                        .indexPath(.init(row: $0.offset, section: self.identifier))
                        .listManager(self.listManager)
                }
            }
        }

        func header(_ header: RowManager?) -> SectionManager {
            self.edit {
                $0.header = header?
                    .indexPath(.init(row: 0, section: self.index))
                    .listManager(self.listManager)
            }
        }

        func footer(_ footer: RowManager?) -> SectionManager {
            self.edit {
                $0.footer = footer?
                    .indexPath(.init(row: 0, section: self.index))
                    .listManager(self.listManager)
            }
        }

        func identifier(_ id: Int) -> SectionManager {
            self.edit {
                $0.identifier = id
            }
        }

        func isDynamic(_ flag: Bool) -> SectionManager {
            self.edit {
                $0.isDynamic = flag
            }
        }

        func index(_ index: Int) -> SectionManager {
            self.edit {
                $0.index = index
            }
        }

        func listManager(_ listManager: ListManager & ListSectionDelegate) -> SectionManager {
            self.edit {
                $0.listManager = listManager
            }
        }

        func update(listManager: ListManager & ListSectionDelegate) {
            self.listManager = listManager
        }

        func forEach(_ forEachCreator: ForEachCreator) -> SectionManager {
            let manager = self.rows([RowManager.Payload(row: UICRow {
                forEachCreator
            }).asRowManager])

            forEachCreator.manager = manager
            manager.forEach = forEachCreator
            return manager
        }

        @discardableResult
        func loadForEachIfNeeded() -> Bool {
            guard let forEach = self.forEach, !forEach.isLoaded else {
                return self.rows.reduce(false) {
                    $0 || $1.loadForEachIfNeeded()
                }
            }

            forEach.load()
            return forEach.isLoaded
        }

        private func forEach(_ forEachCreator: ForEachCreator?) -> SectionManager {
            self.forEach = forEachCreator
            forEachCreator?.manager = self
            return self
        }
    }
}

private extension ListManager.SectionManager {
    class Editable {
        var rows: [ListManager.RowManager]
        var header: ListManager.RowManager?
        var footer: ListManager.RowManager?

        var identifier: Int
        var index: Int
        var isDynamic: Bool

        weak var listManager: (ListManager & ListSectionDelegate)!

        fileprivate init(_ manager: ListManager.SectionManager) {
            self.rows = manager.rows
            self.header = manager.header
            self.footer = manager.footer

            self.identifier = manager.identifier
            self.index = manager.index
            self.isDynamic = manager.isDynamic

            self.listManager = manager.listManager
        }
    }

    func edit(_ handler: (Editable) -> Void) -> ListManager.SectionManager {
        let editable = Editable(self)
        handler(editable)
        return ListManager.SectionManager(self, editable: editable)
    }
}

extension ListManager.SectionManager {
    struct Copy {
        let header: ListManager.RowManager?
        let footer: ListManager.RowManager?
        let identifier: Int
        let isDynamic: Bool
        let index: Int
        weak var listManager: (ListManager & ListSectionDelegate)!
        weak var forEach: ForEachCreator?

        fileprivate init(_ content: ListManager.SectionManager) {
            self.header = content.header
            self.footer = content.footer
            self.identifier = content.identifier
            self.isDynamic = content.isDynamic
            self.listManager = content.listManager
            self.index = content.index
            self.forEach = content.forEach
        }

        fileprivate func restore(rows: [ListManager.RowManager]) -> ListManager.SectionManager {
            ListManager.SectionManager(self.listManager)
                .rows(rows)
                .header(self.header)
                .footer(self.footer)
                .identifier(self.identifier)
                .isDynamic(self.isDynamic)
                .index(self.index)
                .forEach(self.forEach)
        }
    }

    var compactCopy: Copy {
        return .init(self)
    }
}

extension ListManager.SectionManager: ListContentDelegate {
    func content(_ compactCopy: ListManager.RowManager.Copy, updatedWith sequence: [ListManager.RowManager]) {
        var updateRows = sequence
        let rows = self.rows.reduce([ListManager.RowManager]()) { sum, next -> [ListManager.RowManager] in
            if next.identifier == compactCopy.identifier {
                let toAppend = updateRows
                updateRows = []
                return sum + toAppend
            }

            return sum + [next]
        } + updateRows

        self.listManager.content(updateSection: self.rows(rows))
    }
}

extension ListManager.SectionManager: SupportForEach {
    static func mount(_ manager: ListManager & ListSectionDelegate, with contents: [ViewCreator]) -> ListManager.SectionManager {
        var footer: ListManager.RowManager? = nil
        var header: ListManager.RowManager? = nil
        var rows: [ListManager.RowManager] = []
        var identifier = -1

        contents.forEach {
            identifier += 1

            if let rowCreator = $0 as? UICRow {
                rows.append(ListManager.RowManager.Payload(row: rowCreator)
                    .asRowManager
                    .isDynamic(false)
                    .identifier(identifier)
                )
                return
            }

            if let headerCreator = $0 as? UICHeader {
                header = ListManager.RowManager.Payload(header: headerCreator)
                    .asRowManager
                    .isDynamic(false)
                return
            }

            if let footerCreator = $0 as? UICFooter {
                footer = ListManager.RowManager.Payload(footer: footerCreator)
                    .asRowManager
                    .isDynamic(false)
                return
            }

            if let forEachCreator = $0 as? ForEachCreator, forEachCreator.viewType == UICRow.self {
                rows.append(ListManager.RowManager
                    .forEach(forEachCreator)
                    .identifier(identifier)
                )
                return
            }

            fatalError("Try using UICRow as wrapper for ViewCreators in list. It can be use UICForEach either")
        }

        return ListManager.SectionManager(manager)
            .rows(rows)
            .header(header)
            .footer(footer)
    }
    
    func viewsDidChange(placeholderView: UIView!, _ sequence: Relay<[() -> ViewCreator]>) {
        sequence.sync { [compactCopy] contents in
            let sections = contents.compactMap {
                ($0() as? UICSection)?.content
            }
            
            if sections.isEmpty {
                compactCopy.listManager?.content(compactCopy, updateSections: [])
                return
            }

            let sectionManagers = sections.map { contents -> ListManager.SectionManager in
                let manager = ListManager.SectionManager.mount(compactCopy.listManager, with: contents)

                let footer = compactCopy.footer ?? manager.footer
                let header = compactCopy.header ?? manager.header
                let rows = manager.rows

                return compactCopy.restore(rows: rows)
                    .header(header)
                    .footer(footer)
            }

            compactCopy.listManager.content(compactCopy, updateSections: sectionManagers)
        }
    }
}
