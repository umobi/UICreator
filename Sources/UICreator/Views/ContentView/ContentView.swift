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

extension Views {
    // swiftlint:disable file_length type_body_length
    @usableFromInline
    internal class ContentView: CBView, UICViewContent {
        weak var view: CBView?

        var priority: CBLayoutPriority {
            didSet {
                self.reloadContentLayout()
            }
        }

        var layoutMode: LayoutMode {
            didSet {
                self.reloadContentLayout(oldValue)
            }
        }

        init(_ contentMode: LayoutMode, priority: CBLayoutPriority) {
            self.priority = priority
            self.layoutMode = .center
            super.init(frame: .zero)
            self.makeSelfImplemented()
        }

        override init(frame: CGRect) {
            Fatal.Builder("init(frame:) has not been implemented").die()
        }

        required init?(coder: NSCoder) {
            Fatal.Builder("init(coder:) has not been implemented").die()
        }

        override var isHidden: Bool {
            get { super.isHidden }
            set {
                super.isHidden = newValue
                self.renderManager.isHidden(newValue)
            }
        }

        override var frame: CGRect {
            get { super.frame }
            set {
                super.frame = newValue
                self.renderManager.frame(newValue)
            }
        }

        override func willMove(toSuperview newSuperview: UIView?) {
            super.willMove(toSuperview: newSuperview)
            self.renderManager.willMove(toSuperview: newSuperview)
        }

        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            self.renderManager.didMoveToSuperview()
        }

        override func didMoveToWindow() {
            super.didMoveToWindow()
            self.renderManager.didMoveToWindow()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            self.renderManager.layoutSubviews()
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            self.renderManager.traitDidChange()
        }

        @usableFromInline
        func addContent(_ view: CBView) {
            CBSubview(self).addSubview(view)
            self.view = view

            self.reloadContentLayout()
        }

        @usableFromInline
        func reloadContentLayout() {
            self.reloadContentLayout(nil)
        }
    }
}

private extension Views.ContentView {
    // swiftlint:disable function_body_length
    func reloadContentLayout(_ oldLayoutMode: LayoutMode?) {
        guard let view = self.view else {
            return
        }

        self.removeConstraints(oldLayoutMode ?? self.layoutMode)

        switch self.layoutMode {
        case .bottom:
            Constraintable.activate {
                view.cbuild
                    .bottom
                    .priority(priority)

                view.cbuild
                    .centerX
                    .equalTo(self.cbuild.centerX)
                    .priority(priority)

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0)
                    .priority(priority)

                view.cbuild
                    .leading
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            }
        case .bottomLeft:
            Constraintable.activate {
                view.cbuild
                    .bottom
                    .equalTo(0)
                    .priority(priority)

                view.cbuild
                    .leading
                    .equalTo(0)
                    .priority(priority)

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0)
                    .priority(priority)

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            }

        case .bottomRight:
            Constraintable.activate {
                view.cbuild
                    .bottom
                    .equalTo(0)
                    .priority(priority)

                view.cbuild
                    .trailing
                    .equalTo(0)
                    .priority(priority)

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0)
                    .priority(priority)

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            }
        case .center:
            Constraintable.activate {
                view.cbuild
                    .center
                    .equalTo(self.cbuild.center)
                    .priority(priority)

                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority)

                view.cbuild
                    .leading
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            }

        case .left:
            Constraintable.activate {
                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority)

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)

                view.cbuild
                    .leading
                    .equalTo(0)
                    .priority(priority)

                view.cbuild
                    .centerY
                    .equalTo(self.cbuild.centerY)
                    .priority(priority)
            }

        case .right:
            Constraintable.activate {
                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority)

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
                    .priority(priority)

                view.cbuild
                    .trailing
                    .equalTo(0)
                    .priority(priority)

                view.cbuild
                    .centerY
                    .equalTo(self.cbuild.centerY)
                    .priority(priority)
            }

        case .top:
            Constraintable.activate {
                view.cbuild
                    .top
                    .equalTo(0)
                    .priority(priority)

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority)

                view.cbuild
                    .leading
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)

                view.cbuild
                    .centerX
                    .equalTo(self.cbuild.centerX)
                    .priority(priority)
            }

        case .topLeft:
            Constraintable.activate {
                view.cbuild
                    .top
                    .equalTo(0)
                    .priority(priority)

                view.cbuild
                    .leading
                    .equalTo(0)
                    .priority(priority)

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority)

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            }

        case .topRight:
            Constraintable.activate {
                view.cbuild
                    .top
                    .equalTo(0)
                    .priority(priority)

                view.cbuild
                    .trailing
                    .equalTo(0)
                    .priority(priority)

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority)

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            }
        }
    }
}

private extension Views.ContentView {
    // swiftlint:disable function_body_length
    private func removeConstraints(_ oldValue: LayoutMode) {
        guard let view = self.view else {
            return
        }

        switch oldValue {
        case .bottom:
            Constraintable.deactivate {
                view.cbuild
                    .bottom

                view.cbuild
                    .centerX
                    .equalTo(self.cbuild.centerX)

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0)

                view.cbuild
                    .trailing
                    .leading
                    .greaterThanOrEqualTo(0)
            }

        case .bottomLeft:
            Constraintable.deactivate {
                view.cbuild
                    .bottom
                    .equalTo(0)

                view.cbuild
                    .leading
                    .equalTo(0)

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0)

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
            }

        case .bottomRight:
            Constraintable.deactivate {
                view.cbuild
                    .bottom
                    .equalTo(0)

                view.cbuild
                    .trailing
                    .equalTo(0)

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0)

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
            }

        case .center:
            Constraintable.deactivate {
                view.cbuild
                    .center
                    .equalTo(self.cbuild.center)

                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0)

                view.cbuild
                    .trailing
                    .leading
                    .greaterThanOrEqualTo(0)
            }

        case .left:
            Constraintable.deactivate {
                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0)

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)

                view.cbuild
                    .leading
                    .equalTo(0)

                view.cbuild
                    .centerY
                    .equalTo(self.cbuild.centerY)
            }

        case .right:
            Constraintable.deactivate {
                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0)

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)

                view.cbuild
                    .trailing
                    .equalTo(0)

                view.cbuild
                    .centerY
                    .equalTo(self.cbuild.centerY)
            }

        case .top:
            Constraintable.deactivate {
                view.cbuild
                    .top
                    .bottom
                    .equalTo(0)

                view.cbuild
                    .leading
                    .trailing
                    .greaterThanOrEqualTo(0)

                view.cbuild
                    .centerX
                    .equalTo(self.cbuild.centerX)
            }

        case .topLeft:
            Constraintable.deactivate {
                view.cbuild
                    .top
                    .equalTo(0)

                view.cbuild
                    .leading
                    .equalTo(0)

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0)

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
            }

        case .topRight:
            Constraintable.deactivate {
                view.cbuild
                    .top
                    .equalTo(0)

                view.cbuild
                    .trailing
                    .equalTo(0)

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0)

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
            }
        }
    }
}