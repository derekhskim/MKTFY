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
        
        collectionView.register(CustomViewCollectionViewCell.self, forCellWithReuseIdentifier: "CustomViewCollectionViewCell")
        collectionView.register(CustomTextViewCollectionViewCell.self, forCellWithReuseIdentifier: "CustomTextViewCollectionViewCell")
        collectionView.register(CustomButtonCollectionViewCell.self, forCellWithReuseIdentifier: "CustomButtonCollectionViewCell")
        
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return imageArray.isEmpty ? 0 : (imageArray.count < 3 ? imageArray.count : imageArray.count - 1)
        } else {
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 || indexPath.section == 1 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
                    return UICollectionViewCell()
                }

                cell.photoImageView.gestureRecognizers?.forEach(cell.photoImageView.removeGestureRecognizer)
                
                let isFirstCell = indexPath.section == 0 && imageArray.isEmpty
                let isLastCell = indexPath.section == 1 && indexPath.row == imageArray.count - 1
                let shouldDisplayAddButton = isFirstCell || isLastCell
                
                if shouldDisplayAddButton {
                    cell.photoImageView.image = indexPath.section == 0 ? UIImage(named: "large_add_image_button") : UIImage(named: "small_add_image_button")
                    cell.removeImageButton.isHidden = true
                    cell.photoImageView.isUserInteractionEnabled = true
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadButtonTapped))
                    cell.photoImageView.addGestureRecognizer(tapGesture)
                } else {
                    let imageIndex = indexPath.section == 0 ? 0 : indexPath.row + 1
                    cell.photoImageView.image = imageArray[imageIndex]
                    cell.removeImageButton.isHidden = false
                    cell.photoImageView.isUserInteractionEnabled = false
                }
                
            cell.onRemoveButtonTapped = { [weak self] in
                self?.imageArray.remove(at: indexPath.section == 0 ? 0 : indexPath.row + 1)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            
                return cell
            } else if indexPath.section == 2 {
            if indexPath.row < 7 {
                guard let customViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomViewCollectionViewCell", for: indexPath) as? CustomViewCollectionViewCell else {
                    return UICollectionViewCell()
                }
                if indexPath.row == 0 {
                    customViewCell.view.titleLabel.text = "Product Name"
                    customViewCell.view.inputTextField.placeholder = "Enter your product name"
                    customViewCell.view.inputTextField.backgroundColor = .white
                }
                
                return customViewCell
            } else {
                guard let customButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomButtonCollectionViewCell", for: indexPath) as? CustomButtonCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                if indexPath.row == 7 {
                    customButtonCell.onButtonTapped = { [weak self] in
                        print("Ouch")
                    }
                } else if indexPath.row == 8 {
                    customButtonCell.onButtonTapped = { [weak self] in
                        print("it hurts")
                    }
                }
                
                return customButtonCell
            }
        }
        return UICollectionViewCell()
    }
    
}

extension CreateListingTestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 283)
        } else if indexPath.section == 1 {
            let itemWidth = collectionView.frame.size.width / 3
            return CGSize(width: itemWidth, height: itemWidth)
        } else {
            if indexPath.row < 7 {
                return CGSize(width: collectionView.frame.size.width, height: 80)
            } else {
                return CGSize(width: collectionView.frame.size.width, height: 51)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
