//
//  CreateListingViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-04.
//

import PhotosUI
import UIKit

class CreateListingViewController: MainViewController, DashboardStoryboard {
    
    // MARK: - Properties
    weak var coordinator: MainCoordinator?
    var imageArray = [UIImage]()
    var textFieldValues: [Int: String] = [:]
    let textViewDefaultText = "Enter the details of your product"
    
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
        collectionView.register(DropDownCollectionViewCell.self, forCellWithReuseIdentifier: "DropDownCollectionViewCell")
        
        collectionView.reloadData()
    }
    
    // MARK: - Function
    override func textViewDidEndEditing(_ textView: UITextView) {
        textFieldValues[textView.tag] = textView.text
        
        if textView.text == "" {
            textView.text = textViewDefaultText
            textView.textColor = UIColor.appColor(LPColor.TextGray40)
        }
    }
    
    override func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewDefaultText {
            textView.text = nil
            textView.textColor = UIColor.black
        } else if textView.text != textViewDefaultText && textView.textColor == UIColor.appColor(LPColor.TextGray40) {
            textView.textColor = UIColor.black
        }
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
                        self?.showAlert(title: "Photo Library Access Denied", message: "Please grant MKTFY access to your photo library in Settings to upload photos.", purpleButtonTitle: "OK", whiteButtonTitle: "Cancel", purpleButtonAction: {
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                            }
                        }, whiteButtonAction: {
                            self?.dismiss(animated: true, completion: nil)
                        })
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
            showAlert(title: "Photo Library Access Denied", message: "Please grant MKTFY access to your photo library in Settings to upload photos.", purpleButtonTitle: "OK", whiteButtonTitle: "Cancel", purpleButtonAction: {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }}, whiteButtonAction: {
                    self.dismiss(animated: true, completion: nil)
                })
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            if let customDropDownViewCell = cell as? DropDownCollectionViewCell {
                customDropDownViewCell.dropDownTextField.dropDownHelper.updateDropDownPosition()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0, 1:
            return configurePhotoCell(for: indexPath)
        case 2:
            return configureCustomViewCell(for: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    private func configurePhotoCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        cell.photoImageView.gestureRecognizers?.forEach(cell.photoImageView.removeGestureRecognizer)
        
        let isFirstCell = indexPath.section == 0 && imageArray.isEmpty
        let isLastCell = indexPath.section == 1 && indexPath.row == imageArray.count - 1
        let shouldDisplayAddButton = isFirstCell || isLastCell
        
        cell.plusButton?.isHidden = indexPath.section != 0 || !shouldDisplayAddButton
        cell.smallPlusButton?.isHidden = indexPath.section != 1 || !shouldDisplayAddButton
        
        if shouldDisplayAddButton {
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
    }
    
    private func configureCustomViewCell(for indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < 7 {
            return configureTextFieldViewCell(for: indexPath)
        } else {
            return configureCustomButtonCell(for: indexPath)
        }
    }
    
    private func configureTextFieldViewCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let customViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomViewCollectionViewCell", for: indexPath) as? CustomViewCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        customViewCell.TextFieldView.inputTextField.delegate = self
        
        let fieldTitles = ["Product Name", "Description", "Category", "Condition", "Price", "Address", "City"]
        let fieldPlaceholders = ["Enter your product name", "Enter the details of your product", "Choose your category", "Choose the condition of your item", "Enter your desired price", "Enter your address", "Choose your city"]
        
        customViewCell.TextFieldView.titleLabel.text = fieldTitles[indexPath.row]
        customViewCell.TextFieldView.inputTextField.placeholder = fieldPlaceholders[indexPath.row]
        customViewCell.TextFieldView.inputTextField.backgroundColor = .white
        customViewCell.TextFieldView.inputTextField.tag = indexPath.row
        customViewCell.TextFieldView.inputTextField.autocorrectionType = .no
        
        customViewCell.TextFieldView.inputTextField.text = textFieldValues[indexPath.row] ?? ""
        
        if indexPath.row == 1 {
            guard let customTextViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomTextViewCollectionViewCell", for: indexPath) as? CustomTextViewCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            customTextViewCell.textView.delegate = self
            customTextViewCell.textView.tag = indexPath.row
            customTextViewCell.titleLabel.text = "Description"
            customTextViewCell.textView.font = UIFont(name: "OpenSans-Regular", size: 14)
            customTextViewCell.textView.text = textFieldValues[indexPath.row] ?? textViewDefaultText
            customTextViewCell.textView.autocorrectionType = .no
            
            if customTextViewCell.textView.text == textViewDefaultText {
                customTextViewCell.textView.textColor = UIColor.appColor(LPColor.TextGray40)
            } else {
                customTextViewCell.textView.textColor = UIColor.black
            }
            
            return customTextViewCell
        } else {
            switch indexPath.row {
            case 2, 3, 6:
                guard let customDropDownViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DropDownCollectionViewCell", for: indexPath) as? DropDownCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                switch indexPath.row {
                case 2:
                    customDropDownViewCell.configureCell(tag: indexPath.row, title: fieldTitles[indexPath.row], placeHolder: fieldPlaceholders[indexPath.row], options: ["Vehicles", "Furniture", "Electronics", "Real Estate"])
                case 3:
                    customDropDownViewCell.configureCell(tag: indexPath.row, title: fieldTitles[indexPath.row], placeHolder: fieldPlaceholders[indexPath.row], options: ["New", "Used"])
                case 6:
                    customDropDownViewCell.configureCell(tag: indexPath.row, title: fieldTitles[indexPath.row], placeHolder: fieldPlaceholders[indexPath.row], options: ["Calgary", "Camrose", "Brooks"])
                default:
                    break
                }
                customDropDownViewCell.dropDownTextField.inputTextField.autocorrectionType = .no
                customDropDownViewCell.dropDownTextField.inputTextField.delegate = self
                customDropDownViewCell.dropDownTextField.textFieldDelegate = self
                customDropDownViewCell.dropDownTextField.inputTextField.text = textFieldValues[indexPath.row] ?? ""
                
                return customDropDownViewCell
            default:
                break
            }
        }
        
        return customViewCell
    }
    
    private func configureCustomButtonCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let customButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomButtonCollectionViewCell", for: indexPath) as? CustomButtonCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let buttonTitles = ["Publish Listing", "Cancel Listing"]
        let buttonColors: [UIColor] = [.appColor(LPColor.VoidWhite), .appColor(LPColor.GrayButtonGray)]
        let buttonBackgroundColors: [UIColor] = [.appColor(LPColor.OccasionalPurple), .clear]
        let buttonBorderWidths: [CGFloat] = [0, 1]
        let buttonBorderColors: [CGColor] = [UIColor.clear.cgColor, UIColor.appColor(LPColor.GrayButtonGray).cgColor]
        
        customButtonCell.button.setTitle(buttonTitles[indexPath.row - 7], for: .normal)
        customButtonCell.button.setTitleColor(buttonColors[indexPath.row - 7], for: .normal)
        customButtonCell.button.backgroundColor = buttonBackgroundColors[indexPath.row - 7]
        customButtonCell.button.layer.borderWidth = buttonBorderWidths[indexPath.row - 7]
        customButtonCell.button.layer.borderColor = buttonBorderColors[indexPath.row - 7]
        
        if indexPath.row == 7 {
            customButtonCell.onButtonTapped = { [weak self] in
                
                customButtonCell.button.isUserInteractionEnabled = false
                customButtonCell.button.setTitle("", for: .normal)
                let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                indicator.startAnimating()
                indicator.color = .white
                customButtonCell.button.addSubview(indicator)
                indicator.center = customButtonCell.button.center
                
                let images: [UIImage] = self!.imageArray
                let uploadImageEndpoint = UploadImageEndpoint(images: images)
                
                NetworkManager.shared.request(endpoint: uploadImageEndpoint){ (result: Result<[ImageResponse], Error>) in
                    switch result {
                    case .success(let imageResponse):
                        let imageIDs = imageResponse.map {$0.id}
                        DispatchQueue.main.async {
                            indicator.removeFromSuperview()
                            customButtonCell.button.setTitle("Publish Listing", for: .normal)
                            customButtonCell.button.isUserInteractionEnabled = true
                            
                            guard let productNameCell = self?.collectionView.cellForItem(at: IndexPath(row: 0, section: 2)) as? CustomViewCollectionViewCell,
                                  let descriptionCell = self?.collectionView.cellForItem(at: IndexPath(row: 1, section: 2)) as? CustomTextViewCollectionViewCell,
                                  let categoryCell = self?.collectionView.cellForItem(at: IndexPath(row: 2, section: 2)) as? DropDownCollectionViewCell,
                                  let conditionCell = self?.collectionView.cellForItem(at: IndexPath(row: 3, section: 2)) as? DropDownCollectionViewCell,
                                  let priceCell = self?.collectionView.cellForItem(at: IndexPath(row: 4, section: 2)) as? CustomViewCollectionViewCell,
                                  let addressCell = self?.collectionView.cellForItem(at: IndexPath(row: 5, section: 2)) as? CustomViewCollectionViewCell,
                                  let cityCell = self?.collectionView.cellForItem(at: IndexPath(row: 6, section: 2)) as? DropDownCollectionViewCell,
                                  let productName = productNameCell.TextFieldView.inputTextField.text,
                                  let description = descriptionCell.textView.text,
                                  let category = categoryCell.dropDownTextField.inputTextField.text,
                                  let condition = conditionCell.dropDownTextField.inputTextField.text,
                                  let priceString = priceCell.TextFieldView.inputTextField.text,
                                  let price = Double(priceString),
                                  let address = addressCell.TextFieldView.inputTextField.text,
                                  let city = cityCell.dropDownTextField.inputTextField.text else { return }
                            
                            let createListing = CreateListing(productName: productName, description: description, price: price, category: category.uppercased().replacingOccurrences(of: " ", with: "_"), condition: condition.uppercased(), address: address, city: city.capitalized, images: imageIDs)
                            let createListingEndpoint = CreateListingEndpoint(createLisitng: createListing)
                            
                            NetworkManager.shared.request(endpoint: createListingEndpoint) { (result: Result<ListingResponse, Error>) in
                                switch result {
                                case .success(let createListingResponse):
                                    print("Create Listing success with id: \(createListingResponse.id)")
                                    
                                    DispatchQueue.main.async {
                                        self?.coordinator?.goToLoadingConfirmationVC()
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                                        self?.coordinator?.goToDashboardVC()
                                    }
                                case .failure(let error):
                                    print("Create Listing failure with error: \(error.localizedDescription)")
                                    DispatchQueue.main.async {
                                        self?.showAlert(title: "Something went wrong", message: "Sorry, for strange reason, your listing has not been posted. Please try again", purpleButtonTitle: "OK", whiteButtonTitle: "Cancel", purpleButtonAction: {
                                            self?.dismiss(animated: true, completion: nil)
                                        }, whiteButtonAction: {
                                            self?.navigationController?.popViewController(animated: true)
                                        })
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        print("Image upload failed with error: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            indicator.removeFromSuperview()
                            customButtonCell.button.setTitle("Publish Listing", for: .normal)
                            customButtonCell.button.isUserInteractionEnabled = true
                            
                            self?.showAlert(title: "Image Upload Error!", message: "\(error.localizedDescription)", purpleButtonTitle: "Try Again", whiteButtonTitle: "Cancel", purpleButtonAction: {
                                self?.dismiss(animated: true)
                            }, whiteButtonAction: {
                                self?.navigationController?.popViewController(animated: true)
                            })
                        }
                    }
                }
            }
        } else if indexPath.row == 8 {
            customButtonCell.onButtonTapped = { [weak self] in
                DispatchQueue.main.async {
                    self?.showAlert(title: "Heads up!", message: "Are you sure you want to cancel your listing?", purpleButtonTitle: "Yes", whiteButtonTitle: "No", purpleButtonAction: {
                        self?.navigationController?.popViewController(animated: true)
                    }, whiteButtonAction: {
                        self?.dismiss(animated: true, completion: nil)
                    })
                }
            }
        }
        
        return customButtonCell
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldValues[textField.tag] = textField.text
    }
}
