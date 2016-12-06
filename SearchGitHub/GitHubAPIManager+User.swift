//
//  GitHubAPIManager+User.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 06/12/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import RxSwift



extension GitHubAPIManager {
    func getAllDataOfUser(url: URL) -> Observable<[String:Any]> {
        
        return URLSession
            .shared
            .rx
            .response(request: URLRequest(url: url))
            .map{ response, data in
                let json: Any
                do{
                     json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                } catch {
                    return  [:]
                }
                
                if let jsonData = json as? [String:Any] {
                    return jsonData
                } else {
                    return [:]
                }
            }
    }
}
