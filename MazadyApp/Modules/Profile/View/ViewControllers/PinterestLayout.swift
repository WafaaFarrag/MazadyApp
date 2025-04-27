//
//  PinterestLayout.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
    func tagName(for indexPath: IndexPath) -> String
}

class PinterestLayout: UICollectionViewLayout {

    weak var delegate: PinterestLayoutDelegate?

    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }

        cache.removeAll()
        contentHeight = 0

        let numberOfColumns = 3
        let cellPadding: CGFloat = 4
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)

        for section in 0..<collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)

            if section == 0 {
                // Products Section - Pinterest Masonry
                for item in 0..<itemCount {
                    let indexPath = IndexPath(item: item, section: section)
                    let itemHeight = delegate?.collectionView(collectionView, heightForItemAt: indexPath) ?? 180
                    let height = cellPadding * 2 + itemHeight

                    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                    let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)

                    contentHeight = max(contentHeight, frame.maxY)
                    yOffset[column] = yOffset[column] + height

                    column = (column + 1) % numberOfColumns
                }

                let maxYOffset = yOffset.max() ?? 0
                yOffset = .init(repeating: maxYOffset, count: numberOfColumns)

            } else if section == 1 {
                // Ads Section - Full Width
                for item in 0..<itemCount {
                    let indexPath = IndexPath(item: item, section: section)
                    let width = contentWidth
                    let height: CGFloat = 140
                    let frame = CGRect(x: 0, y: contentHeight + 8, width: width, height: height)

                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = frame
                    cache.append(attributes)

                    contentHeight = frame.maxY
                }

            } else if section == 2 {
                // Tags Section - Flexible Tags

                // Insert Top Tags Header
                let headerHeight: CGFloat = 44
                let headerFrame = CGRect(x: 0, y: contentHeight + 8, width: contentWidth, height: headerHeight)
                let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                headerAttributes.frame = headerFrame
                cache.append(headerAttributes)

                var xTagOffset: CGFloat = 16
                var yTagOffset: CGFloat = headerFrame.maxY + 8
                let maxWidth = contentWidth - 32

                for item in 0..<itemCount {
                    let indexPath = IndexPath(item: item, section: section)

                    let tagName = delegate?.tagName(for: indexPath) ?? ""
                    let font = UIFont.systemFont(ofSize: 14)
                    let tagWidth = tagName.size(withAttributes: [.font: font]).width + 32
                    let tagHeight: CGFloat = 40

                    if xTagOffset + tagWidth > maxWidth {
                        xTagOffset = 16
                        yTagOffset += tagHeight + 8
                    }

                    let frame = CGRect(x: xTagOffset, y: yTagOffset, width: tagWidth, height: tagHeight)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = frame
                    cache.append(attributes)

                    xTagOffset += tagWidth + 8
                }

                contentHeight = yTagOffset + 40 + 16
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first { $0.indexPath == indexPath }
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first { $0.indexPath == indexPath && elementKind == UICollectionView.elementKindSectionHeader }
    }
}
