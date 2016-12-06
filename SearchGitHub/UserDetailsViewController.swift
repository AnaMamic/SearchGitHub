//
//  UserDetailsViewController.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 06/12/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit
import RxSwift

class UserDetailsViewController: UIViewController {

    // MARK: Properties
    private let viewModel: UserDetailsViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: Outlets
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var login: UILabel!
    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var company: UILabel!
    @IBOutlet weak private var blog: UILabel!
    @IBOutlet weak private var email: UILabel!
    @IBOutlet weak private var publicRepos: UILabel!
    @IBOutlet weak private var followers: UILabel!
    @IBOutlet weak private var following: UILabel!
    
    init(viewModel: UserDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: UserDetailsViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.user.subscribe(onNext: { _ in self.setupData()}).addDisposableTo(disposeBag)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "See more", style: .plain, target: self, action:  #selector(seeMore))
    }
    
    // MARK: functions
    func setupData() {
        image.image = viewModel.image()
        login.text = viewModel.login()
        name.text = viewModel.name()
        company.text = viewModel.company()
        blog.text = viewModel.blog()
        email.text = viewModel.email()
        publicRepos.text = viewModel.publicRepos()
        followers.text = viewModel.followers()
        following.text = viewModel.following()
    }
    
    func seeMore() {
        viewModel.seeMoreTapped()
    }

    
}
