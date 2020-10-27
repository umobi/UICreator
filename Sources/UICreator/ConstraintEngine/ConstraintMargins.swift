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
import ConstraintBuilder
import CoreGraphics

public enum Margin: CaseIterable {
    case top
    case bottom
    case leading
    case trailing
}

public extension UIViewCreator {
    @inlinable
    func safeArea(
        priority: CBLayoutPriority = .required,
        _ margins: Margin...,
        equalTo value: CGFloat = 0) -> UICModifiedView<View> {

        Set(margins.isEmpty ? Margin.allCases : margins)
            .reduce(UICModifiedView { self.releaseOperationCastedView() }) {
                switch $1 {
                case .top:
                    return $0.safeArea(topEqualTo: value, priority: priority)
                case .bottom:
                    return $0.safeArea(bottomEqualTo: value, priority: priority)
                case .leading:
                    return $0.safeArea(leadingEqualTo: value, priority: priority)
                case .trailing:
                    return $0.safeArea(trailingEqualTo: value, priority: priority)
                }
            }
    }

    @inlinable
    func insets(
        priority: CBLayoutPriority = .required,
        _ margins: Margin...,
        equalTo value: CGFloat = 0) -> UICModifiedView<View> {

        Set(margins.isEmpty ? Margin.allCases : margins)
            .reduce(UICModifiedView { self.releaseOperationCastedView() }) {
                switch $1 {
                case .top:
                    return $0.top(equalTo: value, priority: priority)
                case .bottom:
                    return $0.bottom(equalTo: value, priority: priority)
                case .leading:
                    return $0.leading(equalTo: value, priority: priority)
                case .trailing:
                    return $0.trailing(equalTo: value, priority: priority)
                }
            }
    }

    @inlinable
    func margin(
        priority: CBLayoutPriority = .required,
        _ margins: Margin...,
        equalTo value: CGFloat = 0) -> UICModifiedView<View> {

        Set(margins.isEmpty ? Margin.allCases : margins)
            .reduce(UICModifiedView { self.releaseOperationCastedView() }) {
                switch $1 {
                case .top:
                    return $0.topMargin(equalTo: value, priority: priority)
                case .bottom:
                    return $0.bottomMargin(equalTo: value, priority: priority)
                case .leading:
                    return $0.leadingMargin(equalTo: value, priority: priority)
                case .trailing:
                    return $0.trailingMargin(equalTo: value, priority: priority)
                }
            }
    }
}
