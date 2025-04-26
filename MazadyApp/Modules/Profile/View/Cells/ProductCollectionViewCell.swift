//
//  ProductCollectionViewCell.swift
//  MazadyApp
//
//  Created by wafaa farrag on 26/04/2025.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!
    @IBOutlet weak var timerStackView: UIStackView!
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
        productImageView.layer.cornerRadius = 12
        productImageView.clipsToBounds = true
        offerPriceLabel.textColor = .red
    }
    
    
    func configure(with product: Product) {
        // Set image
        if let url = URL(string: product.imageURL) {
            productImageView.load(url: url)
        }
        
        titleLabel.text = product.name
        priceLabel.text = "\(product.price) EGP"
        
        // Handle Old Price (special label)
        if let oldPriceText = product.specialLabel, !oldPriceText.isEmpty {
            offerPriceLabel.isHidden = false
            let attributeString = NSAttributedString(
                string: oldPriceText,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.red
                ]
            )
            offerPriceLabel.attributedText = attributeString
        } else {
            offerPriceLabel.isHidden = true
        }
        
        // Handle Countdown
        if let endDateString = product.endDate, let seconds = Double(endDateString) {
            timerStackView.isHidden = false
            updateCountdown(secondsLeft: seconds)
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
