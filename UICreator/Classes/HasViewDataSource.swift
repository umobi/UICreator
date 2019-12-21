//
//  HasViewDataSource.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation

public protocol HasViewDataSource {
    associatedtype DataSource
    var dataSource: DataSource { get set }

    func dataSource(_ dataSource: DataSource) -> Self
}
