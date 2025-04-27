//
//  ProductsViewController.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//



import UIKit
import RxSwift
import RxDataSources

class ProductsViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var dataSource: RxCollectionViewSectionedReloadDataSource<ProfileSectionModel>!
    
    var viewModel: ProfileViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        collectionView.delegate = self

        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        collectionView.register(UINib(nibName: "AdvertisementCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdvertisementCollectionViewCell")
        collectionView.register(UINib(nibName: "TagsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagsCollectionViewCell")
        collectionView.register(UINib(nibName: "TagsHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TagsHeaderView")

        dataSource = RxCollectionViewSectionedReloadDataSource<ProfileSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
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
                    cell.configure(with: ad)
                    return cell

                case .tagsSection(let tags):
                    let tag = tags[indexPath.item]
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsCollectionViewCell
                    cell.configure(with: tag)
                    return cell
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                if kind == UICollectionView.elementKindSectionHeader {
                    let section = dataSource.sectionModels[indexPath.section]
                    switch section {
                    case .tagsSection:
                        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TagsHeaderView", for: indexPath) as! TagsHeaderView
                        header.titleLabel.text = "Top Tags"
                        return header
                    default:
                        return UICollectionReusableView()
                    }
                } else {
                    return UICollectionReusableView()
                }
            }
        )

        let layout = PinterestLayout()
        layout.delegate = self
        layout.numberOfColumns = 2 // or 3 depending on your design
        layout.cellPadding = 8

        collectionView.collectionViewLayout = layout
    }

    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            let section = self.dataSource.sectionModels[sectionIndex]
            
            switch section {
            case .productsSection:
                let itemsPerRow: CGFloat = 3
                let columnSpacing: CGFloat = 8
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0 / itemsPerRow),
                    heightDimension: .estimated(200)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: columnSpacing / 2, bottom: 0, trailing: columnSpacing / 2)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(200)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = .zero
                return section
                
            case .adsSection:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(140)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(140)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0)
                section.interGroupSpacing = 8
                return section
                
            case .tagsSection:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(100),
                    heightDimension: .absolute(40)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(200)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                section.interGroupSpacing = 8
                section.orthogonalScrollingBehavior = .none
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(44)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                
                return section
            }
        }
    }
    
    private func bindViewModel() {
        // Simple binding
        Observable.combineLatest(viewModel.products, viewModel.ads, viewModel.tags)
            .map { products, ads, tags -> [ProfileSectionModel] in
                return [
                    .productsSection(items: products),
                    .adsSection(items: ads),
                    .tagsSection(items: tags)
                ]
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegate
extension ProductsViewController: UICollectionViewDelegate {}
extension ProductsViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.sectionModels[indexPath.section]

        switch section {
        case .productsSection(let products):
            let product = products[indexPath.item]
            // Estimate height based on product
            return calculateHeight(for: product)
        case .adsSection:
            return 140 // Banner
        case .tagsSection:
            return 40 // Tag size
        }
    }
    
    private func calculateHeight(for product: Product) -> CGFloat {
        var baseHeight: CGFloat = 200 // basic minimum height

         let title = product.name
         let titleHeight = title.heightWithConstrainedWidth(width: (UIScreen.main.bounds.width / 2) - 24, font: UIFont.systemFont(ofSize: 14))
            baseHeight += titleHeight
        

        if product.offer != nil {
            baseHeight += 20
        }

        if product.endDate != nil {
            baseHeight += 30
        }

        return baseHeight
    }

}
