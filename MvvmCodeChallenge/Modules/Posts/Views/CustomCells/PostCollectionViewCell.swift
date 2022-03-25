//
//  PostCollectionViewCell.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/14/22.
//

import Foundation
import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "PostCollectionViewCell"
    
    @IBOutlet private var titleLabel: UILabel!
    
    var viewModel: PostCellViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
        }
    }
}
