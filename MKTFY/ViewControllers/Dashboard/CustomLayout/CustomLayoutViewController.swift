//
//  CustomLayoutViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-13.
//

import UIKit

class CustomLayoutViewController: UIViewController {
    
    let vm = FlowLayoutViewModel()
    let leftPadding: CGFloat = 8
    let rightPadding: CGFloat = 8
    let width = UIScreen.main.bounds.width
    let height: CGFloat = 270

    // MARK: - @IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ItemCollectionViewCell")
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: leftPadding, bottom: 8, right: rightPadding)
        layout.itemSize = CGSize(width: width / 2 - leftPadding - rightPadding, height: height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        layout.headerReferenceSize = CGSize(width: width, height: 44)
        collectionView.collectionViewLayout = layout
    }
}

// MARK: - Extension
extension CustomLayoutViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell

        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        
        let item = vm.items[indexPath.row]
        cell.updateData(data: item)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath)
        
        return cell
    }
}
