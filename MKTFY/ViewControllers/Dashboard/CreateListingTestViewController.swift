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
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        
        collectionView.reloadData()
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
            return 1
        } else {
            return imageArray.isEmpty ? 0 : (imageArray.count < 3 ? imageArray.count : imageArray.count - 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        cell.photoImageView.gestureRecognizers?.forEach(cell.photoImageView.removeGestureRecognizer)
        
        if indexPath.section == 0 {
            if imageArray.isEmpty {
                cell.photoImageView.image = UIImage(systemName: "plus")
                cell.removeImageButton.isHidden = true
                cell.photoImageView.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadButtonTapped))
                cell.photoImageView.addGestureRecognizer(tapGesture)
            } else {
                cell.photoImageView.image = imageArray.first
                cell.removeImageButton.isHidden = false
                cell.photoImageView.isUserInteractionEnabled = false
            }
        } else {
            if indexPath.row < imageArray.count - 1 {
                cell.photoImageView.image = imageArray[indexPath.row + 1]
                cell.removeImageButton.isHidden = false
                cell.photoImageView.isUserInteractionEnabled = false
            } else {
                cell.photoImageView.image = UIImage(systemName: "plus")
                cell.removeImageButton.isHidden = true
                cell.photoImageView.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadButtonTapped))
                cell.photoImageView.addGestureRecognizer(tapGesture)
            }
        }
        
        cell.photoImageView.contentMode = .scaleAspectFill
        
        cell.onRemoveButtonTapped = { [weak self] in
            self?.imageArray.remove(at: indexPath.section == 0 ? 0 : indexPath.row + 1)
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
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
            let itemWidth = collectionView.frame.size.width / 3
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
