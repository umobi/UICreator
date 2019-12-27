//
//  Subview.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

/// Wrapper class for collection of Subviews
public struct Subview {
    public let views: [ViewCreator]

    public init(_ views: ViewCreator...) {
        self.views = views
    }
}
