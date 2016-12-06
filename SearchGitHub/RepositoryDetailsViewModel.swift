//
//  RepositoryDetailsViewModel.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 06/12/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation

class RepositoryDetailsViewModel {
    
    // MARK: Properties
    private let navigationService: NavigationService
    private let repository: Repository
    
    init(navigationService: NavigationService, repository: Repository) {
        self.navigationService = navigationService
        self.repository = repository
    }
    
    // MARK: Methods
    func name() -> String {
        return repository.name
    }
    
    func createdAt() -> String {
        return repository.createdAt
    }
    
    func updatedAt() -> String {
        return repository.updatedAt
    }
    
    func forks() -> String {
        return repository.numberOfForks
    }
    
    func watchers() -> String {
        return repository.numberOfWatchers
    }
    
    func issues() -> String {
        return repository.numberOfIssues
    }
    
    func description() -> String? {
        guard let descritpion = repository.description else {
            return nil
        }
        return descritpion
    }
    
    func score() -> String {
        return repository.score
    }
    
    func language() -> String {
        return repository.language
    }
    
    func seeMoreTapped() {
        navigationService.openURL(url: repository.html_url)
    }
    
    func seeOwnerTapped() {
        navigationService.pushUserDetailsScreen(user: repository.owner)
    }

}
