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

extension ListManager {
    final class RowManager {
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

            var asRowManager: RowManager {
                return .init(self)
            }
        }

        let payload: Payload
        let identifier: Int
        let index: Int
        let isDynamic: Bool
        private(set) weak var section: (ListManager.SectionManager & ListContentDelegate)!

        fileprivate init(_ payload: Payload) {
            self.payload = payload
            self.isDynamic = false
            self.index = 0
            self.identifier = 0
            self.section = nil
        }

        private init(_ original: RowManager, editable: Editable) {
            self.payload = original.payload
            self.identifier = editable.identifier
            self.index = editable.index
            self.isDynamic = editable.isDynamic
            self.section = original.section ?? editable.section
        }

        private func edit(_ handler: (Editable) -> Void) -> RowManager {
            let editable = Editable(self)
            handler(editable)
            return .init(self, editable: editable)
        }

        private class Editable {
            var identifier: Int
            var isDynamic: Bool
            var index: Int
            weak var section: (ListManager.SectionManager & ListContentDelegate)!

            init(_ content: RowManager) {
                self.identifier = content.identifier
                self.isDynamic = content.isDynamic
                self.index = content.index
                self.section = content.section
            }
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

        func index(_ index: Int) -> RowManager {
            self.edit {
                $0.index = index
            }
        }

        func section(_ section: ListManager.SectionManager & ListContentDelegate) -> RowManager {
            self.edit {
                $0.section = section
            }
        }

        func update(section: ListManager.SectionManager & ListContentDelegate) {
            self.section = section
        }

        static func forEach(_ forEachCreator: ForEachCreator) -> RowManager {
            let manager = Payload(row: UICRow {
                forEachCreator
            }).asRowManager

            forEachCreator.manager = manager
            return manager
        }

        struct Copy {
            let identifier: Int
            let isDynamic: Bool
            let index: Int
            weak var section: (ListManager.SectionManager & ListContentDelegate)!

            init(_ content: RowManager) {
                self.identifier = content.identifier
                self.isDynamic = content.isDynamic
                self.section = content.section
                self.index = content.index
            }

            fileprivate func restore(_ payload: Payload) -> RowManager {
                RowManager(payload)
                    .identifier(self.identifier)
                    .isDynamic(self.isDynamic)
                    .section(self.section)
                    .index(self.index)
            }
        }

        var compactCopy: Copy {
            return Copy(self)
        }
    }
}

extension ListManager.RowManager: SupportForEach {
    func viewsDidChange(placeholderView: UIView!, _ sequence: Relay<[() -> ViewCreator]>) {
        sequence.next { [compactCopy] in
            compactCopy.section?.content(compactCopy, updatedWith: $0.map { content in
                compactCopy.restore(.init(row: content() as! UICRow))
            })
        }
    }
}
