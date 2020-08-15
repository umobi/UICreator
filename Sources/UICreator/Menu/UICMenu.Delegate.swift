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

#if os(iOS)
private var kContentMenuDelegate = 0
@available(iOS 13, *)
extension UIContextMenuInteraction {
    var menuDelegate: UICMenu.Delegate? {
        get { objc_getAssociatedObject(self, &kContentMenuDelegate) as? UICMenu.Delegate }
        set { objc_setAssociatedObject(self, &kContentMenuDelegate, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    static func interaction(_ uicDelegate: UICMenu.Delegate) -> UIContextMenuInteraction {
        let interaction = UIContextMenuInteraction(delegate: uicDelegate)
        interaction.menuDelegate = uicDelegate
        return interaction
    }
}

extension UICMenu {
    @available(iOS 13, *)
    class Delegate: NSObject, UIContextMenuInteractionDelegate {
        let menu: UICMenu

        init(_ menu: UICMenu) {
            self.menu = menu
        }

        func contextMenuInteraction(
            _ interaction: UIContextMenuInteraction,
            configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {

            return UIContextMenuConfiguration(
                identifier: nil,
                previewProvider: {
                    guard let provider = self.menu.provider else {
                        return nil
                    }

                    return { UICHostingController(content: provider )}
                }(),
                actionProvider: { [weak self] _ in
                    self?.menu.uiMenu
                })
          }

        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
            // TODO: - Move to provider
        }
    }
}
#endif
