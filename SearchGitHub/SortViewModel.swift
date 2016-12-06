//
//  SortViewModel.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 01/12/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import RxSwift

typealias ChangeSelectedSortType = (String) -> Void

class SortViewModel {
    
    // MARK: Properties
    private let changeSortType: ChangeSelectedSortType
    private let navigationService: NavigationService
    private let disposeBag = DisposeBag()
    var sortTypes: Observable<[String]>
    var tappedCellObservable = PublishSubject<String>()
    
    
    
    // MARK: Initialization
    init(changeSortType: @escaping ChangeSelectedSortType, navigationService: NavigationService) {
        self.changeSortType = changeSortType
        self.navigationService = navigationService
        
        sortTypes = Observable.just(["Stars", "Forks", "Updated"])
        _ = tappedCellObservable
            .subscribe(onNext: { selectedSortType in
                changeSortType(selectedSortType)
                navigationService.popScreen()
            })
    }
    
}
