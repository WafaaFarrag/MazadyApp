//
//  LanguageCell.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import UIKit

class LanguageCell: UITableViewCell {
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var radioButtonImageView: UIImageView!
    
    func configure(with viewModel: LanguageCellViewModel) {
        languageLabel.text = viewModel.title
        radioButtonImageView.image = viewModel.isSelected ? .selectRadioIcon : .unselectRadioIcon
    }
}
