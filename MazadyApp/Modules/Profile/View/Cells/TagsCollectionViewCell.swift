//
//  TagsCollectionViewCell.swift
//  MazadyApp
//
//  Created by wafaa farrag on 26/04/2025.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    

    
    private func setupUI() {
        
        contentView.layer.cornerRadius = 9
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.lightGray2.cgColor
        contentView.clipsToBounds = true
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configure(with tag: Tag) {
        titleLabel.text = tag.name
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? UIColor.orange.cgColor : UIColor.lightGray.cgColor
            contentView.backgroundColor = isSelected ? UIColor.orange.withAlphaComponent(0.1) : .white
            titleLabel.textColor = isSelected ? .orangeSecond : .blackTextPrimary
            containerView.backgroundColor = isSelected ? .orangePrimary : .white
        }
    }
}
