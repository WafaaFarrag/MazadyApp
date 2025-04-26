//
//  TagsCollectionViewCell.swift
//  MazadyApp
//
//  Created by wafaa farrag on 26/04/2025.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.backgroundColor = UIColor.systemGray6
        contentView.clipsToBounds = true

        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configure(with tag: Tag) {
        titleLabel.text = tag.name
    }
}
