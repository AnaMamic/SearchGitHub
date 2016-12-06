//
//  Owner.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 04/12/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import Gloss

class Owner: Decodable {
    let login: String
    let url: URL
    let image: UIImage
    var html_url: URL?
    var name: String?
    var company: String?
    var blog: URL?
    var email: String?
    var publicRepos: Int?
    var followers: Int?
    var following: Int?
    
    required init?(json: JSON) {
        guard let imageURL = Decoder.decode(urlForKey: "avatar_url")(json),
              let url = Decoder.decode(urlForKey: "url")(json),
              let login: String = Decoder.decode(key: "login")(json),
              let image = ImageService.getImageFrom(url: imageURL) else {
                return nil
        }
        
        self.login = login
        self.url = url
        self.image = image
    }
    
    func getAllData(json: JSON) {
        html_url = Decoder.decode(urlForKey: "html_url")(json)
        name = Decoder.decode(key: "name")(json)
        company = Decoder.decode(key: "company")(json)
        blog = Decoder.decode(urlForKey: "blog")(json)
        email = Decoder.decode(key: "email")(json)
        publicRepos = Decoder.decode(key: "public_repos")(json)
        followers = Decoder.decode(key: "followers")(json)
        following = Decoder.decode(key: "following")(json)
    }
}
