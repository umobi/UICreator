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

internal class TableViewCell: UITableViewCell {
    private(set) var builder: ViewCreator! = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.focusStyle = .custom
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.commitNotRendered()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.commitRendered()
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.commitInTheScene()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.commitLayout()
    }

    func prepareCell(builder: UICList.Element.Builder) {
        if self.contentView.subviews.first is PlaceholderView {
            self.contentView.subviews.forEach {
                $0.removeFromSuperview()
            }
            
            self.builder = nil
        }

        if let creator = self.builder {
//            if let currentViewContext = creator as? ViewContext, let newViewContext = builder() as? ViewContext {
//                currentViewContext.update(context: newViewContext.context)
//            }

            self.contentView.subviews.forEach {
                $0.removeFromSuperview()
            }

            self.builder = creator
            _ = self.contentView.add(creator.releaseUIView())

            return
        }

        let builder = builder()
        self.builder = builder
        _ = self.contentView.add(builder.releaseUIView())

        if self.contentView.subviews.first is PlaceholderView {
            self.contentView.subviews.first?.snp.makeConstraints {
                $0.height.equalTo(0)
            }
        }
    }

    public override var watchingViews: [UIView] {
        return self.contentView.subviews
    }
}
