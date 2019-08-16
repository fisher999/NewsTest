//
//  UIViewController+Alert.swift
//  NewsTest
//
//  Created by Victor on 16/08/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alert(message: String, handler: (() -> Void)? = nil, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertHandler: ((UIAlertAction) -> (Void))? = { _ in
            if let validHandler = handler {
                validHandler()
            }
        }
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: alertHandler)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
