//
//  UITableViewCell+ReuseNib.swift
//  NewsTest
//
//  Created by Victor on 16/08/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var nib: UINib {
        return UINib(nibName: defaultReuseIdentifier, bundle: Bundle.main)
    }
    
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
