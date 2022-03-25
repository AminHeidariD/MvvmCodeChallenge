//
//  CommentTableViewCell.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/14/22.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    static let cellIdentifier = "CommentTableViewCell"
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var bodyLabel: UILabel!
    
    var comment: Comment? {
        didSet {
            nameLabel.text = comment?.name
            bodyLabel.text = comment?.body
        }
    }
}
