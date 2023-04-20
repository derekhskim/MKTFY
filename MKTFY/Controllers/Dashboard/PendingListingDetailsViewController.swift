//
//  PendingListingDetailsViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-17.
//

import UIKit

class PendingListingDetailsViewController: MainViewController, DashboardStoryboard {
    
    var listingResponse: ListingResponse?
    weak var coordinator: MainCoordinator?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        collectionView.register(ImageCarouselCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCarouselCollectionViewCell")
        collectionView.register(CustomViewCollectionViewCell.self, forCellWithReuseIdentifier: "CustomViewCollectionViewCell")
        collectionView.register(CustomTextViewCollectionViewCell.self, forCellWithReuseIdentifier: "CustomTextViewCollectionViewCell")
        collectionView.register(CustomButtonCollectionViewCell.self, forCellWithReuseIdentifier: "CustomButtonCollectionViewCell")
        
    }
    
}

// MARK: - Extension
extension PendingListingDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCarouselCollectionViewCell", for: indexPath) as! ImageCarouselCollectionViewCell
            cell.listingResponse = listingResponse
            return cell
        } else if indexPath.row < 8 {
            return configureTextFieldViewCell(for: indexPath)
        } else {
            return configureCustomButtonCell(for: indexPath)
        }
    }
    
    private func configureTextFieldViewCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let customViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomViewCollectionViewCell", for: indexPath) as? CustomViewCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let fieldTitles = ["Product Name", "Description", "Category", "Condition", "Price", "Address", "City"]
        
        customViewCell.TextFieldView.titleLabel.text = fieldTitles[indexPath.row - 1]
        customViewCell.TextFieldView.inputTextField.backgroundColor = .white
        customViewCell.TextFieldView.inputTextField.tag = indexPath.row
        customViewCell.TextFieldView.inputTextField.isUserInteractionEnabled = false
        customViewCell.TextFieldView.inputTextField.textColor = UIColor.appColor(LPColor.DisabledGray)
        
        if let listingResponse = listingResponse {
            switch indexPath.row {
            case 1:
                customViewCell.TextFieldView.inputTextField.text = listingResponse.productName
            case 3:
                customViewCell.TextFieldView.inputTextField.text = listingResponse.category.lowercased().capitalized.replacingOccurrences(of: "_", with: " ")
            case 4:
                customViewCell.TextFieldView.inputTextField.text = listingResponse.condition.lowercased().capitalized
            case 5:
                customViewCell.TextFieldView.inputTextField.text = String(format: "%.2f", listingResponse.price)
            case 6:
                customViewCell.TextFieldView.inputTextField.text = listingResponse.address
            case 7:
                customViewCell.TextFieldView.inputTextField.text = listingResponse.city
            default:
                break
            }
        }
        
        if indexPath.row == 2 {
            guard let customTextViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomTextViewCollectionViewCell", for: indexPath) as? CustomTextViewCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            customTextViewCell.textView.tag = indexPath.row
            customTextViewCell.titleLabel.text = "Description"
            customTextViewCell.textView.font = UIFont(name: "OpenSans-Regular", size: 14)
            customTextViewCell.textView.isEditable = false
            customTextViewCell.textView.textColor = UIColor.appColor(LPColor.DisabledGray)
            customTextViewCell.textView.text = listingResponse?.description
            
            return customTextViewCell
        }
        return customViewCell
    }
    
    private func configureCustomButtonCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let customButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomButtonCollectionViewCell", for: indexPath) as? CustomButtonCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let buttonTitles = ["Save Changes", "Cancel Listing"]
        let buttonColors: [UIColor] = [.appColor(LPColor.VoidWhite), .appColor(LPColor.GrayButtonGray)]
        let buttonBackgroundColors: [UIColor] = [.appColor(LPColor.OccasionalPurple), .clear]
        let buttonBorderWidths: [CGFloat] = [0, 1]
        let buttonBorderColors: [CGColor] = [UIColor.clear.cgColor, UIColor.appColor(LPColor.GrayButtonGray).cgColor]
        
        customButtonCell.button.setTitle(buttonTitles[indexPath.row - 8], for: .normal)
        customButtonCell.button.setTitleColor(buttonColors[indexPath.row - 8], for: .normal)
        customButtonCell.button.backgroundColor = buttonBackgroundColors[indexPath.row - 8]
        customButtonCell.button.layer.borderWidth = buttonBorderWidths[indexPath.row - 8]
        customButtonCell.button.layer.borderColor = buttonBorderColors[indexPath.row - 8]
        
        if indexPath.row == 8 {
            customButtonCell.onButtonTapped = { [weak self] in
                customButtonCell.button.isUserInteractionEnabled = false
                customButtonCell.button.setTitle("", for: .normal)
                let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                indicator.startAnimating()
                indicator.color = .white
                customButtonCell.button.addSubview(indicator)
                indicator.center = customButtonCell.button.center
                
                
            }
        } else if indexPath.row == 9 {
            customButtonCell.onButtonTapped = { [weak self] in
                DispatchQueue.main.async {
                    self?.showAlert(title: "Heads up!", message: "Are you sure you want to cancel listing?", purpleButtonTitle: "Yes", whiteButtonTitle: "No", purpleButtonAction: {
                        let cancelListingEndpoint = CancelListingEndpoint(id: self?.listingResponse?.id ?? "")
                        NetworkManager.shared.request(endpoint: cancelListingEndpoint) { (result: Result<NetworkManager.EmptyResponse, Error>) in
                            switch result {
                            case .success(_):
                                DispatchQueue.main.async {
                                    self?.coordinator?.goToLoadingConfirmationVC()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                                        self?.coordinator?.goToDashboardVC()
                                    }
                                }
                            case .failure(_):
                                DispatchQueue.main.async {
                                    self?.showAlert(title: "Error", message: "Something went wrong and your listing was not cancelled.", purpleButtonTitle: "Try Again", whiteButtonTitle: "Cancel", purpleButtonAction: {
                                        self?.dismiss(animated: true)
                                    }, whiteButtonAction: {
                                        self?.navigationController?.popViewController(animated: true)
                                    })
                                }
                            }
                        }
                    }, whiteButtonAction: {
                        self?.dismiss(animated: true, completion: nil)
                    })
                }
            }
        }
        
        return customButtonCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 415)
        case 2:
            return CGSize(width: collectionView.bounds.width, height: 150)
        case 8:
            return CGSize(width: collectionView.bounds.width, height: 51)
        case 9:
            return CGSize(width: collectionView.bounds.width, height: 51)
        default:
            return CGSize(width: collectionView.bounds.width, height: 80)
        }
    }
    
}
