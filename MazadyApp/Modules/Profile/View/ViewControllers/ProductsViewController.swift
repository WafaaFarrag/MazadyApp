//
//  ProductsViewController.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//
// ProductsViewController.swift

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

    private lazy var defaultFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionHeadersPinToVisibleBounds = true
        return layout
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
    }

    // MARK: - Setup
    private func setupCollectionView() {
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        collectionView.setCollectionViewLayout(pinterestLayout, animated: false)

        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        collectionView.register(UINib(nibName: "AdvertisementCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdvertisementCollectionViewCell")
        collectionView.register(UINib(nibName: "TagsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagsCollectionViewCell")
        collectionView.register(UINib(nibName: "TagsHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TagsHeaderView")

        collectionView.delegate = self

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

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = dataSource.sectionModels[indexPath.section]

        switch section {
        case .productsSection:
            let width = (collectionView.bounds.width - 16) / 3
            return CGSize(width: width, height: 250)
        case .adsSection:
            return CGSize(width: collectionView.bounds.width, height: 140)
        case .tagsSection:
            return CGSize(width: 100, height: 40)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if case .tagsSection = dataSource.sectionModels[section] {
            return CGSize(width: collectionView.bounds.width, height: 44)
        }
        return .zero
    }
}

// MARK: - PinterestLayoutDelegate
extension ProductsViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.sectionModels[indexPath.section]

        switch section {
        case .productsSection(let products):
            let product = products[indexPath.item]
            var baseHeight: CGFloat = 200
            let titleHeight = product.name.heightWithConstrainedWidth(width: (UIScreen.main.bounds.width / 3) - 24, font: UIFont.systemFont(ofSize: 14))
            baseHeight += titleHeight

            if product.offer != nil {
                baseHeight += 20
            }

            if product.endDate != nil {
                baseHeight += 30
            }

            return baseHeight
        default:
            return 180
        }
    }

    func tagName(for indexPath: IndexPath) -> String {
        let section = dataSource.sectionModels[indexPath.section]
        switch section {
        case .tagsSection(let tags):
            return tags[indexPath.item].name
        default:
            return ""
        }
    }
}
