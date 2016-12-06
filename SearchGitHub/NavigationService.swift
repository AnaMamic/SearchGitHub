//
//  NavigationService.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 29/11/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import UIKit

class NavigationService {
    private let navigationController = UINavigationController()
    private lazy var gitHubAPIManager = GitHubAPIManager()
    
    func pushInitialScreen(window: UIWindow?) {
        let searchViewController = SearchViewController(viewModel: SearchViewModel(navigationService: self, gitHub: gitHubAPIManager))
        navigationController.setViewControllers([searchViewController], animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func pushSortScreen(changeSortType: @escaping ChangeSelectedSortType){
        let sortViewController = SortViewController(viewModel: SortViewModel(changeSortType: changeSortType, navigationService: self))
        navigationController.pushViewController(sortViewController, animated: true)
    }
    
    func popScreen(){
        navigationController.popViewController(animated: true)
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Limit Exceeded", message: "Wait 1 minute", preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController.dismiss(animated: true, completion: nil)
            
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func pushRepositoryDetailsScreen(repository: Repository) {
        let repositoryDetailsViewController = RepositoryDetailsViewController(viewModel: RepositoryDetailsViewModel(navigationService: self, repository: repository))
        
        navigationController.pushViewController(repositoryDetailsViewController, animated: true)
    }
    
    func pushUserDetailsScreen(user: Owner) {
        let userDetailsViewController = UserDetailsViewController(viewModel: UserDetailsViewModel(navigationService: self, user: user, gitHub: gitHubAPIManager))
        
        navigationController.pushViewController(userDetailsViewController, animated: true)
    }
    
    func openURL(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
