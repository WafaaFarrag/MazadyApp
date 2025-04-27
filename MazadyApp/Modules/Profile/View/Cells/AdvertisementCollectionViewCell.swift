//
//  AdvertisementCollectionViewCell.swift
//  MazadyApp
//
//  Created by wafaa farrag on 26/04/2025.
//

import UIKit

class AdvertisementCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var adImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        adImageView.contentMode = .scaleAspectFill
        adImageView.layer.cornerRadius = 12
        adImageView.clipsToBounds = true
    }

    func configure(with ad: Advertisement) {
        if let url = URL(string: ad.imageURL) {
            adImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "product"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        }
    }
}
