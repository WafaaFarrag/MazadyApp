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
        layout.numberOfColumns = 3
        layout.cellPadding = 8

        collectionView.collectionViewLayout = layout
    }

    private func bindViewModel() {
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
extension ProductsViewController: UICollectionViewDelegate { }

// MARK: - PinterestLayoutDelegate
extension ProductsViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.sectionModels[indexPath.section]

        switch section {
        case .productsSection(let products):
            let product = products[indexPath.item]
            return calculateProductHeight(for: product)

        case .adsSection:
            return 140 // Banner height

        case .tagsSection(let tags):
            let tag = tags[indexPath.item]
            return 40 // Fixed tag cell height
        }
    }

    private func calculateProductHeight(for product: Product) -> CGFloat {
        var baseHeight: CGFloat = 200
        let title = product.name
        let titleHeight = title.heightWithConstrainedWidth(width: (UIScreen.main.bounds.width / 3) - 24, font: UIFont.systemFont(ofSize: 14))
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


