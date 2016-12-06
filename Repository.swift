//
//  Repository.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 04/12/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import Gloss

class Repository: Decodable {
    let name: String
    let numberOfForks: String
    let numberOfIssues: String
    let score: String
    let numberOfWatchers: String
    let createdAt: String
    let updatedAt: String
    let description: String?
    let html_url: URL
    let language: String
    let owner: Owner
    
    required init?(json: JSON) {
        guard let name: String = Decoder.decode(key: "name")(json),
            let numberOfForks: Int = Decoder.decode(key: "forks")(json),
            let numberOfIssues: Int = Decoder.decode(key: "open_issues")(json),
            let score: Float = Decoder.decode(key: "score")(json),
            let numberOfWatchers: Int = Decoder.decode(key: "watchers")(json),
            let createdAt = Decoder.decode(dateISO8601ForKey: "created_at")(json),
            let updatedAt = Decoder.decode(dateISO8601ForKey: "updated_at")(json),
            let html_url = Decoder.decode(urlForKey: "html_url")(json),
            let language: String = Decoder.decode(key: "language")(json),
            let owner: Owner = Decoder.decode(decodableForKey: "owner")(json)
        else {
                return nil
        }
        
        self.name = name
        self.numberOfForks = String(numberOfForks)
        self.numberOfIssues = String(numberOfIssues)
        self.score = String(score)
        self.numberOfWatchers = String(numberOfWatchers)
        self.createdAt = String(describing: createdAt)
        self.updatedAt = String(describing: updatedAt)
        self.description = Decoder.decode(key: "description")(json)
        self.html_url = html_url
        self.language = language
        self.owner = owner
    }
    
}
