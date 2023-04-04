//
//  CreateListingTestViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-04.
//

import PhotosUI
import UIKit

class CreateListingTestViewController: MainViewController, DashboardStoryboard {
    
    var imageArray = [UIImage]()
    var plusButton: UIBarButtonItem!
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        
        plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(uploadButtonTapped))
        plusButton.tintColor = UIColor.appColor(LPColor.LightestPurple)
        self.navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc private func uploadButtonTapped() {
        var config = PHPickerConfiguration()
        if imageArray.count == 2 {
            config.selectionLimit = 1
        } else if imageArray.count == 1 {
            config.selectionLimit = 2
        } else if imageArray.count == 0 {
            config.selectionLimit = 3
        }
        
        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.delegate = self
        self.present(phPickerVC, animated: true)
    }
    
    func updatePlusButtonState() {
        plusButton.isEnabled = imageArray.count < 3
    }
}

extension CreateListingTestViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    print(image)
                    self.imageArray.append(image)
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.backgroundView.layer.cornerRadius = 0
                    self.backgroundView.clipsToBounds = false
                    self.updatePlusButtonState()
                }
            }
        }
    }
}

extension CreateListingTestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return min(imageArray.count, 1)
        } else {
            return max(imageArray.count - 1, 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.section == 0 {
            cell.photoImageView.image = imageArray.first
        } else {
            cell.photoImageView.image = imageArray[indexPath.row + 1]
        }
        
        cell.onRemoveButtonTapped = { [weak self] in
            self?.imageArray.remove(at: indexPath.section == 0 ? 0 : indexPath.row + 1)
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.updatePlusButtonState()
            }
        }
        
        return cell
    }
    
}

extension CreateListingTestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 283)
        } else {
            return CGSize(width: collectionView.frame.size.width / 3, height: collectionView.frame.size.height / 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
