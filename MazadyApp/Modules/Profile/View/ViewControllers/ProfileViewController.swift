//
//  ProfileViewController.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

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
    @IBOutlet weak var containerCollectionView: UICollectionView!
    // MARK: - Properties
    var viewModel: ProfileViewModel! // injected later
    private let disposeBag = DisposeBag()
    private var dataSource: RxCollectionViewSectionedReloadDataSource<ProfileSectionModel>!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
        viewModel.loadAllData()
    }
        

        // MARK: - Setup
    func configure(with viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupCollectionView() {
        containerCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        containerCollectionView.register(UINib(nibName: "AdCell", bundle: nil), forCellWithReuseIdentifier: "AdCell")
        containerCollectionView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        
        dataSource = RxCollectionViewSectionedReloadDataSource<ProfileSectionModel>(
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
                guard self != nil else { return UICollectionViewCell() }
                
                let section = dataSource.sectionModels[indexPath.section]
                
                switch section {
                case .productsSection(let products):
                    let product = products[indexPath.item]
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
                    cell.configure(with: product)
                    return cell
                case .adsSection(let ads):
                    let ad = ads[indexPath.item]
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertisementCollectionViewCell", for: indexPath) as! AdvertisementCollectionViewCell
                   // cell.configure(with: ad)
                    return cell
                case .tagsSection(let tags):
                    let tag = tags[indexPath.item]
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsCollectionViewCell
                   // cell.configure(with: tag)
                    return cell
                }
            }
        )
        
        containerCollectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return layout
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
        
        Observable.combineLatest(viewModel.products, viewModel.ads, viewModel.tags)
            .map { products, ads, tags -> [ProfileSectionModel] in
                return [
                    .productsSection(items: products),
                    .adsSection(items: ads),
                    .tagsSection(items: tags)
                ]
            }
            .bind(to: containerCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let section = dataSource.sectionModels[indexPath.section]
        
        switch section {
        case .productsSection:
            let itemWidth = (width - 24) / 2 // 2 columns + spacing
            return CGSize(width: itemWidth, height: itemWidth + 80)
        case .adsSection:
            return CGSize(width: width - 16, height: 180)
        case .tagsSection:
            return CGSize(width: 100, height: 40)
        }
    }
}

