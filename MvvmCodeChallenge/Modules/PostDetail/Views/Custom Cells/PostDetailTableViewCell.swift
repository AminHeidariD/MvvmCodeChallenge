//
//  PostDetailTableViewCell.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/14/22.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {
    static let cellIdentifier = "PostDetailTableViewCell"
    
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var bodyLabel: UILabel!
    
    var model: PostDetailModel? {
        didSet {
            authorLabel.text = model?.author
            bodyLabel.text = model?.body
        }
    }
}
