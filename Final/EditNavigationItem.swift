//
//  EditNavigationItem.swift
//  Final
//
//  Created by PJ Shalhoub on 11/24/17.
//  Copyright © 2017 PJ Shalhoub. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
}
