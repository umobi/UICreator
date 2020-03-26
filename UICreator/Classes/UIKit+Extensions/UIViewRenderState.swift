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

internal extension UIView {

    /// `enum Mode` The view rendering mode. It is updated depending on the hierarchy of the view.
    /// To execute each state, the superview should call `commitNotRendered()`, `commitRendered()` and `commitInTheScene()`
    /// provided by `protocol ViewCreator` .
    enum RenderState {
        case notRendered
        case rendered
        case inTheScene
        case unset
    }
}

extension UIView.RenderState {
    private static var allCases: [UIView.RenderState] {
        return [.unset, .notRendered, .rendered, .inTheScene]
    }

    static func >(left: UIView.RenderState, right: UIView.RenderState) -> Bool {
        let allCases = self.allCases
        guard let leftOffset = allCases.enumerated().first(where: { $0.element == left })?.offset else {
            return false
        }

        return allCases[0..<leftOffset].contains(right)
    }

    static func <(left: UIView.RenderState, right: UIView.RenderState) -> Bool {
        let allCases = self.allCases
        guard let leftOffset = allCases.enumerated().first(where: { $0.element == left })?.offset else {
            return false
        }

        return allCases[(leftOffset+1)..<allCases.count].contains(right)
    }

    static func >=(left: UIView.RenderState, right: UIView.RenderState) -> Bool {
        let allCases = self.allCases
        guard let leftOffset = allCases.enumerated().first(where: { $0.element == left })?.offset else {
            return false
        }

        return allCases[0...leftOffset].contains(right)
    }

    static func <=(left: UIView.RenderState, right: UIView.RenderState) -> Bool {
        let allCases = self.allCases
        guard let leftOffset = allCases.enumerated().first(where: { $0.element == left })?.offset else {
            return false
        }

        return allCases[leftOffset..<allCases.count].contains(right)
    }

    var prev: UIView.RenderState? {
        Self.allCases.split(separator: self).first?.last
    }

    var next: UIView.RenderState? {
        Self.allCases.split(separator: self).last?.first
    }
}
