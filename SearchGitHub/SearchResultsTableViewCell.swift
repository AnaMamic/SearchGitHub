//
//  SearchResultsTableViewCell.swift
//  SearchGitHub
//
//  Created by Ana Mamic on 30/11/16.
//  Copyright © 2016 Ana Mamic. All rights reserved.
//

import UIKit
import RxSwift

class SearchResultsTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberOfWatchers: UILabel!
    @IBOutlet weak var numberOfIssues: UILabel!
    @IBOutlet weak var numberOfForks: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    func setup(repository: Repository) {
        nameLabel.text = repository.name
        numberOfWatchers.text = repository.numberOfWatchers
        numberOfForks.text = repository.numberOfForks
        numberOfIssues.text = repository.numberOfIssues
        username.text = repository.owner.login
        thumbnailImage.image = ImageService.generateThumbnail(image: repository.owner.image, width: 90, height: 100)
        self.accessoryType = UITableViewCellAccessoryType.detailButton
        
    }
    
}
