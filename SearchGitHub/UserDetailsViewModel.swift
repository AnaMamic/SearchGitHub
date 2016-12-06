//
//  UserDetailsViewModel.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 06/12/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import RxSwift

class UserDetailsViewModel {
    
    // MARK: Properties
    private let navigationService: NavigationService
    private let gitHub: GitHubAPIManager
    private let disposeBag = DisposeBag()
    private var userVariable : Variable<Owner>
    var user: Observable<Owner> {
        return userVariable.asObservable()
    }
    
    init(navigationService: NavigationService, user: Owner, gitHub: GitHubAPIManager ) {
        self.navigationService = navigationService
        self.userVariable = Variable(user)
        self.gitHub = gitHub
        
        if userVariable.value.html_url == nil {
            gitHub
                .getAllDataOfUser(url: user.url)
                .subscribe(onNext: {userData in
                    user.getAllData(json: userData)
                    self.userVariable.value = user

                }).addDisposableTo(disposeBag)
        } else {
            userVariable.value = user
        }
    }
    
    // MARK: Methods
    func login() -> String {
        return userVariable.value.login
    }
    
    func image() -> UIImage {
        return userVariable.value.image
    }
    
    func company() -> String {
        guard let company = userVariable.value.company else {
            return "/"
        }
        return company
    }
    
    func name() -> String {
        guard let name = userVariable.value.name else {
            return "/"
        }
        return name
    }
    
    func blog() -> String {
        guard let blog = userVariable.value.blog else {
            return "/"
        }
        return String(describing: blog)
    }
    
    func email() -> String {
        guard let email = userVariable.value.email else {
            return "/"
        }
        return email
    }
    
    func publicRepos() -> String {
        guard let repos = userVariable.value.publicRepos else {
            return "/"
        }
        return String(repos)
    }
    
    func followers() -> String {
        guard let followers = userVariable.value.followers else {
            return "/"
        }
        return String(followers)
    }
    
    func following() -> String? {
        guard let following = userVariable.value.following else {
            return "/"
        }
        return String(following)
    }

    func seeMoreTapped(){
        guard let url = userVariable.value.html_url else {
            return
        }
        navigationService.openURL(url: url)
    }
}
