//
//  LPCollectionViewLayout.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-13.
//

import UIKit

protocol LPCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, cellWidth: CGFloat, heightForAtIndexPath: IndexPath) -> CGFloat
}

class LPCollectionViewLayout: UICollectionViewFlowLayout {
    weak var delegate: LPCollectionViewLayoutDelegate?
    
    private var headerLayoutAttributes: UICollectionViewLayoutAttributes?
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 8
    
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
        guard cache.isEmpty, let collectionView = collectionView else { return }

        let headerIndexPath = IndexPath(item: 0, section: 0)
        let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: headerIndexPath)
        headerAttributes.frame = CGRect(x: 0, y: 0, width: contentWidth, height: headerReferenceSize.height)
        headerLayoutAttributes = headerAttributes

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var yOffset: [CGFloat] = .init(repeating: headerReferenceSize.height, count: numberOfColumns)

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let cellHeight = delegate?.collectionView(collectionView, cellWidth: columnWidth, heightForAtIndexPath: indexPath) ?? 180

            let height = cellPadding * 2 + cellHeight

            // Find the column with the smallest current height
            var minColumnHeight = yOffset[0]
            var columnWithMinHeight = 0
            for (index, columnHeight) in yOffset.enumerated() {
                if columnHeight < minColumnHeight {
                    minColumnHeight = columnHeight
                    columnWithMinHeight = index
                }
            }

            let frame = CGRect(x: xOffset[columnWithMinHeight], y: yOffset[columnWithMinHeight], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffset[columnWithMinHeight] = yOffset[columnWithMinHeight] + height
        }
    }

//    override func prepare() {
//        guard cache.isEmpty, let collectionView = collectionView else { return }
//
//        let headerIndexPath = IndexPath(item: 0, section: 0)
//        let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: headerIndexPath)
//        headerAttributes.frame = CGRect(x: 0, y: 0, width: contentWidth, height: headerReferenceSize.height)
//        headerLayoutAttributes = headerAttributes
//
//        let columnWidth = contentWidth / CGFloat(numberOfColumns)
//        var xOffset: [CGFloat] = []
//        for column in 0..<numberOfColumns {
//            xOffset.append(CGFloat(column) * columnWidth)
//        }
//        var column = 0
//        var yOffset: [CGFloat] = .init(repeating: headerReferenceSize.height, count: numberOfColumns)
//
//        for item in 0..<collectionView.numberOfItems(inSection: 0) {
//            let indexPath = IndexPath(item: item, section: 0)
//
//            let cellHeight = delegate?.collectionView(collectionView, cellWidth: columnWidth, heightForAtIndexPath: indexPath) ?? 180
//
//            let height = cellPadding * 2 + cellHeight
//            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
//            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
//
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//            attributes.frame = insetFrame
//            cache.append(attributes)
//
//            contentHeight = max(contentHeight, frame.maxY)
//            yOffset[column] = yOffset[column] + height
//
//            column = column < (numberOfColumns - 1) ? (column + 1) : 0
//        }
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        if let headerAttributes = headerLayoutAttributes, headerAttributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(headerAttributes)
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionView.elementKindSectionHeader {
            return headerLayoutAttributes
        }
        return nil
    }
    
    func clearCache() {
        cache.removeAll()
        contentHeight = 0
    }
    
}
