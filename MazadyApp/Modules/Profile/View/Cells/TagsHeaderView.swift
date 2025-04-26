//
//  TagsHeaderView.swift
//  MazadyApp
//
//  Created by wafaa farrag on 26/04/2025.
//

import UIKit

class TagsHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
    }
}
