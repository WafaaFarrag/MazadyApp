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
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
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
                self.nameLabel.text = user.name
                self.emailLabel.text = user.email
                if let imageUrl = user.profileImage, let url = URL(string: imageUrl) {
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
