//
//  SortViewController.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 01/12/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit
import RxSwift

class SortViewController: UIViewController, UITableViewDelegate {

    // MARK: Outlets
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: Properties
    private let viewModel: SortViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: initialization
    init(viewModel: SortViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: SortViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: Functions
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = viewModel.sortTypes.observeOn(MainScheduler.instance)
        
        items
            .bindTo(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)){ (row, element, cell) in
                cell.textLabel?.text = element
            }
            .addDisposableTo(disposeBag)
        
        tableView
            .rx
            .modelSelected(String.self)
            .bindTo(viewModel.tappedCellObservable)
            .addDisposableTo(disposeBag)
    }

}
