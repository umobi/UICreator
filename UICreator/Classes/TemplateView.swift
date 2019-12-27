//
//  TemplateView.swift
//  UIBuilder
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

public protocol TemplateView: class, ViewCreator {
    var body: ViewCreator { get }
    init()
}
