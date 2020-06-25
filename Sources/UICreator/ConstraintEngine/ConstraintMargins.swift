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

public enum Margin: CaseIterable {
    case top
    case bottom
    case leading
    case trailing
}

public extension ViewCreator {
    func safeArea(
        priority: UILayoutPriority = .required,
        _ margins: Margin...,
        equalTo value: CGFloat = 0) -> Self {

        Set(margins.isEmpty ? Margin.allCases : margins).reduce(self) {
            switch $1 {
            case .top:
                return self.safeArea(topEqualTo: value, priority: priority)
            case .bottom:
                return self.safeArea(bottomEqualTo: value, priority: priority)
            case .leading:
                return self.safeArea(leadingEqualTo: value, priority: priority)
            case .trailing:
                return self.safeArea(trailingEqualTo: value, priority: priority)
            }
        }
    }

    func insets(
        priority: UILayoutPriority = .required,
        _ margins: Margin...,
        equalTo value: CGFloat = 0) -> Self {

        Set(margins.isEmpty ? Margin.allCases : margins).reduce(self) {
            switch $1 {
            case .top:
                return self.top(equalTo: value, priority: priority)
            case .bottom:
                return self.bottom(equalTo: value, priority: priority)
            case .leading:
                return self.leading(equalTo: value, priority: priority)
            case .trailing:
                return self.trailing(equalTo: value, priority: priority)
            }
        }
    }

    func margin(
        priority: UILayoutPriority = .required,
        _ margins: Margin...,
        equalTo value: CGFloat = 0) -> Self {

        Set(margins.isEmpty ? Margin.allCases : margins).reduce(self) {
            switch $1 {
            case .top:
                return self.topMargin(equalTo: value, priority: priority)
            case .bottom:
                return self.bottomMargin(equalTo: value, priority: priority)
            case .leading:
                return self.leadingMargin(equalTo: value, priority: priority)
            case .trailing:
                return self.trailingMargin(equalTo: value, priority: priority)
            }
        }
    }
}
