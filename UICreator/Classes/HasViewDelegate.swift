//
//  HasViewDelegate.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation

public protocol HasViewDelegate {
    associatedtype Delegate
    var delegate: Delegate { get set }

    func delegate(_ delegate: Delegate) -> Self
}
