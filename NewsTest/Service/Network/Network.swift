//
//  Network.swift
//  NewsTest
//
//  Created by Victor on 15/08/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import ReactiveSwift

class Network {
    static var shared: Network = Network()
    
    private init() {}
    
    func getImageData(from url: String?, success: @escaping ((Data?) -> Void) ) {
        guard let strongUrl = url else {return}
        Alamofire.request(strongUrl).response { (response) in
            success(response.data)
        }
    }
    
    func request(router: Router, completionHandler: @escaping (DefaultDataResponse) -> Void) {
        Alamofire.request(router.absoluteUrl, method: router.method, parameters: router.parameters, encoding: URLEncoding.default, headers: router.headers).response(completionHandler: completionHandler)
    }
}
