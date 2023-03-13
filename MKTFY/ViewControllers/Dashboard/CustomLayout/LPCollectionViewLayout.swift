//
//  LPCollectionViewLayout.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-13.
//

import Foundation
import UIKit

protocol LPCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, cellWidth: CGFloat, heightForAtIndexPath: IndexPath)
}

class LPCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: LPCollectionViewLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 8
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // TODO: continue from 1:15:36 of video
}
