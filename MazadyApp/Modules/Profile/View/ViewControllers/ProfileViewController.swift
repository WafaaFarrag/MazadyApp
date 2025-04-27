
//
//  ProfileViewController.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//
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
    @IBOutlet weak var searchBtnBackgroundView: UIView!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var productsButton: UIButton!
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var underlineLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchIconImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    // MARK: - Properties
    var viewModel: ProfileViewModel!
    private let disposeBag = DisposeBag()
    private var currentChildViewController: UIViewController?
    
    private var currentLanguageName: String {
        let currentLanguage = LanguageManager.shared.currentLanguage
        switch currentLanguage {
        case .english:
            return "English"
        case .arabic:
            return "العربية"
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.loadAllData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .languageDidChange, object: nil)
    }
    
    func configure(with viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Setup
    private func setupView() {
        updateTexts()
        
        if UIView.userInterfaceLayoutDirection(for: view.semanticContentAttribute) == .rightToLeft {
            settingsButton.semanticContentAttribute = .forceRightToLeft
            settingsButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            searchIconImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            settingsButton.semanticContentAttribute = .forceLeftToRight
            settingsButton.imageView?.transform = .identity
            searchIconImageView.transform = .identity
        }

        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageDidChange, object: nil)
        searchTextField.delegate = self
        setupSearchFieldListener()
    }
    
    @objc private func languageDidChange() {
        updateTexts()
    }
    
    private func updateTexts() {
        languageLabel.text = currentLanguageName
        searchTextField.placeholder = "searchPlaceholder".localized()
        productsButton.setTitle("productsLabel".localized(), for: .normal)
        reviewsButton.setTitle("reviewsLabel".localized(), for: .normal)
        followersButton.setTitle("followersLabel".localized(), for: .normal)
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

                followersCountLabel.text = user.followersCount.localizedString()
                followingCountLabel.text = user.followingCount.localizedString()
                
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
        
        viewModel.selectedTabIndex
            .asDriver()
            .drive(onNext: { [weak self] index in
                guard let self = self else { return }
                self.displayCurrentTab(index)
                self.updateTabsUI(to: index)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Actions
    @IBAction func tabButtonTapped(_ sender: UIButton) {
        viewModel.selectedTabIndex.accept(sender.tag)
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
        guard let keyword = searchTextField.text, !keyword.isEmpty else { return }
        viewModel.searchProducts(by: keyword)
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        presentLanguageSheet()
    }
    
    // MARK: - Child VCs Handling
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
        
        if let currentVC = currentChildViewController {
            transition(from: currentVC, to: newViewController)
        } else {
            addChild(newViewController)
            containerView.addSubview(newViewController.view)
            newViewController.view.frame = containerView.bounds
            newViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            newViewController.didMove(toParent: self)
            currentChildViewController = newViewController
        }
    }
    
    private func transition(from oldVC: UIViewController, to newVC: UIViewController) {
        addChild(newVC)
        newVC.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.width, dy: 0)
        containerView.addSubview(newVC.view)
        
        UIView.animate(withDuration: 0.3, animations: {
            newVC.view.frame = self.containerView.bounds
            oldVC.view.frame = self.containerView.bounds.offsetBy(dx: -self.containerView.frame.width, dy: 0)
        }, completion: { _ in
            oldVC.willMove(toParent: nil)
            oldVC.view.removeFromSuperview()
            oldVC.removeFromParent()
            newVC.didMove(toParent: self)
            self.currentChildViewController = newVC
        })
    }
    
    private func instantiateViewController(named name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    private func updateTabsUI(to tabIndex: Int) {
        [productsButton, reviewsButton, followersButton].enumerated().forEach { index, button in
            button.setTitleColor(index == tabIndex ? .redPrimary : .gray, for: .normal)
        }
        
        let buttonWidth = view.frame.width / 3
        let padding: CGFloat = 20
        let isRTL = UIView.userInterfaceLayoutDirection(for: view.semanticContentAttribute) == .rightToLeft

        var leading: CGFloat
        if isRTL {
            leading = (view.frame.width - (CGFloat(tabIndex + 1) * buttonWidth)) + (tabIndex == 2 ? -padding : 0)
        } else {
            leading = CGFloat(tabIndex) * buttonWidth + (tabIndex == 0 ? padding : 0)
        }

        underlineLeadingConstraint.constant = leading
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }

        
        underlineLeadingConstraint.constant = leading
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func presentLanguageSheet() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let languageVC = storyboard.instantiateViewController(withIdentifier: "LanguageSelectionViewController") as? LanguageSelectionViewController else {
            return
        }
        
        if #available(iOS 15.0, *) {
            if let sheet = languageVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 40
            }
            present(languageVC, animated: true)
        } else {
            languageVC.modalPresentationStyle = .pageSheet
            present(languageVC, animated: true)
        }
    }
}

// MARK: - Search TextField Handling
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
        let text = textField.text ?? ""
        
        if viewModel.isSearchTextValid(text) {
            searchBtnBackgroundView.backgroundColor = .redPrimary
        } else {
            searchBtnBackgroundView.backgroundColor = .dimmedRed
        }
        
        if text.isEmpty {
            viewModel.loadProducts()
        }
    }
}
