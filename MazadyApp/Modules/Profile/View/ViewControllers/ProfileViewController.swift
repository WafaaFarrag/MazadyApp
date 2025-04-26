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
        viewModel.loadAllData()
        setupCollectionView()
        bindViewModel()
        
    }
    
    
    // MARK: - Setup
    func configure(with viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    private func setupCollectionView() {
       // containerCollectionView.delegate = self
        
        // 1. Register cells
        containerCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        containerCollectionView.register(UINib(nibName: "AdvertisementCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdvertisementCollectionViewCell")
        containerCollectionView.register(UINib(nibName: "TagsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagsCollectionViewCell")
        
        // 2. Setup Data Source
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
        
        // 3. Setup Self-Sizing Layout
        containerCollectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            let section = self.dataSource.sectionModels[sectionIndex]

            switch section {
            case .productsSection:
                let spacing: CGFloat = 8
                let itemsPerRow: CGFloat = 3

                // Item
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(200)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                // Group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(200)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: Int(itemsPerRow)
                )
                group.interItemSpacing = .fixed(spacing)

                // Section
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)

                return section

            case .adsSection:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(180)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(180)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)

                return section

            case .tagsSection:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(100),
                    heightDimension: .absolute(40)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(40)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                section.orthogonalScrollingBehavior = .continuous

                return section
            }
        }
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



//extension ProfileViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let width = collectionView.frame.width
//        let section = dataSource.sectionModels[indexPath.section]
//
//        switch section {
//        case .productsSection:
//            let spacing: CGFloat = 16
//            let itemsPerRow: CGFloat = 3
//            let totalSpacing = spacing * (itemsPerRow + 1)
//            let itemWidth = (width - totalSpacing) / itemsPerRow
//
//            // ✅ FIX: width controlled, height zero to allow self-sizing
//            return CGSize(width: itemWidth, height: 0)
//            
//        case .adsSection:
//            return CGSize(width: width - 32, height: 180)
//            
//        case .tagsSection:
//            return CGSize(width: 100, height: 40)
//        }
//    }
//}
