//
//  CreateListingViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-04.
//

import PhotosUI
import UIKit

class CreateListingViewController: MainViewController, DashboardStoryboard, UITextViewDelegate {
    
    var imageArray = [UIImage]()
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        
        collectionView.register(CustomViewCollectionViewCell.self, forCellWithReuseIdentifier: "CustomViewCollectionViewCell")
        collectionView.register(CustomTextViewCollectionViewCell.self, forCellWithReuseIdentifier: "CustomTextViewCollectionViewCell")
        collectionView.register(CustomButtonCollectionViewCell.self, forCellWithReuseIdentifier: "CustomButtonCollectionViewCell")
        
        collectionView.reloadData()
    }
    
    // MARK: - Function
    @objc private func uploadButtonTapped() {
        var config = PHPickerConfiguration()
        if imageArray.count == 2 {
            config.selectionLimit = 1
        } else if imageArray.count == 1 {
            config.selectionLimit = 2
        } else if imageArray.count == 0 {
            config.selectionLimit = 3
        }
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            // Request photo library access
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                if status == .authorized {
                    // Access granted, present the PHPickerViewController
                    DispatchQueue.main.async {
                        let phPickerVC = PHPickerViewController(configuration: config)
                        phPickerVC.delegate = self
                        self?.present(phPickerVC, animated: true)
                    }
                } else {
                    // Access denied, show an alert to the user
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Photo Library Access Denied", message: "Please grant MKTFY access to your photo library in Settings to upload photos.", purpleButtonTitle: "OK", whiteButtonTitle: "Cancel")
                    }
                }
            }
        } else if status == .authorized {
            // Photo library access granted, present the PHPickerViewController
            let phPickerVC = PHPickerViewController(configuration: config)
            phPickerVC.delegate = self
            self.present(phPickerVC, animated: true)
        } else {
            // Photo library access denied, show an alert to the user
            showAlert(title: "Photo Library Access Denied", message: "Please grant MKTFY access to your photo library in Settings to upload photos.", purpleButtonTitle: "OK", whiteButtonTitle: "Cancel")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.appColor(LPColor.TextGray40) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your message"
            textView.textColor = UIColor.appColor(LPColor.TextGray40)
        }
    }
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

// MARK: - Extension
extension CreateListingViewController: PHPickerViewControllerDelegate {
    
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

extension CreateListingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
            
            cell.plusButton?.isHidden = true
            cell.smallPlusButton?.isHidden = true
            
