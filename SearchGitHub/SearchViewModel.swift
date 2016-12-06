//
//  SearchViewModel.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 01/12/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import RxSwift

class SearchViewModel {
    
    // MARK: Properties
    private let gitHub: GitHubAPIManager
    private let disposeBag = DisposeBag()
    private let navigationService: NavigationService
    
    var searchRepositoriesSubject = PublishSubject<(String?, String)>()
    var loadNextSubject = PublishSubject<Void>()
    
    
    private var searchedRepositoriesVariable = Variable<[Repository]>([])
    var searchedRepositories: Observable<[Repository]> {
        return searchedRepositoriesVariable.asObservable()
    }
    
    private var selectedSortTypeVariable = Variable<String>("Stars")
    var selectedSortType: Observable<String> {
        return selectedSortTypeVariable.asObservable()
    }
    
    // MARK: nitialization
    init(navigationService: NavigationService, gitHub: GitHubAPIManager){
        self.navigationService = navigationService
        self.gitHub = gitHub
        
        let searchResults = searchRepositoriesSubject.flatMapLatest{ query, sort -> Observable<SearchedRepositories> in
            guard let sQuery = query else {
                return Observable.just(SearchedRepositories(repositories: [], limitExceeded: false))
            }
            return self.gitHub.searchRepositories(query: sQuery, sortBy: sort, loadNextPage: self.loadNextSubject.asObservable())
        }
        
        searchResults
            .asDriver(onErrorJustReturn: .empty)
            .drive(onNext: { searchedRepositories in
            
                self.searchedRepositoriesVariable.value = searchedRepositories.repositories
            
                if searchedRepositories.limitExceeded {
                    navigationService.presentAlert()
                }
            }).addDisposableTo(disposeBag)
    }
    
    //MARK: Methods
    func sortTypeViewTapped() {
            navigationService.pushSortScreen(changeSortType: { [weak self] sortType in
            guard let sSelf = self, sortType != sSelf.selectedSortTypeVariable.value else {
                return
            }
            sSelf.selectedSortTypeVariable.value = sortType
        })
    }
    
    func cellSelected(row: Int) {
        navigationService.pushUserDetailsScreen(user: searchedRepositoriesVariable.value[row].owner)
    }
    
    func repositoryDetailsTapped(row: Int) {
        navigationService.pushRepositoryDetailsScreen(repository: searchedRepositoriesVariable.value[row])
    }
    
    
    
    
}
