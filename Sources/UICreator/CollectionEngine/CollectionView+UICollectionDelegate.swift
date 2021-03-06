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

extension UICCollectionView: UICollectionViewDelegate {

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return self.sizeForItem(at: indexPath)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {

        return self.sizeForHeader(at: section) ?? .zero
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int) -> CGSize {

        return self.sizeForFooter(at: section) ?? .zero
    }
}

public extension UICollectionView {
    fileprivate var size: CGSize {
        return .init(
            width: self.frame.size.width - (self.contentInset.left + self.contentInset.right),
            height: self.frame.height - (self.contentInset.top + self.contentInset.bottom)
        )
    }

    /// ViewCreator
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let layoutManager = self.layoutManager else {
            Fatal.noLayoutManagerConfigurated.die()
        }

        return layoutManager
            .section(at: indexPath.section)
            .size(inside: self.size, at: indexPath)
    }

    /// ViewCreator
    func sizeForHeader(at section: Int) -> CGSize? {
        guard let layoutManager = self.layoutManager else {
            Fatal.noLayoutManagerConfigurated.die()
        }

        return layoutManager
            .header(at: section)?
            .size(self.size, at: section)
    }

    /// ViewCreator
    func sizeForFooter(at section: Int) -> CGSize? {
        guard let layoutManager = self.layoutManager else {
            Fatal.noLayoutManagerConfigurated.die()
        }

        return layoutManager
            .footer(at: section)?
            .size(self.size, at: section)
    }
}

extension UICollectionView {
    enum Fatal: String, FatalType {
        case noLayoutManagerConfigurated = """
        UICollectionView is trying to get LayoutManager but there is no instance of it
        """
    }
}
