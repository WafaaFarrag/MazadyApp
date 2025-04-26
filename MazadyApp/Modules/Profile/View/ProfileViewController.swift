//
//  ProfileViewController.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation
import UIKit
import RxSwift

class ProfileViewController: BaseViewController {
    // MARK: - Outlets
    //@IBOutlet weak var profileTabsView: Segmentio!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    // MARK: - Properties
    var viewModel: ProfileViewModel! // injected later
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        bindViewModel()
        viewModel.loadUserProfile()
    }
    
    // MARK: - Setup
    func configure(with viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.user
            .asDriver()
            .drive(onNext: { [weak self] user in
                guard let self = self, let user = user else { return }
                nameLabel.text = user.name
                userNameLabel.text = user.userName
                locationLabel.text = "\(user.countryName), \(user.cityName )"
                followersCountLabel.text = "\(user.followersCount)"
                followingCountLabel.text = "\(user.followingCount)"
                if let imageUrl = user.image, let url = URL(string: imageUrl) {
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url) {
                            DispatchQueue.main.async {
                                self.profileImageView.image = UIImage(data: data)
                            }
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}




