//
//  ViewControllerType+ViewBuilder.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIContainer

public extension ViewControllerType where Self: ViewBuilder & ContainerViewParent {
    var content: ViewControllerMaker {
        return .dynamic { [unowned self] in
            $0.view.addSubview(self)
            $0.view.backgroundColor = .clear
            self.snp.makeConstraints {
                $0.edges.equalTo(0)
            }
        }
    }
}
