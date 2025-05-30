//
//  ProductCollectionViewCell.swift
//  MazadyApp
//
//  Created by wafaa farrag on 26/04/2025.
//

import UIKit
import Kingfisher

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
    @IBOutlet weak var bottomSpacerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        daysLabel.text = ""
        hoursLabel.text = ""
        minutesLabel.text = ""
        titleLabel.text = ""
        priceLabel.text = ""
        offerPriceLabel.attributedText = nil
        oldPriceLabel.attributedText = nil
        // Cancel any image download in progress
        productImageView.kf.cancelDownloadTask()
        
        // Reset image properly
        productImageView.image = UIImage(named: "product")
        
        timerStackView.isHidden = true
        containerOfferPriceStackView.isHidden = true
    }
    
    private func setupUI() {
        layer.cornerRadius = 20
        clipsToBounds = true
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 12
        productImageView.clipsToBounds = true
        
        offerPriceLabel.textColor = .blackTextPrimary
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        containerOfferPriceStackView.setContentHuggingPriority(.required, for: .vertical)
        containerOfferPriceStackView.isHidden = true
        
        timerStackView.setContentHuggingPriority(.required, for: .vertical)
        timerStackView.isHidden = true
        
        bottomSpacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    func configure(with product: Product) {
        
        if let url = URL(string: product.image) {
            productImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "product"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ],
                completionHandler: { [weak self] result in
                    guard let self = self else { return }
                    self.productImageView.layer.cornerRadius = 20
                    self.productImageView.clipsToBounds = true
                    
                }
            )
        } else {
            productImageView.image = UIImage(named: "product")
            productImageView.layer.cornerRadius = 20
            productImageView.clipsToBounds = true
        }

        
        titleLabel.text = product.name
        priceLabel.text = "\(product.price) \(product.currency)"
        
        if let offer = product.offer {
            containerOfferPriceStackView.isHidden = false
            let attributeString = NSAttributedString(
                string: "\(product.price) \(product.currency)",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.redSecond
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
        
        daysLabel.text = "\(days)"
        hoursLabel.text = "\(hours)"
        minutesLabel.text = "\(minutes)"
    }
}