            if shouldDisplayAddButton {
                if indexPath.section == 0 {
                    cell.plusButton?.isHidden = false
                    cell.smallPlusButton?.isHidden = true
                } else if indexPath.section == 1 {
                    cell.plusButton?.isHidden = true
                    cell.smallPlusButton?.isHidden = false
                } else {
                    cell.plusButton?.isHidden = true
                    cell.smallPlusButton?.isHidden = true
                }
                
                cell.photoImageView.image = UIImage()
                cell.onUploadImageButtonTapped = { [weak self] in
                    self?.uploadButtonTapped()
                }
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
                
                customViewCell.TextFieldView.inputTextField.delegate = self
                
                if indexPath.row == 0 {
                    customViewCell.TextFieldView.titleLabel.text = "Product Name"
                    customViewCell.TextFieldView.inputTextField.placeholder = "Enter your product name"
                    customViewCell.TextFieldView.inputTextField.backgroundColor = .white
                } else if indexPath.row == 1 {
                    guard let customTextViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomTextViewCollectionViewCell", for: indexPath) as? CustomTextViewCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    
                    customTextViewCell.textView.delegate = self
                    
                    customTextViewCell.titleLabel.text = "Description"
                    customTextViewCell.textView.delegate = self
                    customTextViewCell.textView.text = "Enter the details of your product"
                    customTextViewCell.textView.font = UIFont(name: "OpenSans-Regular", size: 14)
                    customTextViewCell.textView.textColor = UIColor.appColor(LPColor.TextGray40)
                    
                    return customTextViewCell
                } else if indexPath.row == 2 {
                    // TODO: Implement dropDownField
                    customViewCell.TextFieldView.titleLabel.text = "Category"
                    customViewCell.TextFieldView.inputTextField.placeholder = "Choose your category"
                    customViewCell.TextFieldView.inputTextField.backgroundColor = .white
                } else if indexPath.row == 3 {
                    // TODO: Implement dropDownField
                    customViewCell.TextFieldView.titleLabel.text = "Condition"
                    customViewCell.TextFieldView.inputTextField.placeholder = "Choose the condition of your item"
                    customViewCell.TextFieldView.inputTextField.backgroundColor = .white
                } else if indexPath.row == 4 {
                    customViewCell.TextFieldView.titleLabel.text = "Price"
                    customViewCell.TextFieldView.inputTextField.placeholder = "Enter your desired price"
                    customViewCell.TextFieldView.inputTextField.backgroundColor = .white
                } else if indexPath.row == 5 {
                    customViewCell.TextFieldView.titleLabel.text = "Address"
                    customViewCell.TextFieldView.inputTextField.placeholder = "Enter your address"
                    customViewCell.TextFieldView.inputTextField.backgroundColor = .white
                } else if indexPath.row == 6 {
                    // TODO: Implement dropDownField
                    customViewCell.TextFieldView.titleLabel.text = "City"
                    customViewCell.TextFieldView.inputTextField.placeholder = "Choose your city"
                    customViewCell.TextFieldView.inputTextField.backgroundColor = .white
                }
                
                return customViewCell
            } else {
                guard let customButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomButtonCollectionViewCell", for: indexPath) as? CustomButtonCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                if indexPath.row == 7 {
                    customButtonCell.button.setTitle("Publish Listing", for: .normal)
                    customButtonCell.button.setTitleColor(UIColor.appColor(LPColor.VoidWhite), for: .normal)
                    customButtonCell.button.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
                    
                    customButtonCell.onButtonTapped = { [weak self] in
                        print("Publish Listing Button Tapped")
                        
                        let images: [UIImage] = self!.imageArray
                        let uploadImageEndpoint = UploadImageEndpoint(images: images)
                        
                        NetworkManager.shared.request(endpoint: uploadImageEndpoint){ (result: Result<[ImageResponse], Error>) in
                            switch result {
                            case .success(let imageResponse):
                                let imageIDs = imageResponse.map {$0.id}
                                DispatchQueue.main.async {
                                    guard let productNameCell = self?.collectionView.cellForItem(at: IndexPath(row: 0, section: 2)) as? CustomViewCollectionViewCell,
                                          let descriptionCell = self?.collectionView.cellForItem(at: IndexPath(row: 1, section: 2)) as? CustomTextViewCollectionViewCell,
                                          let categoryCell = self?.collectionView.cellForItem(at: IndexPath(row: 2, section: 2)) as? CustomViewCollectionViewCell,
                                          let conditionCell = self?.collectionView.cellForItem(at: IndexPath(row: 3, section: 2)) as? CustomViewCollectionViewCell,
                                          let priceCell = self?.collectionView.cellForItem(at: IndexPath(row: 4, section: 2)) as? CustomViewCollectionViewCell,
                                          let addressCell = self?.collectionView.cellForItem(at: IndexPath(row: 5, section: 2)) as? CustomViewCollectionViewCell,
                                          let cityCell = self?.collectionView.cellForItem(at: IndexPath(row: 6, section: 2)) as? CustomViewCollectionViewCell,
                                          let productName = productNameCell.TextFieldView.inputTextField.text,
                                          let description = descriptionCell.textView.text,
                                          let category = categoryCell.TextFieldView.inputTextField.text,
                                          let condition = conditionCell.TextFieldView.inputTextField.text,
                                          let priceString = priceCell.TextFieldView.inputTextField.text,
                                          let price = Double(priceString),
                                          let address = addressCell.TextFieldView.inputTextField.text,
                                          let city = cityCell.TextFieldView.inputTextField.text else {
                                        return
                                    }
                                    
                                    let images = imageIDs
                                    
                                    let createListing = CreateListing(productName: productName, description: description, price: price, category: category.uppercased(), condition: condition, address: address, city: city, images: images)
                                    let createListingEndpoint = CreateListingEndpoint(createLisitng: createListing)
                                    
                                    NetworkManager.shared.request(endpoint: createListingEndpoint) { (result: Result<CreateListingResponse, Error>) in
                                        switch result {
                                        case .success(let createListingResponse):
                                            print("Create Listing success with id: \(createListingResponse.id)")
                                            DispatchQueue.main.async {
                                                self?.navigationController?.popViewController(animated: true)
                                            }
                                        case .failure(let error):
                                            print("Create Listing failure with error: \(error.localizedDescription)")
                                            DispatchQueue.main.async {
                                                self?.showAlert(title: "Something went wrong", message: "Sorry, for strange reason, your listing has not been posted. Please try again", purpleButtonTitle: "OK", whiteButtonTitle: "Cancel")
                                            }
                                        }
                                    }
                                }
                            case .failure(let error):
                                print("Image upload failed with error: \(error.localizedDescription)")
                            }
                        }
                    }
                } else if indexPath.row == 8 {
                    customButtonCell.button.setTitle("Cancel Listing", for: .normal)
                    customButtonCell.button.setTitleColor(UIColor.appColor(LPColor.GrayButtonGray), for: .normal)
                    customButtonCell.button.backgroundColor = .clear
                    customButtonCell.button.layer.borderWidth = 1
                    customButtonCell.button.layer.borderColor = UIColor.appColor(LPColor.GrayButtonGray).cgColor
                    
                    customButtonCell.onButtonTapped = { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                        print("Cancel Sale Button Tapped")
                    }
                }
                
                return customButtonCell
            }
        }
        return UICollectionViewCell()
    }
    
}

extension CreateListingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 283)
        } else if indexPath.section == 1 {
            let itemWidth = collectionView.frame.size.width / 3
            return CGSize(width: itemWidth, height: itemWidth)
        } else {
            if indexPath.row < 7 {
                if indexPath.row == 1 {
                    return CGSize(width: collectionView.frame.size.width, height: 150)
                }
                return CGSize(width: collectionView.frame.size.width, height: 80)
            } else {
                return CGSize(width: collectionView.frame.size.width, height: 51)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2 {
            return UIEdgeInsets(top: 19, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 2 {
            return 19
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension CreateListingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
