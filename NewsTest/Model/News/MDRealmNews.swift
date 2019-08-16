//
//  MDRealmNews.swift
//  NewsTest
//
//  Created by Victor on 15/08/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import RealmSwift

class MDRealmNews: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var imageData: Data = Data()
    
    convenience init(from news: MDNews) {
        self.init()
        self.id = news.id
        self.title = news.title ?? ""
        self.content = news.description ?? ""
        self.date = news.date ?? ""
        self.imageData = news.imageData ?? Data()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
