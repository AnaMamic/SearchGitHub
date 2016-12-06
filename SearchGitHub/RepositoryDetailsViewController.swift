//
//  RepositoryDetailsViewController.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 06/12/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit

class RepositoryDetailsViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var watchers: UILabel!
    @IBOutlet weak private var forks: UILabel!
    @IBOutlet weak private var issues: UILabel!
    @IBOutlet weak private var score: UILabel!
    @IBOutlet weak private var language: UILabel!
    @IBOutlet weak private var createdAt: UILabel!
    @IBOutlet weak private var updatedAt: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    // MARK: Properties
    private let viewModel: RepositoryDetailsViewModel
    
    init(viewModel: RepositoryDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: RepositoryDetailsViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        
        let webButton = UIBarButtonItem(title: "See more", style: .plain, target: self, action: #selector(seeMore))
        let ownerButton = UIBarButtonItem(title: "Owner", style: .plain, target: self, action: #selector(seeOwner))
        
        navigationItem.rightBarButtonItems = [webButton, ownerButton]
    }
    
    // MARK: Functions
    private func setupData() {
        name.text = viewModel.name()
        watchers.text = viewModel.watchers()
        forks.text = viewModel.forks()
        issues.text = viewModel.issues()
        score.text = viewModel.score()
        language.text = viewModel.language()
        createdAt.text = viewModel.createdAt()
        updatedAt.text = viewModel.updatedAt()
        descriptionLabel.text = viewModel.description()
    }
        
    func seeMore() {
            viewModel.seeMoreTapped()
    }
    
    func seeOwner() {
        viewModel.seeOwnerTapped()
    }

}
