//
//  NewsProvider.swift
//  NewsTest
//
//  Created by Victor on 15/08/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum NewsService {
    case topHeadlines
}

extension NewsService: Router {
    
    private var apiKey: String {
        return "2dac4f6df352465486465900bce07fa2"
    }
    
    var baseUrl: String {
        return "https://newsapi.org/v2"
    }
    
    var path: String {
        switch self {
        case .topHeadlines:
            return "top-headlines?country=ru"
        }
    }

    
    var method: HTTPMethod {
        switch self {
        case .topHeadlines:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization": apiKey, "Content-Type": "application/json"]
    }
    
    var parameters: Parameters? {
        switch self {
        case .topHeadlines:
            return nil
        }
    }
}

