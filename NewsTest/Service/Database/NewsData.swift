//
//  Database.swift
//  NewsTest
//
//  Created by Victor on 15/08/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import RealmSwift

class NewsData {
    static var shared: NewsData = NewsData()
    
    private init() {}
    
    func getNewsList() throws -> [MDNews] {
        do {
            let realm = try Realm()
            let news = realm.objects(MDRealmNews.self)
            let array = Array(news)
            let list = MDNews.createListFromArray(array)
            return Array(list.reversed())
        } catch let error {
            throw error
        }
    }
    
    func saveNews(model: MDNews) throws {
        let newsRealm = MDRealmNews(from: model)
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(newsRealm, update: true)
            }
        } catch let error {
            throw error
        }
    }
    
    func saveNewsList(model: [MDNews],failed: (Error) -> Void) {
        do {
            for news in model {
                try saveNews(model: news)
            }
        }
        catch let error {
            failed(error)
        }
    }
}
