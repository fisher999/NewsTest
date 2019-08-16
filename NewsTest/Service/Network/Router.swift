//
//  Router.swift
//  NewsTest
//
//  Created by Victor on 16/08/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import Alamofire

protocol Router {
    var baseUrl: String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var parameters: Parameters? {get}
    var headers: HTTPHeaders? {get}
}

extension Router {
    var absoluteUrl: String {
        return "\(baseUrl)/\(path)"
    }
}
