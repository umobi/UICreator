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

        init() {
            self.rows = []
            self.header = nil
            self.footer = nil
            self.identifier = 0
            self.index = 0
            self.isDynamic = false
            self.listManager = nil
        }

        private init(_ original: SectionManager, editable: Editable) {
            self.rows = editable.rows
            self.header = editable.header
            self.footer = editable.footer
            self.identifier = editable.identifier
            self.index = editable.index
            self.isDynamic = editable.isDynamic
            self.listManager = editable.listManager
        }

        private class Editable {
            var rows: [RowManager]
            var header: RowManager?
            var footer: RowManager?

            var identifier: Int
            var index: Int
            var isDynamic: Bool

            weak var listManager: (ListManager & ListSectionDelegate)!

            init(_ manager: SectionManager) {
                self.rows = manager.rows
                self.header = manager.header
                self.footer = manager.footer

                self.identifier = manager.identifier
                self.index = manager.index
                self.isDynamic = manager.isDynamic

                self.listManager = manager.listManager
            }
        }

        private func edit(_ handler: (Editable) -> Void) -> SectionManager {
            let editable = Editable(self)
            handler(editable)
            return SectionManager(self, editable: editable).assing()
        }

        func rows(_ rows: [RowManager]) -> SectionManager {
            self.edit {
                $0.rows = rows.enumerated().map {
                    $0.element.index($0.offset)
                }
            }
        }

        func header(_ header: RowManager?) -> SectionManager {
            self.edit {
                $0.header = header?.index(self.index)
            }
        }

        func footer(_ footer: RowManager?) -> SectionManager {
            self.edit {
                $0.header = footer?.index(self.index)
            }
        }

        func assing() -> SectionManager {
            self.rows.forEach {
                $0.update(section: self)
            }

            self.footer?.update(section: self)
            self.header?.update(section: self)
            return self
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

        static func forEach(_ forEachCreator: ForEachCreator) -> SectionManager {
            let manager = SectionManager().rows([RowManager.Payload(row: UICRow {
                forEachCreator
            }).asRowManager])

            forEachCreator.manager = manager
            return manager
        }

        struct Copy {
            let header: RowManager?
            let footer: RowManager?
            let identifier: Int
            let isDynamic: Bool
            let index: Int
            weak var listManager: (ListManager & ListSectionDelegate)!

            init(_ content: SectionManager) {
                self.header = content.header
                self.footer = content.footer
                self.identifier = content.identifier
                self.isDynamic = content.isDynamic
                self.listManager = content.listManager
                self.index = content.index
            }

            fileprivate func restore(rows: [RowManager]) -> SectionManager {
                SectionManager()
                    .rows(rows)
                    .header(self.header)
                    .footer(self.footer)
                    .identifier(self.identifier)
                    .isDynamic(self.isDynamic)
                    .listManager(self.listManager)
                    .index(self.index)
            }
        }

        var compactCopy: Copy {
            return .init(self)
        }
    }
}

extension ListManager.SectionManager: ListContentDelegate {
    func content(_ compactCopy: ListManager.RowManager.Copy, updatedWith sequence: [ListManager.RowManager]) {
        var updateRows = sequence
        let rows = self.rows.reduce([ListManager.RowManager]()) { sum, next -> [ListManager.RowManager] in
            if next.identifier == compactCopy.identifier {
                let toAppend = updateRows
                updateRows = []
                return sum + toAppend.enumerated().map {
                    $0.element.index(sum.count + $0.offset)
                }
            }

            return sum + [next.index(sum.count)]
        }

        self.listManager.content(updateSection: self.rows(rows))
    }
}

extension ListManager.SectionManager: SupportForEach {
    static func mount(with contents: [ViewCreator]) -> ListManager.SectionManager {
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

            if let forEachCreator = $0 as? ForEachCreator {
                rows.append(ListManager.RowManager
                    .forEach(forEachCreator)
                    .identifier(identifier)
                )
                return
            }

            fatalError("Try using UICRow as wrapper for ViewCreators in list. It can be use UICForEach either")
        }

        return ListManager.SectionManager()
            .rows(rows)
            .header(header)
            .footer(footer)
    }
    
    func viewsDidChange(placeholderView: UIView!, _ sequence: Relay<[() -> ViewCreator]>) {
        sequence.next { [compactCopy] contents in
            let sections = contents.compactMap {
                ($0() as? UICSection)?.content
            }
            
            if sections.isEmpty {
                compactCopy.listManager?.content(compactCopy, updateSections: [])
                return
            }

            let sectionManagers = sections.map { contents -> ListManager.SectionManager in
                let manager = ListManager.SectionManager.mount(with: contents)

                let footer = compactCopy.footer ?? manager.footer
                let header = compactCopy.header ?? manager.header
                let rows = manager.rows

                return compactCopy.restore(rows: rows.enumerated().map {
                        $0.element.index($0.offset)
                    })
                    .header(header)
                    .footer(footer)
            }

            compactCopy.listManager.content(compactCopy, updateSections: sectionManagers)
        }
    }
}
