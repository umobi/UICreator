//
//  ViewControllerType+ViewCreator.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIContainer

public extension ViewControllerType where Self: ViewCreator {
    var content: ViewControllerMaker {
        return .dynamic {
            $0.view.addSubview(self.uiView)
            $0.view.backgroundColor = .clear
            self.uiView.snp.makeConstraints {
                $0.edges.equalTo(0)
            }
        }
    }
}
