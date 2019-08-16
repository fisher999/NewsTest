//
//  NewsCell.swift
//  NewsTest
//
//  Created by Victor on 16/08/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var datetimeLabel: UILabel!
    @IBOutlet fileprivate weak var imageIcon: UIImageView!
    
    var model: MDNews? {
        didSet {
            self.titleLabel.text = model?.title
            self.descriptionLabel.text = model?.description
            self.datetimeLabel.text = model?.date
            if let imageData = model?.imageData {
                self.imageIcon.image = UIImage(data: imageData)
            }
        }
    }
}
