//
//  SearchViewController.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 29/11/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}


class SearchViewController: UIViewController, UITableViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var sortTypeView: UIView!
    @IBOutlet weak private var sortTypeLabel: UILabel!
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: SearchViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search GitHub"
        
        tableViewSetup()
        setup()
    
    }
    
    // MARK: Functions
    
    private func setup() {
        
        sortTypeView
            .rx
            .gesture(.tap)
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let sSelf = self else {
                    return
                }
                sSelf.viewModel.sortTypeViewTapped()
                })
            .addDisposableTo(disposeBag)
        
        viewModel
            .selectedSortType
            .asDriver(onErrorJustReturn: "")
            .drive(sortTypeLabel.rx.text).addDisposableTo(disposeBag)
        
        
        Observable
            .combineLatest(
                searchBar
                    .rx
                    .text
                    .throttle(0.5, scheduler: MainScheduler.instance)
                    .distinctUntilChanged({ old, new in return old == new
                    }),
                viewModel
                    .selectedSortType)
            { query, sort in
                (query, sort)
            }.filter{ query, sort -> Bool in
                return (query?.characters.count)! > 0
            }.bindTo(viewModel.searchRepositoriesSubject)
            .addDisposableTo(disposeBag)
        

    }
    
    private func tableViewSetup() {
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200.0
        
        tableView.register(UINib(nibName: "SearchResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultsCell")
        
        let items = viewModel.searchedRepositories.observeOn(MainScheduler.instance)
        
        items
            .bindTo(tableView.rx.items(cellIdentifier: "ResultsCell", cellType: SearchResultsTableViewCell.self)) { (row, element, cell) in
                cell.setup(repository: element)
            }
            .addDisposableTo(disposeBag)
        
        tableView.rx.contentOffset.flatMap{ _ in
            self.tableView.isNearBottomEdge(edgeOffset: 20.0)
                ? Observable.just(())
                : Observable.empty()
        }.bindTo(self.viewModel.loadNextSubject).addDisposableTo(self.disposeBag)
        
        tableView
            .rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                self.viewModel.repositoryDetailsTapped(row: indexPath.row)
            }).addDisposableTo(disposeBag)

        tableView
            .rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                self.viewModel.cellSelected(row: indexPath.row)
            })
            .addDisposableTo(disposeBag)
        
    }
}
