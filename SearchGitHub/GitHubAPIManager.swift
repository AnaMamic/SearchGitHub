//
//  GitHubAPIManager.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 04/12/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import Foundation
import RxSwift

struct SearchedRepositories {
    let repositories: [Repository]
    let limitExceeded: Bool
    
    static let empty = SearchedRepositories(repositories: [], limitExceeded: false)
}

enum SearchRepositoryResponse {
    case repositories(newLoadedRepositories: [Repository], nextURL: URL?)
    case limitExceeded
    case error
}

class GitHubAPIManager {
    
    func searchRepositories(query: String, sortBy: String, loadNextPage: Observable<Void>) -> Observable<SearchedRepositories> {
        guard let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return Observable.just(SearchedRepositories.empty)
        }

        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(escapedQuery)+sort:\(sortBy)") else {
            return Observable.just(SearchedRepositories.empty)
        }
        
        return recursivelySearchRepositories(loadedRepositories: [], loadNextURL: url, loadNextPage: loadNextPage)

    }
    
    private func recursivelySearchRepositories(loadedRepositories: [Repository], loadNextURL: URL, loadNextPage: Observable<Void>) -> Observable<SearchedRepositories> {
        
        return loadRepositories(url: loadNextURL).flatMap{ searchResponse -> Observable<SearchedRepositories> in
            switch searchResponse {
            case .limitExceeded:
                return Observable.just(SearchedRepositories(repositories: loadedRepositories, limitExceeded: true))
                
            case .error:
                return Observable.just(SearchedRepositories(repositories: loadedRepositories, limitExceeded: false))
                
            case let .repositories(newLoadedRepositories, newNextURL):
                
                var repositories = loadedRepositories
                repositories.append(contentsOf: newLoadedRepositories)
                
                let allLoadedRepositories = SearchedRepositories(repositories: repositories, limitExceeded: false)
                
                guard let nextURL = newNextURL else {
                    return Observable.just(allLoadedRepositories)
                }

                return Observable.concat([
                    Observable.just(allLoadedRepositories),
                    Observable.never().takeUntil(loadNextPage),
                    self.recursivelySearchRepositories(loadedRepositories: repositories, loadNextURL: nextURL, loadNextPage: loadNextPage)
                ])

            }
            
        }
    }
    
    private func loadRepositories(url: URL) -> Observable<SearchRepositoryResponse> {
        return URLSession.shared.rx.response(request: URLRequest(url: url)).map{ response, data -> SearchRepositoryResponse in
            if response.statusCode == 403 {
                return .limitExceeded
            }
            
            let nextURL = self.getNextUrl(response: response)
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                guard let items = json["items"] as? [Dictionary<String, AnyObject>] else {
                    return .error
                }
                
                var repositories = [Repository]()
                
                for item in items {
                    if let repository = Repository(json: item) {
                        repositories.append(repository)
                    }
                }
                
                return .repositories(newLoadedRepositories: repositories, nextURL: nextURL)
                
            } catch {
                return .error
            }
      }
    }
    
    private func getNextUrl(response: HTTPURLResponse) -> URL? {
        guard let linkField = response.allHeaderFields["Link"] as? String else {
            return nil
        }
        
        guard let endIndex = linkField.range(of: ">;")?.lowerBound else {
            return nil
        }
        
        let startIndex = linkField.index(linkField.startIndex, offsetBy: 1)
        let range = startIndex..<endIndex
        let nextURLString = linkField.substring(with: range)
        guard let nextURL = URL(string: nextURLString) else {
            return nil
        }
        
        return nextURL
    }
    
}
