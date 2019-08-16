//
//  MDNews.swift
//  NewsTest
//
//  Created by Victor on 15/08/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import SwiftyJSON

class MDNews {
    var id: Int {
        var hasher = Hasher()
        hasher.combine(title)
        hasher.combine(description)
        return hasher.finalize()
    }
    let title: String?
    let description: String?
    let date: String?
    private var imageUrl: String? {
        didSet {
            Network.shared.getImageData(from: imageUrl) { (data) in
                self.imageData = data
            }
        }
    }
    var imageData: Data?
    
    init(from json: JSON) {
        self.title = json["title"].string
        self.description = json["description"].description
        self.date = json["publishedAt"].string
        defer {
            self.imageUrl = json["urlToImage"].string
        }
    }
    
    init(from realmNews: MDRealmNews) {
        self.title = realmNews.title
        self.description = realmNews.content
        self.date = realmNews.date
        self.imageData = realmNews.imageData
    }
    
    static func createListFromArray(_ array: [MDRealmNews]) -> [MDNews] {
        var list: [MDNews] = []
        for element in array {
            let news = MDNews(from: element)
            list.append(news)
        }
        
        return list
    }
}
