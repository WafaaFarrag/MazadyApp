//
//  PinterestLayout.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, numberOfColumnsInSection section: Int) -> Int
}

class PinterestLayout: UICollectionViewLayout {

    weak var delegate: PinterestLayoutDelegate?

    var cellPadding: CGFloat = 8

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

        var yOffset: [CGFloat] = []

        for section in 0..<collectionView.numberOfSections {
            let columnCount = delegate?.collectionView(collectionView, numberOfColumnsInSection: section) ?? 2
            let columnWidth = contentWidth / CGFloat(columnCount)

            var xOffset: [CGFloat] = []
            for column in 0..<columnCount {
                xOffset.append(CGFloat(column) * columnWidth)
            }

            if yOffset.count != columnCount {
                yOffset = Array(repeating: yOffset.max() ?? 0, count: columnCount)
            }

            var currentColumn = 0
            let numberOfItems = collectionView.numberOfItems(inSection: section)

            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                let itemHeight = delegate?.collectionView(collectionView, heightForItemAt: indexPath) ?? 180
                let height = cellPadding * 2 + itemHeight

                let frame = CGRect(x: xOffset[currentColumn], y: yOffset[currentColumn], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)

                contentHeight = max(contentHeight, frame.maxY)
                yOffset[currentColumn] = yOffset[currentColumn] + height

                currentColumn = (currentColumn + 1) % columnCount
            }

            let maxYOffset = yOffset.max() ?? 0
            yOffset = Array(repeating: maxYOffset, count: columnCount)
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
        return cache.first(where: { $0.indexPath == indexPath })
    }
}
