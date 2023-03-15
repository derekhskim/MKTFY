//
//  DashboardViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/21.
//

import UIKit

class DashboardViewController: MainViewController, DashboardStoryboard {
    
    weak var coordinator: MainCoordinator?
    let vm = FlowLayoutViewModel()
    let leftPadding: CGFloat = 8
    let rightPadding: CGFloat = 8
    let width = UIScreen.main.bounds.width
    let height: CGFloat = 270

    // MARK: - @IBOutlet
    @IBOutlet weak var navigationWhiteBackgroundView: UIView!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var horizontalView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - @IBAction
    
    
    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationWhiteBackgroundView.layer.cornerRadius = 10
        navigationWhiteBackgroundView.clipsToBounds = true
        
        menuButton()
        horizontalDropShadow()
        floatingButton()
        
        searchTextField.borderStyle = .none
        
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ItemCollectionViewCell")
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")
        
        let layout = LPCollectionViewLayout()
        layout.delegate = self
        layout.headerReferenceSize = CGSize(width: width, height: 44)
        collectionView.collectionViewLayout = layout

//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 8, left: leftPadding, bottom: 8, right: rightPadding)
//        layout.itemSize = CGSize(width: width / 2 - leftPadding - rightPadding, height: height)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 8
//        layout.headerReferenceSize = CGSize(width: width, height: 44)
//        collectionView.collectionViewLayout = layout
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 64 {
            
        }
    }
    
    // TODO: Drop Shdoaw is only appearing on each side (left/right)
    func horizontalDropShadow() {
        horizontalView.layer.borderWidth = 0
        horizontalView.layer.shadowColor = UIColor.black.cgColor
        horizontalView.layer.shadowOffset = CGSize(width: 0, height: 0)
        horizontalView.layer.shadowRadius = 5
        horizontalView.layer.shadowOpacity = 0.5
        horizontalView.layer.masksToBounds = false
    }
    
    func floatingButton() {
        let image = UIImage(systemName: "plus.circle")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Create Listing"
        configuration.image = image
        configuration.attributedTitle?.font = UIFont(name: "OpenSans", size: 14)
        configuration.attributedTitle?.foregroundColor = .white
        configuration.background.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
        configuration.imagePadding = 10
        configuration.image?.withTintColor(.white, renderingMode: .alwaysTemplate)
        configuration.cornerStyle = .large
        
        let floatingButton = UIButton(configuration: configuration)
        
        view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            floatingButton.widthAnchor.constraint(equalToConstant: 165),
            floatingButton.heightAnchor.constraint(equalToConstant: 50),
            floatingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10)
        ])
        
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
    }
    
    @objc func floatingButtonTapped() {
        coordinator?.presentCreateListingVC()
    }
}

// MARK: - Extension
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: \(indexPath)")
    }
}

extension DashboardViewController {
    func menuButton() {
        let menuTapped = UITapGestureRecognizer(target: self, action: #selector(menuButtonTapped))
        menuImageView.addGestureRecognizer(menuTapped)
        menuImageView.isUserInteractionEnabled = true
    }
    
    @objc func menuButtonTapped() {
        coordinator?.goToDashboardMenuVC()
    }
    
    @objc func searchButtonTapped() {
        
    }
}

extension DashboardViewController: LPCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, cellWidth: CGFloat, heightForAtIndexPath: IndexPath) -> CGFloat {
        
        let height = vm.items[heightForAtIndexPath.row].height(cellWidth: cellWidth)
        return height
        
    }
}
