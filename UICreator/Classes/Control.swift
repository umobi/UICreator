//
//  Control.swift
//  Pods
//
//  Created by brennobemoura on 21/12/19.
//

import Foundation
import UIKit

private protocol Control: UIControl {
    func onEvent(_ event: UIControl.Event, _ handler: @escaping (UIView) -> Void) -> Self
}
