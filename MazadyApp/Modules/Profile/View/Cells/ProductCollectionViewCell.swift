//
//  ProductCollectionViewCell.swift
//  MazadyApp
//
//  Created by wafaa farrag on 26/04/2025.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!
    @IBOutlet weak var timerStackView: UIStackView!
    @IBOutlet weak var containerOfferPriceStackView: UIStackView!
    @IBOutlet weak var lotStartsLabel: UILabel!
    @IBOutlet weak var timerCountersStackView: UIStackView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    

    private func setupUI() {
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        offerPriceLabel.textColor = .red
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping

        // 🔥 Add corner radius to the whole cell
        contentView.layer.cornerRadius = 24
        contentView.layer.masksToBounds = true
    }

    
    func configure(with product: Product) {
        if let url = URL(string: product.image) {
            productImageView.load(url: url)
        }
        
        titleLabel.text = product.name
        priceLabel.text = "\(product.price) \(product.currency)"
        
        if let offer = product.offer {
            containerOfferPriceStackView.isHidden = false
            let attributeString = NSAttributedString(
                string: "\(product.price) \(product.currency)",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.red
                ]
            )
            oldPriceLabel.attributedText = attributeString
            offerPriceLabel.text = "\(offer) \(product.currency)"
        } else {
            containerOfferPriceStackView.isHidden = true
        }
        
        if let secondsLeft = product.endDate {
            timerStackView.isHidden = false
            updateCountdown(secondsLeft: secondsLeft)
        } else {
            timerStackView.isHidden = true
        }
    }

    func updateCountdown(secondsLeft: Double) {
        let totalSeconds = Int(secondsLeft)
        let days = totalSeconds / (24 * 3600)
        let hours = (totalSeconds % (24 * 3600)) / 3600
        let minutes = (totalSeconds % 3600) / 60

        daysLabel.text = "\(days) D"
        hoursLabel.text = "\(hours) H"
        minutesLabel.text = "\(minutes) M"
    }
}
