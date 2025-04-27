
//
//  ProfileViewController.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var productsButton: UIButton!
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var underlineLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    @IBAction func searchBtnAction(_ sender: Any) {
        guard let keyword = searchTextField.text, !keyword.isEmpty else { return }
        viewModel.searchProducts(by: keyword)
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func tabButtonTapped(_ sender: UIButton) {
        let newTabIndex = sender.tag
        if selectedTabIndex != newTabIndex {
            displayCurrentTab(newTabIndex)
            updateTabsUI(to: newTabIndex)
            selectedTabIndex = newTabIndex
        }
    }
    
    // MARK: - Properties
    var viewModel: ProfileViewModel! // injected
    private let disposeBag = DisposeBag()
    private var selectedTabIndex = 0
    private var currentChildViewController: UIViewController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.loadAllData()
    }
    
    // MARK: - Setup
    func configure(with viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupView() {
        searchTextField.delegate = self
        setupSearchFieldListener()
        displayCurrentTab(0) // Default first tab
        updateTabsUI(to: 0)
    }
    
    // MARK: - Child ViewControllers Handling
    private func displayCurrentTab(_ tabIndex: Int) {
        let newViewController: UIViewController
        switch tabIndex {
        case 0:
            let productsVC = instantiateViewController(named: "ProductsViewController") as! ProductsViewController
            productsVC.viewModel = self.viewModel
            newViewController = productsVC
        case 1:
            newViewController = instantiateViewController(named: "ReviewsViewController")
        case 2:
            newViewController = instantiateViewController(named: "FollowersViewController")
        default:
            return
        }
        
        guard let currentVC = currentChildViewController else {
            // First time
            addChild(newViewController)
            containerView.addSubview(newViewController.view)
            newViewController.view.frame = containerView.bounds
            newViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            newViewController.didMove(toParent: self)
            currentChildViewController = newViewController
            return
        }
        
        // Animate swap
        let isForward = tabIndex > selectedTabIndex
        addChild(newViewController)
        newViewController.view.frame = containerView.bounds.offsetBy(dx: isForward ? containerView.frame.width : -containerView.frame.width, dy: 0)
        containerView.addSubview(newViewController.view)
        
        UIView.animate(withDuration: 0.3, animations: {
            newViewController.view.frame = self.containerView.bounds
            currentVC.view.frame = self.containerView.bounds.offsetBy(dx: isForward ? -self.containerView.frame.width : self.containerView.frame.width, dy: 0)
        }, completion: { _ in
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
            
            newViewController.didMove(toParent: self)
            self.currentChildViewController = newViewController
        })
    }
    
    private func updateTabsUI(to tabIndex: Int) {
        [productsButton, reviewsButton, followersButton].enumerated().forEach { index, button in
            button.setTitleColor(index == tabIndex ? .redPrimary : .gray, for: .normal)
        }
        
        let buttonWidth = view.frame.width / 3
        underlineLeadingConstraint.constant = CGFloat(tabIndex) * buttonWidth
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func instantiateViewController(named name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.user
            .asDriver()
            .drive(onNext: { [weak self] user in
                guard let self = self, let user = user else { return }
                self.nameLabel.text = user.name
                self.userNameLabel.text = user.userName
                self.locationLabel.text = "\(user.countryName), \(user.cityName)"
                self.followersCountLabel.text = "\(user.followersCount)"
                self.followingCountLabel.text = "\(user.followingCount)"
                
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

// MARK: - SearchField
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = textField.text, !keyword.isEmpty else { return true }
        viewModel.searchProducts(by: keyword)
        textField.resignFirstResponder()
        return true
    }
    
    private func setupSearchFieldListener() {
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            viewModel.loadProducts()
        }
    }
}
