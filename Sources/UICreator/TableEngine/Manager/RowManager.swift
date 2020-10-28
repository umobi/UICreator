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
import ConstraintBuilder

protocol ListContentDelegate: class {
    func content(_ compactCopy: ListManager.RowManager.Copy, updatedWith sequence: [ListManager.RowManager])
}

protocol ListContentSectionRestore: class {
    func section(at index: Int) -> ListManager.SectionManager
}

extension ListManager {
    @usableFromInline
    final class RowManager {
        let payload: Payload
        let identifier: Int
        let indexPath: IndexPath
        let isDynamic: Bool
        private(set) weak var listManager: (ListManager & ListContentSectionRestore)!
        private(set) var forEachEnviroment: ForEachEnviromentType?

        fileprivate init(_ payload: Payload) {
            self.payload = payload
            self.isDynamic = false
            self.indexPath = .init(row: .zero, section: .zero)
            self.identifier = 0
            self.listManager = nil
            self.forEachEnviroment = nil
        }

        private init(_ original: RowManager, editable: Editable) {
            self.payload = original.payload
            self.identifier = editable.identifier
            self.indexPath = editable.indexPath
            self.isDynamic = editable.isDynamic
            self.listManager = original.listManager ?? editable.listManager
            self.forEachEnviroment = original.forEachEnviroment
            self.forEachEnviroment?.setManager(self)
        }

        func identifier(_ identifier: Int) -> RowManager {
            self.edit {
                $0.identifier = identifier
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
            guard let forEachEnviroment = self.forEachEnviroment, !forEachEnviroment.isReleased else {
                return false
            }

            forEachEnviroment.syncManager()
            return forEachEnviroment.isReleased
        }

        @usableFromInline
        static func forEachShared(_ forEachShared: ForEachEnviromentShared) -> RowManager {
            let manager = Payload(row: UICRow {
                forEachShared
            }).asRowManager

            forEachShared.enviroment.setManager(manager)
            manager.forEachEnviroment = forEachShared.enviroment
            return manager
        }

        private func forEachEnviroment(_ forEachEnviroment: ForEachEnviromentType?) -> RowManager {
            self.forEachEnviroment = forEachEnviroment
            forEachEnviroment?.setManager(self)
            return self
        }
    }
}

extension ListManager.RowManager {
    enum ContentType {
        case header
        case footer
        case row
    }

    struct Payload {
        let content: () -> ViewCreator
        let trailingActions: (() -> RowAction)?
        let leadingActions: (() -> RowAction)?
        let accessoryType: UITableViewCell.AccessoryType
        let estimatedHeight: CGFloat?
        let contentType: ContentType

        init(header: UICHeader) {
            self.content = header.content
            self.trailingActions = nil
            self.leadingActions = nil
            self.accessoryType = .none
            self.estimatedHeight = header.height
            self.contentType = .header
        }

        init(footer: UICFooter) {
            self.content = footer.content
            self.trailingActions = nil
            self.leadingActions = nil
            self.accessoryType = .none
            self.estimatedHeight = nil
            self.contentType = .footer
        }

        init(row: UICRow) {
            self.content = row.content
            self.trailingActions = row.trailingActions
            self.leadingActions = row.leadingActions
            self.accessoryType = row.accessoryType
            self.estimatedHeight = nil
            self.contentType = .row
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
        weak private var forEachEnviroment: ForEachEnviromentType?

        fileprivate init(_ content: ListManager.RowManager) {
            self.identifier = content.identifier
            self.isDynamic = content.isDynamic
            self.listManager = content.listManager
            self.indexPath = content.indexPath
            self.forEachEnviroment = content.forEachEnviroment
        }

        fileprivate func restore(_ payload: Payload) -> ListManager.RowManager {
            ListManager.RowManager(payload)
                .identifier(self.identifier)
                .isDynamic(self.isDynamic)
                .listManager(self.listManager)
                .indexPath(self.indexPath)
                .forEachEnviroment(self.forEachEnviroment)
        }
    }

    var compactCopy: Copy {
        return Copy(self)
    }
}

extension ListManager.RowManager: SupportForEach {
    @usableFromInline
    func viewsDidChange(_ placeholderView: CBView!, _ dynamicContent: Relay<[() -> ViewCreator]>) {
        dynamicContent.sync { [compactCopy] in
            compactCopy.listManager
                .section(at: compactCopy.indexPath.section)
                .content(compactCopy, updatedWith: $0.map { content in
                    guard let row = content() as? UICRow else {
                        Fatal.Builder("Content is not a type of UICRow").die()
                    }

                    return compactCopy.restore(.init(row: row))
                })
        }
    }
}
