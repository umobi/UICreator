//
//  File.swift
//  
//
//  Created by brennobemoura on 25/10/20.
//

import Foundation
import UIKit
import ConstraintBuilder

public struct AnyView: _UIViewCreator {
    public typealias View = UIView

    let viewLoader: () -> CBView

    public init(_ viewCreator: _ViewCreator) {
        self.viewLoader = {
            viewCreator.releaseUIView()
        }
    }
}

public extension AnyView {
    static func makeUIView(_ viewCreator: _ViewCreator) -> UIView {
        (viewCreator as! Self).viewLoader()
    }
}
