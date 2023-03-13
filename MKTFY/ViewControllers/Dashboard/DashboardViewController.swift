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
        addShadows()
        
        searchTextField.borderStyle = .none
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
//
//        collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ItemCollectionViewCell")
        
    }
    
}

// MARK: - Extension
//extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return vm.items.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
//
//        let item = vm.items[indexPath.row]
//        cell.updateData(data: item)
//
//        return cell
//    }
//}

extension DashboardViewController {
    
    func addShadows() {
        horizontalView.layer.shadowColor = UIColor.black.cgColor
        horizontalView.layer.shadowOpacity = 1
        horizontalView.layer.shadowOffset = .zero
        horizontalView.layer.shadowRadius = 10

    }
    
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
